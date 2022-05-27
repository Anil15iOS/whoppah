//
//  HowWhoppahWorks+ViewState.swift
//  
//
//  Created by Dennis Ippel on 08/11/2021.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Combine

public extension HowWhoppahWorks {
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
