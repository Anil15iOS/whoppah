//
//  SceneDelegate.swift
//  Whoppah
//
//  Created by Eddie Long on 06/10/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private var cancellable: Cancellable?
    
    @LazyInjected var pushNotifications: PushNotificationsService
    @LazyInjected var permissionsService: PermissionsService
    @LazyInjected var deeplinkables: Deeplinkable
    @LazyInjected var appInitializables: AppInitializable
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard !Bundle.isRunningTests() else { return }
        
        var viewController: UIViewController?
        
        if UserDefaultsConfig.hasSeenOnboarding {
            let storyboard = UIStoryboard(name: "Tabs", bundle: nil)
            viewController = storyboard.instantiateInitialViewController()
        } else {
            let onboarding = OnboardingViewController()
            let nav = WhoppahNavigationController(rootViewController: onboarding)
            nav.isNavigationBarHidden = true
            viewController = nav
        }
        
        let windowScene: UIWindowScene = scene as! UIWindowScene
        self.window = UIWindow(windowScene: windowScene)
        
        self.window!.rootViewController = viewController
        self.window!.makeKeyAndVisible()
        
        cancellable = NotificationCenter
            .default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .sink(receiveValue: { [weak self] _ in
                self?.deeplinkables.openURLContexts(connectionOptions.urlContexts)
                self?.pushNotifications.registerForRemoteNotifications()
                self?.permissionsService.requestPermissionsIfApplicable()
            })
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        appInitializables.sceneDidBecomeActive()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        deeplinkables.openURLContexts(URLContexts)
    }
}
