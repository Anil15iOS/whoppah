//  
//  ContextualSignupDialog+ViewState.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public extension ContextualSignupDialog {
    struct ViewState: Equatable {
        public enum ContentLoadingState {
            case loading
            case finished
            case failed
        }
        
        var loadingState: ContentLoadingState = .finished
        var model: Model
        
        public static let initial = Self(loadingState: .finished,
                                         model: .initial)
    }
}
