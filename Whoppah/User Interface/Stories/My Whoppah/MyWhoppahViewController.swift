//
//  MyWhoppahViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/3/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import GoogleSignIn
import RxSwift
import UIKit
import WhoppahCoreNext
import Resolver

class MyWhoppahViewController: UIViewController {
    enum Tab: Int {
        case myAds = 0
        case myAccount
    }

    // MARK: - IBOutlets

    @IBOutlet var containerView: UIView!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var verifiedImage: UIImageView!
    @IBOutlet var userInfoContainer: UIView!

    // MARK: - Properties

    private var myAccountNavigation: UINavigationController!
    private var mySettingsVC: MyAccountViewController? {
        didSet {
            if let data = routingData {
                mySettingsVC?.navigate(data: data)
            }
        }
    }

    private var myAdsNavigation: UINavigationController!
    private var myAdsVC: MyAdsViewController? {
        didSet {
            if let data = routingData {
                myAdsVC?.navigate(data: data)
            }
        }
    }

    private var currentViewController: UIViewController?
    var viewModel: MyWhoppahViewModel!
    var routingData: Navigator.MyWhoppahRoutingData? {
        didSet {
            if isViewLoaded {
                selectTab(initialTab)

                guard let data = routingData else { return }
                switch data.tab {
                case .account:
                    mySettingsVC?.navigate(data: data)
                case .myAds:
                    myAdsVC?.navigate(data: data)
                }
            }
        }
    }

    var initialTab: Tab {
        guard let routing = routingData else { return .myAccount }
        switch routing.tab {
        case .account:
            return .myAccount
        case .myAds:
            return .myAds
        }
    }

    private let bag = DisposeBag()

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
        setUpAvatarView()
        setUpViewModel()
        selectTab(initialTab)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isMovingToParent || navigationController?.isMovingToParent == true {
            loadUser()
        }
    }

    // MARK: - Private

    private func setUpGestures() {
        if let recognisers = userInfoContainer.gestureRecognizers {
            for gesture in recognisers {
                userInfoContainer.removeGestureRecognizer(gesture)
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPublicProfile(_:)))
        userInfoContainer.addGestureRecognizer(tap)
    }

    private func setUpControllers() {
        let settingsVC: MyAccountViewController = UIStoryboard.storyboard(storyboard: .myWhoppah).instantiateViewController()
        myAccountNavigation = WhoppahNavigationController(rootViewController: settingsVC)
        myAccountNavigation.isNavigationBarHidden = true
        mySettingsVC = settingsVC

        let vc: MyAdsViewController = UIStoryboard.storyboard(storyboard: .myWhoppah).instantiateViewController()
        let activeRepo = MyListRepositoryImpl(state: [.accepted], auction: [.published, .reserved])
        let curatedRepo = MyListRepositoryImpl(state: [.curation], auction: [])
        let rejectedRepo = MyListRepositoryImpl(state: [.rejected], auction: [])
        let draftRepo = MyListRepositoryImpl(state: [.draft], auction: [])
        let soldRepo = OrderRepositoryImpl(state: [.completed])
        let productRepo = ProductDetailsRepositoryImpl()
        vc.viewModel = MyAdsViewModel(activeRepo: activeRepo,
                                      curatedRepo: curatedRepo,
                                      rejectedRepo: rejectedRepo,
                                      draftsRepo: draftRepo,
                                      soldRepo: soldRepo,
                                      productRepo: productRepo)
        myAdsNavigation = UINavigationController(rootViewController: vc)
        myAdsNavigation.isNavigationBarHidden = true
        myAdsVC = vc
    }

    private func setUpViewModel() {
        viewModel.outputs.uiData.subscribe(onNext: { [weak self] uiData in
            guard let self = self, let data = uiData else { return }
            self.updateData(uiData: data)
        }).disposed(by: bag)
    }

    private func loadUser() {
        viewModel.loadUser()
        myAdsVC?.refresh()
    }

    func navigate(data: Navigator.MyWhoppahRoutingData) {
        routingData = data
    }

    private func selectTab(_ tab: Tab) {
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        var navC: UINavigationController

        switch tab {
        case .myAds:
            navC = myAdsNavigation
        case .myAccount:
            navC = myAccountNavigation
        }

        addChild(navC)
        navC.view.frame = containerView.bounds
        containerView.addSubview(navC.view)
        navC.didMove(toParent: self)
        currentViewController = navC
    }

    private func setUpAvatarView() {
        avatarView.makeCircular()

        let tap = UITapGestureRecognizer(target: self, action: #selector(showPublicProfile(_:)))
        avatarView.addGestureRecognizer(tap)
        avatarView.isUserInteractionEnabled = false
    }

    private func updateData(uiData: MyWhoppahUIData) {
        avatarView.setIcon(forUrl: uiData.avatarUrl, cacheKey: uiData.avatarId?.uuidString, character: uiData.avatarCharacter)
        if let city = uiData.city {
            cityLabel.text = city
            cityLabel.isVisible = true
        } else {
            cityLabel.isVisible = false
        }
        avatarView.isUserInteractionEnabled = true
        usernameLabel.text = uiData.name
        verifiedImage.isVisible = uiData.isVerified
        setUpGestures()
    }

    @objc func showPublicProfile(_: UITapGestureRecognizer) {
        viewModel.showPublicProfile()
    }

    // MARK: - Actions

    @IBAction func editProfileAction(_: UIButton) {
        viewModel.editProfile()
    }
}
