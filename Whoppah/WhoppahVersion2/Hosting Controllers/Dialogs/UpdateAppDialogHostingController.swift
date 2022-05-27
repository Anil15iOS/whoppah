//
//  UpdateAppDialogHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 16/11/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import UIKit
import WhoppahUI
import ComposableArchitecture
import SwiftUI

class UpdateAppDialogHostingController: WhoppahUIHostingController<UpdateAppDialog,
                                        UpdateAppDialog.Model,
                                        UpdateAppDialog.ViewState,
                                        UpdateAppDialog.Action,
                                        UpdateAppDialog.OutboundAction,
                                        UpdateAppDialog.TrackingAction> {
    
    var onOKTapped: (() -> Void)?
    var onCloseTapped: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> UpdateAppDialog {
        let environment = UpdateAppDialog.Environment(localizationClient: localizationClient,
                                                      trackingClient: trackingClient,
                                                      outboundActionClient: outboundActionClient,
                                                      mainQueue: .main)
        let reducer = UpdateAppDialog.Reducer().reducer
        
        let store: Store<UpdateAppDialog.ViewState, UpdateAppDialog.Action> =
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
    override func handle(outboundAction: UpdateAppDialog.OutboundAction) -> Effect<UpdateAppDialog.Action, Never> {
        switch outboundAction {
        case .updateAppNow:
            onOKTapped?()
        case .closeDialog:
            onCloseTapped?()
        }
        return .none.eraseToEffect()
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: UpdateAppDialog.TrackingAction) -> Effect<Void, Never> {
        return .none.eraseToEffect()
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<UpdateAppDialog.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(UpdateAppDialog.Model.self) else {
            return .none
        }
        return Effect(value: localizedModel)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
}
