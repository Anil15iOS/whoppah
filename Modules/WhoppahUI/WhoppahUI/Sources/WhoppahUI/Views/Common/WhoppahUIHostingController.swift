//
//  WhoppahUIHostingController.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 16/02/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import SwiftUI
import ComposableArchitecture

open class WhoppahUIHostingController<Content: View & StoreInitializable,
                                 Model,
                                 ViewState,
                                 Action,
                                 OutboundAction,
                                 TrackingAction>
: UIHostingController<Content> {
    private(set) public var localizationClient: WhoppahUI.LocalizationClient<Model>!
    private(set) public var outboundActionClient: WhoppahUI.OutboundActionClient<OutboundAction, Effect<Action, Never>>!
    private(set) public var trackingClient: WhoppahUI.TrackingClient<TrackingAction>!
    
    public init() {
        super.init(rootView: Content(store: nil))

        localizationClient = .init(fetch: { [weak self] in
            guard let self = self else { return .none.eraseToEffect() }
            return self.fetchLocalizedModel()
        })
        
        outboundActionClient = .init(perform: { [weak self] outboundAction in
            guard let self = self else { return .none.eraseToEffect() }
            return self.handle(outboundAction: outboundAction)
        })
        
        trackingClient = .init(track: { [weak self] trackingAction in
            guard let self = self else { return .none.eraseToEffect() }
            return self.track(action: trackingAction)
        })

        rootView = provideContent()
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    open func provideContent() -> Content {
        fatalError("This needs to be overriden")
    }
    
    ///
    /// ⚡️Handles outbound actions
    ///
    /// - Parameter outboundAction: An outbound action
    /// - Returns: An effect
    ///
    open func handle(outboundAction: OutboundAction) -> Effect<Action, Never> {
        return .none.eraseToEffect()
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    open func track(action: TrackingAction) -> Effect<Void, Never> {
        return .none.eraseToEffect()
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    open func fetchLocalizedModel() -> Effect<Model, WhoppahUI.LocalizationClientError> {
        return .none.eraseToEffect()
    }
    
    @MainActor @objc required dynamic public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
