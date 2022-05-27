//  
//  AboutWhoppah+ViewState.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public extension AboutWhoppah {
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
