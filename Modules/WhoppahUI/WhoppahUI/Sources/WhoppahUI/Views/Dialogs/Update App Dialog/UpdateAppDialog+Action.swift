//
//  UpdateAppDialog+Action.swift
//  
//
//  Created by Dennis Ippel on 16/11/2021.
//

import Foundation

public extension UpdateAppDialog {
    enum OutboundAction: Equatable {
        case closeDialog
        case updateAppNow
    }
    
    enum TrackingAction: Equatable {
        case didTapUpdateAppButton
    }
    
    enum Action: Equatable {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case outboundAction(OutboundAction)
    }
}
