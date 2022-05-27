//  
//  WelcomeToWhoppahDialog+ViewState.swift
//  
//
//  Created by Dennis Ippel on 15/02/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public extension WelcomeToWhoppahDialog {
    struct ViewState: Equatable {
        public static func == (lhs: WelcomeToWhoppahDialog.ViewState, rhs: WelcomeToWhoppahDialog.ViewState) -> Bool {
            return lhs.loadingState == rhs.loadingState && lhs.model == rhs.model
        }
        
        public enum ContentLoadingState {
            case loading
            case finished
            case failed
        }
        
        var loadingState: ContentLoadingState = .finished
        var model: WelcomeToWhoppahDialogModel
        
        public static let initial = Self(loadingState: .finished,
                                         model: WelcomeToWhoppahDialog.NewUserModel.mock)
    }
}
