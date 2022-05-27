//
//  HowWhoppahWorks+Action.swift
//  
//
//  Created by Dennis Ippel on 08/11/2021.
//

import ComposableArchitecture

public extension HowWhoppahWorks {
    enum TrackingAction {
        case didSelectPayments
        case didSelectShippingAndDelivery
        case didSelectBidding
        case didSelectCuration
        case didSelectFAQ
        case didExit
    }
    
    enum OutboundAction {
        case bookCourier
        case exitHowWhoppahWorks
    }
    
    enum Action {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
        case trackingSuccess
    }
}
