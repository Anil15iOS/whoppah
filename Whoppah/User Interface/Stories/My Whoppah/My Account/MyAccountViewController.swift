//
//  MyAccountViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/12/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import Stripe
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver

class MyAccountViewController: UIViewController {
    private enum TableRow: Int {
        case myAds = 0
        case favorites
        case profile
        case contactInfo
        case settings
        case payment
        case savedSearches
        case help
    }

    // MARK: - IBOutlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Properties

    private var items: [MenuItem] = []
    private var routingData: Navigator.MyWhoppahRoutingData? {
        didSet {
            guard let data = routingData else { return }
            performRouting(data)
        }
    }

    private let bag = DisposeBag()
    private var user: LegacyMember?
    
    @Injected private var crashReporter: CrashReporter
    @Injected private var userService: WhoppahCore.LegacyUserService

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUser()
        setUpTableView()
        performRouting(routingData)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
        setupTableViewHeader()
    }

    func navigate(data: Navigator.MyWhoppahRoutingData) {
        routingData = data
    }

    func refresh() {
        generateData()
        tableView.reloadData()
    }

    private func performRouting(_ data: Navigator.MyWhoppahRoutingData?) {
        if let data = data, userService.current != nil, isViewLoaded {
            switch data.tab {
            case let .account(section):
                switch section {
                case .payment:
                    let path = IndexPath(row: TableRow.payment.rawValue, section: 0)
                    tableView(tableView, didSelectRowAt: path)
                case .contact:
                    let path = IndexPath(row: TableRow.contactInfo.rawValue, section: 0)
                    tableView(tableView, didSelectRowAt: path)
                case .search:
                    let path = IndexPath(row: TableRow.savedSearches.rawValue, section: 0)
                    tableView(tableView, didSelectRowAt: path)
                case .settings:
                    let path = IndexPath(row: TableRow.settings.rawValue, section: 0)
                    tableView(tableView, didSelectRowAt: path)
                case .myAds:
                    let path = IndexPath(row: TableRow.myAds.rawValue, section: 0)
                    tableView(tableView, didSelectRowAt: path)
                default:
                    break
                }
            default:
                break
            }
            routingData = nil
        }
    }

    private func setupUser() {
        userService.active
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] member in
                guard let self = self else { return }
                self.user = member
                self.generateData()
                self.tableView.reloadData()
                if let data = self.routingData {
                    self.performRouting(data)
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.crashReporter.log(error: error)
                self.showError(error)
            }).disposed(by: bag)
    }

    private func generateData() {
        items.removeAll()
        if user != nil {
            items.append(MenuItem(title: R.string.localizable.main_my_profile_my_ads(), icon: R.image.ic_couch()))
            items.append(MenuItem(title: R.string.localizable.main_favs_title(), icon: R.image.ic_heart()))
            items.append(MenuItem(title: R.string.localizable.main_my_profile_navigation_title(), icon: R.image.ic_profile()))
            items.append(MenuItem(title: R.string.localizable.main_my_profile_contacts(), icon: R.image.ic_location()))
            items.append(MenuItem(title: R.string.localizable.main_my_profile_account_settings(), icon: R.image.ic_settings()))
            items.append(MenuItem(title: R.string.localizable.main_my_profile_payment(), icon: R.image.ic_payment_settings()))
            items.append(MenuItem(title: R.string.localizable.main_my_profile_my_searches(), icon: R.image.ic_search_black()))
            items.append(MenuItem(title: R.string.localizable.main_my_profile_faq(), icon: R.image.ic_help()))
        }
    }

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: MenuCell.nibName, bundle: nil), forCellReuseIdentifier: MenuCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
    }

    private func setupTableViewHeader() {
        var missing: [String] = []
        if user?.mainMerchant.address.isEmpty == true { missing.append(R.string.localizable.createAdShippingAddressTitle()) }
        if user?.mainMerchant.phone?.isEmpty == true { missing.append(R.string.localizable.commonPhoneNumberPlaceholder()) }
        if user?.dob == nil { missing.append(R.string.localizable.commonDateOfBirth()) }
        if user?.isProfessional == true, user?.mainMerchant.vatId?.isEmpty == true { missing.append(R.string.localizable.set_profile_merchant1_vat()) }
        if user?.isProfessional == true, user?.mainMerchant.taxId?.isEmpty == true { missing.append(R.string.localizable.set_profile_merchant1_kvk()) }
        if user?.mainMerchant.bank?.isValid() != true { missing.append(R.string.localizable.editBankIbanPlaceholder()) }

        if !missing.isEmpty {
            let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44)
            let missing = R.string.localizable.missing_profile_fields(missing.joined(separator: ", "))
            let tableHeaderView = ProfileMissingHeaderView(frame: frame, missing: missing)
            tableHeaderView.event.bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.user?.mainMerchant.bank?.isValid() != true {
                    self.tableView(self.tableView, didSelectRowAt: IndexPath(row: TableRow.payment.rawValue, section: 0))
                } else {
                    self.tableView(self.tableView, didSelectRowAt: IndexPath(row: TableRow.contactInfo.rawValue, section: 0))
                }
            }).disposed(by: bag)
            tableView.tableHeaderView = tableHeaderView
        } else {
            let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 76)
            tableView.tableHeaderView = ProfileCompletedHeaderView(frame: frame)
        }
    }

    private func openSearch(nav: UINavigationController?) {
        let mySearchesVC: MySearchesViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
        nav?.pushViewController(mySearchesVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MyAccountViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier) as! MenuCell
        cell.configure(with: items[indexPath.row])
        cell.backgroundColor = .white
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MyAccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let tabsVC = parent?.parent?.parent?.parent as? TabsViewController else { return }
        switch indexPath.row {
        case TableRow.myAds.rawValue:
            let myAds: MyAdsViewController = UIStoryboard.storyboard(storyboard: .myWhoppah).instantiateViewController()
            let activeRepo = MyListRepositoryImpl(state: [.accepted], auction: [.published, .reserved])
            let curatedRepo = MyListRepositoryImpl(state: [.curation], auction: [])
            let rejectedRepo = MyListRepositoryImpl(state: [.rejected], auction: [])
            let draftRepo = MyListRepositoryImpl(state: [.draft], auction: [])
            let soldRepo = OrderRepositoryImpl(state: [.completed])
            let productRepo = ProductDetailsRepositoryImpl()
            myAds.viewModel = MyAdsViewModel(activeRepo: activeRepo,
                                             curatedRepo: curatedRepo,
                                             rejectedRepo: rejectedRepo,
                                             draftsRepo: draftRepo,
                                             soldRepo: soldRepo,
                                             productRepo: productRepo)
            tabsVC.navigationController?.pushViewController(myAds, animated: true)
        case TableRow.favorites.rawValue:
            let coordinator = FavoritesCoordinator(navigationController: tabsVC.navigationController!)
            coordinator.start(withNavBar: true)
        case TableRow.profile.rawValue:
            let coordinator = EditProfileCoordinator(navigationController: tabsVC.navigationController!)
            coordinator.start(merchant: user!.mainMerchant)
        case TableRow.contactInfo.rawValue:
            let coordinator = ContactInfoCoordinator(navigationController: tabsVC.navigationController!)
            coordinator.start()
        case TableRow.settings.rawValue:
            let accountSettingsVC: AccountSettingsViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
            tabsVC.navigationController?.pushViewController(accountSettingsVC, animated: true)
        case TableRow.payment.rawValue:
            let coordinator = BankDetailsCoordinator(navigationController: tabsVC.navigationController!)
            coordinator.start()
        case TableRow.savedSearches.rawValue:
            openSearch(nav: tabsVC.navigationController)
        case TableRow.help.rawValue:
            let helpContactVC: HelpContactViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
            tabsVC.navigationController?.pushViewController(helpContactVC, animated: true)
        default:
            break
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        44.0
    }
}
