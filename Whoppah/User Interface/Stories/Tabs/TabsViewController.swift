//
//  RootViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import WhoppahUI
import WhoppahModel
import SwiftUI
import Resolver
import Combine

class TabsViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var tabBar: TabBar!
    @IBOutlet var containerView: UIView!
    @IBOutlet var searchField: SearchField!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var searchBarStackView: UIStackView!
    @IBOutlet var searchBarContainer: UIView!
    @IBOutlet weak var sparkImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var suggestionsTableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties

    private var homeCoordinator: HomeCoordinator!
    private var favoritesNavigation: UINavigationController!
    private var myWhoppahNavigation: UINavigationController!
    private var threadAndChatCoordinator: ThreadsCoordinator!

    @LazyInjected private var pushNotificationService: PushNotificationsService
    @LazyInjected private var userService: WhoppahCore.LegacyUserService
    @LazyInjected private var userProvider: UserProviding
    @LazyInjected private var crashReporter: CrashReporter
    @LazyInjected private var searchService: SearchService
    @LazyInjected private var chatService: ChatService
    @LazyInjected private var cacheService: CacheService
    @LazyInjected private var eventTrackingService: EventTrackingService
    @LazyInjected private var deepLinkCoordinator: DeepLinkCoordinator

    var currentViewController: UIViewController?
    private var categoryRepo: WhoppahCore.CategoryRepository?
    private var searchRepo: LegacySearchRepository?
    private var coordinator: TabsCoordinator!
    private var bag = DisposeBag()
    private let backgroundUnreadCountIntervalSecs = 60.0 * 3
    private var backgroundMonitor: AppBackgroundMonitorTimer?
    
    private let searchCellIdentifier = "SearchSuggestionCell"
    private var suggestions: [String] = []
    
    private var menuViewController: MenuHostingController?
  
    private var cancellables = Set<AnyCancellable>()
    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.delegate = self
        coordinator = TabsCoordinator(navigationController: navigationController!)
        setUpControllers()
        setUpSearchField()
        setUpTableView()
        setUpSideMenu()
        openHome()
        setupRouting()

        setUpUser()
        setUpChatBadge()
    
        let screenScale = min(UIScreen.main.bounds.width / 414, 1.0)
        sparkImageView.image = R.image.sparkOrange()
    
        usernameLabel.font = UIFont.systemFont(ofSize: screenScale * 32, weight: .bold)
        usernameLabel.textColor = .orange
        
        searchRepo?.suggestionData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.suggestions = result.querySuggestions
                self?.suggestionsTableView.reloadData()
            }, onError: { error in
                print(error)
            }).disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
     
        // Search may have updated in a child VC
        searchField.textField.text = searchService.searchText
        searchField.clearButton.isHidden = searchService.searchText?.isEmpty ?? true
        searchField.state = searchService.searchText?.isEmpty == false ? .filled : .empty

        if tabBar.selectedTab == .home {
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification?) {
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight: CGFloat
        
        keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom - tabBarHeightConstraint.constant

        tableViewBottomConstraint.constant = keyboardHeight
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchField.textField.resignFirstResponder()
    }
    
    // MARK: Public

    enum DialogDisplay {
        case shown
        case notShown
    }

    func openSplashIfNeeded() {
        guard !userProvider.isLoggedIn else {
            userProvider.fetchActiveUser()
            return
        }
        coordinator.openSignupSplash()
    }

    @discardableResult
    func openContextualSignupIfNeeded(title: String, description: String, requiresCompleteProfile: Bool = false, _ completion: (() -> Void)? = nil) -> DialogDisplay {
        // There is a possibility that we have an access token but the user object hasn't been fetched yet (or has failed)
        // In this scenario we have a couple of different options:
        // 1) Display an error, and presume that the user object will be fetch. We could kick off a user object fetch at this point or
        //    somehow tell if the user is being fetched currently.
        // 2) Push the user towards the splash screen to log in, however the user object may well be fetched after
        // 3) Disable the UI until the user object is indeed fetched
        // Option 2) is slightly better, if for some reason the user object is not coming down at all then a fetch will not rectify this
        // Ideally we'd cancel all pending user-related activities upon showing the splash screen
        // Making a user log in again will ensure we do get a new user object, albeit at the expense of a poorer user experience
        if userProvider.isLoggedIn {
            if requiresCompleteProfile {
                if userProvider.currentUser != nil {
                    if !userProvider.hasCompletedProfile {
                        let dialog = CompleteMerchantProfileDialog()
                        dialog.onOkTapped = {
                            Navigator().navigate(route: Navigator.Route.profileCompletion)
                        }

                        present(dialog, animated: true, completion: nil)
                        return .shown
                    }
                    completion?()
                    return .notShown
                }
            } else {
                // Check if logged in
                completion?()
                return .notShown
            }
        }

        // Make sure we don't re-show the VC
        if navigationController?.visibleViewController as? ContextualSignupDialogHostingController != nil {
            return .shown
        }
        coordinator.openContextualSignup(title: title, description: description)
        return .shown
    }

    // MARK: Actions

    @IBAction func menuAction(_: UIButton) {
        guard let menuViewController = self.menuViewController else {
            return
        }

        searchField.textField.resignFirstResponder()
        present(menuViewController, animated: false, completion: nil)
    }

    @IBAction func backAction(_: UIButton) {
        homeCoordinator.navigationController.popViewController(animated: true)
    }

    // MARK: - Private

    private func setUpUser() {
        userProvider.$accessToken.sink { _ in } receiveValue: { [weak self] token in
            guard let self = self else { return }
            if token == nil {
                self.userLoggedOut()
            } else {
                self.updateChatBadge()
            }
        }
        .store(in: &cancellables)

        userProvider.currentUserPublisher?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.crashReporter.log(error: error)
                    self?.showError(error)
                default: break
                }
            }, receiveValue: { [weak self] member in
                guard let self = self else { return }
                
                if let member = member {
                    let userName = member.mainMerchant?.name ?? member.givenName
                    
                    self.usernameLabel.text = R.string.localizable.user_greeting_home_page(userName)
                    self.toggleUserGreeting(hidden: !(self.tabBar.selectedTab == .home))
                } else {
                    self.usernameLabel.text = ""
                    self.toggleUserGreeting(hidden: true)
                }
            })
            .store(in: &cancellables)
        
        if userProvider.isLoggedIn { userProvider.fetchActiveUser() }
    }

    private func userLoggedOut() {
        DispatchQueue.main.async {
            self.tabBar.chatBadgeNumber = 0
            self.openSplashIfNeeded()
        }
    }
    
    private func setUpTableView() {
        suggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: searchCellIdentifier)
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
    }

    private func setUpControllers() {
        let homeNav = SwipeNavigationController()
        homeNav.isNavigationBarHidden = true
        categoryRepo = cacheService.categoryRepo
        searchRepo = LegacySearchRepositoryImpl()
        homeCoordinator = HomeCoordinator(navigationController: homeNav, categoryRepo: categoryRepo!)

        favoritesNavigation = SwipeNavigationController()
        favoritesNavigation.isNavigationBarHidden = true
        let coordinator = FavoritesCoordinator(navigationController: favoritesNavigation)
        coordinator.start(withNavBar: false)

        myWhoppahNavigation = SwipeNavigationController()
        myWhoppahNavigation.isNavigationBarHidden = true
        let mywhoppahCoordinator = MyWhoppahCoordinator(navigationController: myWhoppahNavigation)
        mywhoppahCoordinator.start()

        let navigationController = SwipeNavigationController()
        navigationController.isNavigationBarHidden = true
        threadAndChatCoordinator = ThreadsCoordinator(navigationController: navigationController)
        threadAndChatCoordinator.start()
    }

    private func setUpSearchField() {
        searchField.textField.placeholder = R.string.localizable.search_input_hint()
        searchField.delegate = self
    }

    private func setUpSideMenu() {
        let menuViewController: MenuHostingController = MenuHostingController()
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.delegate = self
        self.menuViewController = menuViewController
    }

    private func setUpChatBadge() {
        chatService.unread
            .drive(onNext: { [weak self] count in
                self?.tabBar.chatBadgeNumber = count
            }).disposed(by: bag)

        // If the user has been in the background for x seconds we update the chat badge
        backgroundMonitor = AppBackgroundMonitorTimer(interval: backgroundUnreadCountIntervalSecs) { [weak self] in
            guard let self = self else { return }
            self.updateChatBadge()
        }

        NotificationCenter.default.rx.notification(InAppNotifier.NotificationName.updateChatBadgeCount.name, object: nil)
            .throttle(RxTimeInterval.milliseconds(250), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.updateChatBadge()
            }).disposed(by: bag)
    }

    private func toggleSearchBar(hidden: Bool) {
        searchBarContainer.isHidden = hidden
        searchBarStackView.layoutIfNeeded()
    }
    
    private func toggleUserGreeting(hidden: Bool) {
        sparkImageView.isHidden = hidden
        usernameLabel.isHidden = hidden
    }
   
    private func updateChatBadge() {
        guard userService.isLoggedIn else { return }
        chatService.updateUnreadCount()
    }

    private func openTab(_ type: TabBar.Tab) {
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        var navVC: UINavigationController
        switch type {
        case .home:
            navVC = homeCoordinator.navigationController
        case .favorites:
            navVC = favoritesNavigation
        case .myWhoppah:
            navVC = myWhoppahNavigation
        case .chat:
            navVC = threadAndChatCoordinator.navigationController
        }

        menuButton.isHidden = type != .home && type != .favorites

        addChild(navVC)
        navVC.view.frame = containerView.bounds
        containerView.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        currentViewController = navVC

        switch type {
        case .home:
            if let homeVC = navVC.viewControllers.first as? HomeViewController {
                // Reload home if switching from another tab
                if tabBar.selectedTab != type {
                    homeVC.reloadAll()
                }
                navVC.popToRootViewController(animated: true)
                homeVC.scrollToTop()
            }
            toggleSearchBar(hidden: false)
            toggleUserGreeting(hidden: (usernameLabel.text ?? "").isEmpty)
        case .myWhoppah:
            toggleSearchBar(hidden: true)
            toggleUserGreeting(hidden: true)
            // Segment.io
            eventTrackingService.trackMyWhoppahClicked()
        case .chat:
            eventTrackingService.trackChatsClicked()
            toggleSearchBar(hidden: true)
            toggleUserGreeting(hidden: true)
            // Reload threads if switching to the tab
            if tabBar.selectedTab != type {
                threadAndChatCoordinator.openThreads()
            }
        case .favorites:
            toggleSearchBar(hidden: false)
            toggleUserGreeting(hidden: true)
            // Segment.io
            eventTrackingService.trackFavoritesClicked()
        }

        tabBar.selectedTab = type
    }

    private func openHome() {
        openTab(.home)
    }

    private func openMyWhoppah(data: Navigator.MyWhoppahRoutingData = Navigator.MyWhoppahRoutingData(withSection: .none)) {
        openTab(.myWhoppah)
        guard let myWhoppahVC = myWhoppahNavigation.viewControllers.first as? MyWhoppahViewController else { return }
        myWhoppahVC.navigate(data: data)
    }

    private func openThreads() {
        openTab(.chat)

        threadAndChatCoordinator.openThreads()
    }

    private func openProfileCompletion() {
        guard userService.current?.isProfessional == true else {
            return
        }
        coordinator.openMerchantCompletion()
    }

    private func accountCreated() {
        requestNotificationPermission(pushNotificationService: pushNotificationService,
                                      userService: userService) { [weak self] in
            let isMerchant = self?.userService.current?.isProfessional ?? false
            self?.coordinator.openAccountCreatedDialog(forType: isMerchant ? .merchant : .person)
        }
    }

    private func openSearch(input: SearchProductsInput) {
        coordinator.openSearch(input: input)
    }

    private func finaliseAccount(userID _: UUID, token _: String) {
        eventTrackingService.trackEmailActivation()
        userService.getActive()

        userService.active.compactMap { $0 }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.userProvider.hasCompletedProfile {
                    Navigator().navigate(route: Navigator.Route.accountCreated)
                } else {
                    Navigator().navigate(route: Navigator.Route.profileCompletion)
                }
            }).disposed(by: bag)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TabsViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let query = suggestions[indexPath.row]
        Navigator().navigate(route: Navigator.Route.search(input: SearchProductsInput(query: query)))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: searchCellIdentifier) {
            cell.textLabel?.text = suggestions[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - TabBarDelegate

extension TabsViewController: TabBarDelegate {
    @discardableResult
    func tabBar(_: TabBar, canSelectTab type: TabBar.Tab) -> Bool {
        switch type {
        case .home:
            return true
        case .favorites:
            openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupFavoritesTitle(),
                                         description: R.string.localizable.contextualSignupFavoritesDescription()) {
                self.openTab(type)
            }
            return false
        case .myWhoppah:
            openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupMywhoppahTitle(),
                                         description: R.string.localizable.contextualSignupMywhoppahDescription()) {
                self.openTab(type)
            }
            return false
        case .chat:
            openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupChatTitle(),
                                         description: R.string.localizable.contextualSignupChatDescription()) {
                self.openTab(type)
            }
            return false
        }
    }

    func tabBar(_: TabBar, didSelectTab type: TabBar.Tab) {
        openTab(type)
    }

    func tabBarDidSelectCamera(_: TabBar) {
        openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupSellingTitle(),
                                     description: R.string.localizable.contextualSignupSellingDescription(),
                                     requiresCompleteProfile: true) { [weak self] in
            self?.coordinator.openCreateAd()
            self?.eventTrackingService.createAd.trackStartAdCreating(clickedPlaceAd: false)
        }
    }
}

// MARK: - SearchFieldDelegate

extension TabsViewController: SearchFieldDelegate {
    
    func searchFieldDidClickCamera(_: SearchField) {
        suggestionsTableView.isHidden = true
        Navigator().navigate(route: Navigator.Route.searchByPhoto)
    }

    func searchFieldDidReturn(_ searchField: SearchField) {
        suggestionsTableView.isHidden = true
        eventTrackingService.home.trackSearchPerformed(text: searchField.text)
        Navigator().navigate(route: Navigator.Route.search(input: SearchProductsInput(query: searchField.text)))
    }

    func searchFieldDidBeginEditing(_: SearchField) {
        
        if searchField.text.isEmpty {
            suggestions.removeAll()
            suggestionsTableView.reloadData()
        }
        suggestionsTableView.isHidden = false
    }
    
    func searchFieldDidEndEditing(_: SearchField) {
        suggestionsTableView.isHidden = true
    }

    func searchField(_: SearchField, didChangeText text: String) {
        searchRepo?.loadSuggestions(query: searchField.text)
        
        if text.isEmpty {
            suggestions.removeAll()
            suggestionsTableView.reloadData()
            searchService.searchText = nil
            return
        }
    }
}

// MARK: - CategoriesMenuViewControllerDelegate

extension TabsViewController: MenuHostingControllerDelegate {
    func showCategory(_ category: WhoppahModel.Category) {
        searchService.removeAllFilters()

        eventTrackingService.home.trackCategoryMenuClicked(category: category.title,
                                                                    product: nil)
        
        let filterInput = FilterInput(key: .category, value: category.slug)
        Navigator().navigate(route: Navigator.Route.search(input: .init(filters: [filterInput])))
    }
    
    func contactTapped() {
        coordinator.openContact()
    }
    
    func profileTapped() {
        tabBar(self.tabBar, canSelectTab: .myWhoppah)
    }
    
    func chatTapped() {
        tabBar(self.tabBar, canSelectTab: .chat)
    }
    
    func howWhoppahWorksTapped() {
        guard let navigationController = navigationController else { return }
        
        let coordinator = AssuranceCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
    func aboutWhoppahTapped() {
        navigationController?.pushViewController(AboutWhoppahHostingController(), animated: true)
    }
    
    func whoppahReviewsTapped() {
        navigationController?.pushViewController(WhoppahReviewsHostingController(), animated: true)
    }
    
    func storeAndSellTapped() {
        AppEvents.shared.logEvent(AppEvents.Name.startTrial)
        navigationController?.pushViewController(StoreAndSellHostingController(), animated: true)
    }
}

import FacebookCore

extension TabsViewController {
    func setupRouting() {
        deepLinkCoordinator.deeplinkPublisher.sink(receiveValue: { [weak self] (deepLink: NavigatableView?) in
            guard let self = self else { return }
            switch deepLink {
            case let loginView as LoginView.NavigationView:
                switch loginView {
                case .forgotPassword:
                    self.coordinator.openForgotPassword(initialView: loginView)
                    self.deepLinkCoordinator.reset()
                default:
                    break
                }
            default:
                break
            }
        })
        .store(in: &cancellables)
        
        navigatorRoute
            .asDriver(onErrorJustReturn: .unknown)
            .drive(onNext: { [weak self] route in
                guard let self = self else { return }
                var handled = true
                switch route {
                case .home:
                    self.openHome()
                case .welcome:
                    self.coordinator.openWelcome()
                case let .userProfile(id):
                    self.coordinator.openPublicProfile(id: id)
                case .createAd:
                    self.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupSellingTitle(),
                                                      description: R.string.localizable.contextualSignupSellingDescription(),
                                                      requiresCompleteProfile: true) {
                        self.coordinator.openCreateAd()
                    }
                case let .browser(url):
                    self.coordinator.openDocument(url: url)
                case let .myWhoppah(data):
                    self.openMyWhoppah(data: data)
                case let .adDetails(data):
                    self.coordinator.openAdDetails(id: data.id)
                case let .chat(threadID):
                    self.coordinator.openThread(threadID: threadID)
                case let .finaliseAccount(userID, token):
                    self.finaliseAccount(userID: userID, token: token)
                case let .resetPassword(userID, token):
                    self.coordinator.openResetPassword(userID: userID, token: token)
                case .usp:
                    self.coordinator.openUSP()
                case let .search(data):
                    self.openSearch(input: data)
                case .searchByPhoto:
                    self.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupSearchByPhotoTitle(),
                                                      description: R.string.localizable.contextualSignupSearchByPhotoDescription(),
                                                      requiresCompleteProfile: false) {
                        self.eventTrackingService.home.trackClickedSearchByPhoto()
                        self.coordinator.openCameraSearch()
                    }
                case let .map(latitude, longitude):
                    self.coordinator.openMap(latitude: latitude, longitude: longitude)
                case .looks:
                    self.coordinator.openLooks()
                case .profileCompletion:
                    self.openProfileCompletion()
                case .accountCreated:
                    self.accountCreated()
                case .unknown:
                    handled = false
                }
                if handled {
                    // Clear down the navigator (will cause another bounce)
                    // This is a little risky...but receiving two deep links in a row won't work with navigation anyway
                    DispatchQueue.main.async {
                        navigatorRoute.onNext(.unknown)
                    }
                }
            })
            .disposed(by: bag)
    }
}
