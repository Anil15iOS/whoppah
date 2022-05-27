//  ___FILEHEADER___

import Foundation
import SwiftUI
import ComposableArchitecture

public extension ___VARIABLE_viewName:identifier___ {
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