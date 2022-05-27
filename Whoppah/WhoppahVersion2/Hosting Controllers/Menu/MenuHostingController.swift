//
//  MenuHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 03/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import UIKit
import SwiftUI
import WhoppahUI
import WhoppahDataStore
import WhoppahRepository
import WhoppahCoreNext
import WhoppahModel
import ComposableArchitecture
import Combine
import Resolver

protocol MenuHostingControllerDelegate {
    func showCategory(_ category: WhoppahModel.Category)
    func contactTapped()
    func profileTapped()
    func chatTapped()
    func howWhoppahWorksTapped()
    func aboutWhoppahTapped()
    func whoppahReviewsTapped()
    func storeAndSellTapped()
}

class MenuHostingController: WhoppahUIHostingController<AppMenu,
                             AppMenu.Model,
                             AppMenu.ViewState,
                             AppMenu.Action,
                             AppMenu.OutboundAction,
                             AppMenu.TrackingAction> {
    
    @Injected private var categoriesRepository: CategoryRepository
    
    var delegate: MenuHostingControllerDelegate?
    
    override init() {
        super.init()
        
        view.backgroundColor = .clear
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> AppMenu {
        let categoriesClient = WhoppahUI.CategoriesClient { [weak self] level in
            guard let self = self else {
                return Fail(outputType: [WhoppahModel.Category].self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self.categoriesRepository
                .loadCategories(atLevel: level)
                .eraseToEffect()
        } fetchSubCategoriesBySlug: { slug in
            return .none
        }

        let environment = AppMenu.Environment(localizationClient: localizationClient,
                                              trackingClient: trackingClient,
                                              outboundActionClient: outboundActionClient,
                                              categoriesClient: categoriesClient,
                                              mainQueue: .main)

        let reducer = AppMenu.Reducer().reducer

        let store: Store<AppMenu.ViewState, AppMenu.Action> =
            .init(initialState: .initial,
                  reducer: reducer,
                  environment: environment)

        return .init(store: store)
    }
    
    ///
    /// ⚡️Handles outbound actions
    ///
    /// - Parameter outboundAction: An outbound action
    /// - Returns: An effect
    ///
    override func handle(outboundAction: AppMenu.OutboundAction) -> Effect<AppMenu.Action, Never> {
        switch outboundAction {
        case .exitMenu:
            pop {}
        case .contact:
            pop { [weak self] in
                self?.delegate?.contactTapped()
            }
        case .myProfile:
            pop { [weak self] in
                self?.delegate?.profileTapped()
            }
        case .chatsBidding:
            pop { [weak self] in
                self?.delegate?.chatTapped()
            }
        case .howWhoppahWorks:
            pop { [weak self] in
                self?.delegate?.howWhoppahWorksTapped()
            }
        case .showCategory(let category):
            pop { [weak self] in
                self?.delegate?.showCategory(category)
            }
        case .aboutWhoppah:
            pop { [weak self] in
                self?.delegate?.aboutWhoppahTapped()
            }
        case .whoppahReviews:
            pop { [weak self] in
                self?.delegate?.whoppahReviewsTapped()
            }
        case .storeAndSell:
            pop { [weak self] in
                self?.delegate?.storeAndSellTapped()
            }
        }

        return .none.eraseToEffect()
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: AppMenu.TrackingAction) -> Effect<Void, Never> {
        return .none.eraseToEffect()
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<AppMenu.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(AppMenu.Model.self) else {
            return .none
        }
        return Effect(value: localizedModel)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func pop(navigateTo: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + WhoppahTheme.Animation.Menu.toggleVisibilityDuration) { [weak self] in
            self?.dismiss(animated: false, completion: navigateTo)
        }
    }
}
