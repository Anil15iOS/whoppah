//
//  AppMenu+Action.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import Foundation
import WhoppahModel

public extension AppMenu {
    enum TrackingAction {
        case didExit
    }
    
    enum OutboundAction {
        case exitMenu
        case showCategory(category: WhoppahModel.Category)
        case contact
        case myProfile
        case chatsBidding
        case howWhoppahWorks
        case aboutWhoppah
        case whoppahReviews
        case storeAndSell
    }
    
    enum Action {
        case loadContent
        case loadCategories(level: Int)
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case didFinishLoadingCategories(Result<[WhoppahModel.Category], Error>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
    }
}
