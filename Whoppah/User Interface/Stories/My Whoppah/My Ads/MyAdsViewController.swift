//
//  MyAdsViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/12/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver

class MyAdsViewController: UIViewController {
    // MARK: Properties

    var viewModel: MyAdsViewModel!
    @Injected private var eventTracking: EventTrackingService
    @Injected private var user: WhoppahCore.LegacyUserService

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingView: LoadingView!

    lazy var postAdView: InfoActionView = {
        let view = InfoActionView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: InfoActionView.estimatedHeight))
        view.configure(with: R.string.localizable.myProfileMyAdsCreateAdTitle(),
                       description: R.string.localizable.myProfileMyAdsCreateAdDescription(),
                       action: R.string.localizable.myProfileMyAdsCreateAdButton(),
                       isSeparatorHidden: false)
        return view
    }()

    var requestLoadAds: Bool = true
    private let bag = DisposeBag()

    private var routingData: Navigator.MyWhoppahRoutingData? {
        didSet {
            if isViewLoaded, let id = getRoutingAd() {
                navigateToAd(withID: id)
            }
        }
    }

    private var isDraftRowVisible: Bool {
        tableView.numberOfRows(inSection: 0) == 5
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupTableView()
        setUpBindings()

        requestLoadAds = true

        if let id = getRoutingAd() {
            navigateToAd(withID: id)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if requestLoadAds || viewModel!.isDirty {
            loadUserAds()
        }
    }

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.main_my_profile_my_ads()
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    // MARK: Misc

    private func loadUserAds() {
        tableView.isVisible = false
        loadingView.startAnimating()
        loadingView.isHidden = false
        requestLoadAds = false

        user.active
            .compactMap { $0 }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] member in
                self?.viewModel.fetchMyAds(userId: member.id)
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
    }

    func refresh() {
        requestLoadAds = true
        if isViewLoaded {
            loadUserAds()
        }
    }

    func navigate(data: Navigator.MyWhoppahRoutingData) {
        routingData = data
    }

    private func getRoutingAd() -> UUID? {
        guard let data = routingData else { return nil }
        guard case let .myAds(section) = data.tab else { return nil }
        guard case let .ad(id) = section else { return nil }
        return id
    }

    private func navigateToAd(withID id: UUID?) {
        guard let id = id else { return }
        requestLoadAds = true // Reload ads on return - why??!
        guard let tabsVC = getTabsVC() else { return }
        let adDetailVC: MyAdStatisticsViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
        let viewModel = MyAdStatisticsViewModel(withID: id,
                                                repo: MyAdStatisticsRepositoryImpl())
        adDetailVC.viewModel = viewModel
        tabsVC.navigationController?.pushViewController(adDetailVC, animated: true)
    }

    // MARK: Privates

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = MyAdsCell.estimatedHeight
        tableView.register(MyAdsCell.self, forCellReuseIdentifier: MyAdsCell.identifier)
        tableView.tableFooterView = postAdView
    }

    private func setUpBindings() {
        let latest = Observable.combineLatest(viewModel.outputs.activeList,
                                              viewModel.outputs.curatedList,
                                              viewModel.outputs.draftList,
                                              viewModel.outputs.rejectedList,
                                              viewModel.outputs.soldList)

        latest.observeOn(MainScheduler.instance)
            .map { _ in true }
            .bind(to: tableView.rx.isVisible, loadingView.rx.isHidden)
            .disposed(by: bag)

        latest.observeOn(MainScheduler.instance)
            .map({ (active, curated, drafted, rejected, sold) -> [(totalCount: Int, elements: [AdViewModel])?] in
                if curated.totalCount == 0 {
                    return [active, drafted, rejected, sold]
                } else {
                    return [active, curated, drafted, rejected, sold]
                }
            })
            .bind(to: tableView.rx.items(cellIdentifier: MyAdsCell.identifier, cellType: MyAdsCell.self)) { [weak self] row, data, cell in
                switch row {
                case 0:
                    guard let data = data else { return }
                    cell.configure(with: R.string.localizable.myProfileMyAdsActive(data.totalCount), isEnabled: !data.elements.isEmpty)
                case 1:
                    guard let data = data else { return }
                    cell.configure(with: R.string.localizable.myProfileMyAdsCuration(data.totalCount), isEnabled: !data.elements.isEmpty)
                case 2:
                    guard let data = data else { return }
                    if self?.isDraftRowVisible == true {
                        cell.configure(with: R.string.localizable.myProfileMyAdsDrafts(data.totalCount), isEnabled: !data.elements.isEmpty)
                    } else {
                        cell.configure(with: R.string.localizable.myProfileMyAdsRejected(data.totalCount), isEnabled: !data.elements.isEmpty)
                    }
                case 3:
                    guard let data = data else { return }
                    if self?.isDraftRowVisible == true {
                        cell.configure(with: R.string.localizable.myProfileMyAdsRejected(data.totalCount), isEnabled: !data.elements.isEmpty)
                    } else {
                        cell.configure(with: R.string.localizable.myProfileMyAdsSold(data.totalCount), isEnabled: !data.elements.isEmpty)
                    }
                default:
                    guard let data = data else { return }
                    cell.configure(with: R.string.localizable.myProfileMyAdsSold(data.totalCount), isEnabled: !data.elements.isEmpty)
                }
            }.disposed(by: bag)

        tableView.rx.itemSelected.bind { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            switch indexPath.row {
            case 0:
                self?.showAdList(forType: .active)
            case 1:
                self?.showAdList(forType: .curated)
            case 2:
                self?.isDraftRowVisible == true ? self?.showAdList(forType: .draft) : self?.showAdList(forType: .rejected)
            case 3:
                self?.isDraftRowVisible == true ? self?.showAdList(forType: .rejected) : self?.showAdList(forType: .sold)
            default:
                self?.showAdList(forType: .sold)
            }
        }.disposed(by: bag)

        postAdView.tapEvent.bind { [weak self] _ in
            self?.postAd()
        }.disposed(by: bag)
    }

    // MARK: Actions

    @objc func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func postAd() {
        eventTracking.createAd.trackCreateAnotherAdInMyAds()
        let nav = WhoppahNavigationController()
        nav.isNavigationBarHidden = true
        nav.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
        let coordinator = CreateAdOnboardingCoordinatorImpl(navigationController: nav)
        coordinator.start()
        present(nav, animated: true, completion: nil)
    }

    private func showAdList(forType type: AdListType) {
        guard let tabsVC = getTabsVC(), let user = user.current else { return }
        switch type {
        case .active, .rejected, .curated, .draft:
            let activeAdsVC: MyAdListOverviewViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
            let userID = user.id
            let adListVM = viewModel!.getAdListViewModel(forType: type, userID: userID)
            activeAdsVC.viewModel = adListVM
            tabsVC.navigationController?.pushViewController(activeAdsVC, animated: true)
        case .sold:
            guard let tabsVC = getTabsVC() else { return }
            let myIncomeVC: MyIncomeViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
            myIncomeVC.viewModel = viewModel!.getMyIncomeViewModel()
            tabsVC.navigationController?.pushViewController(myIncomeVC, animated: true)
        }
    }

    private func navigateToAd(_ viewModel: AdViewModel, ofType type: AdListType) {
        guard let tabsVC = getTabsVC() else { return }
        let adID = viewModel.product.id
        switch type {
        case .active, .rejected, .curated, .draft:
            let adDetailVC: MyAdStatisticsViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
            let viewModel = MyAdStatisticsViewModel(withID: adID,
                                                    repo: MyAdStatisticsRepositoryImpl())
            adDetailVC.viewModel = viewModel
            tabsVC.navigationController?.pushViewController(adDetailVC, animated: true)
        case .sold:
            let navigationVC = UINavigationController()
            navigationVC.isNavigationBarHidden = true
            navigationVC.isModalInPresentation = true
            if UIDevice.current.userInterfaceIdiom != .pad { navigationVC.modalPresentationStyle = .fullScreen }
            let coordinator = AdDetailsCoordinator(navigationController: navigationVC)
            coordinator.start(adID: adID)
            present(navigationVC, animated: true, completion: nil)
        }
    }
}
