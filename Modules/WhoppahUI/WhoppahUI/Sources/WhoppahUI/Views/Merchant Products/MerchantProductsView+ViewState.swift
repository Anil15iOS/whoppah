//  
//  MerchantProductsView+ViewState.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/05/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import WhoppahModel

public extension MerchantProductsView {
    struct ViewState: Equatable {
        public enum LoadingState {
            case uninitialized
            case loading
            case failed(error: Error)
            case finished
        }
        
        var contentLoadingState: LoadingState = .uninitialized
        var fetchProductsState: LoadingState = .uninitialized
        var model: Model
        var merchantId: UUID? = nil
        var merchantName: String? = nil
        var products = [ProductTileItem]()
        
        public static let initial = Self(model: .initial)
    }
}

extension MerchantProductsView.ViewState.LoadingState: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (.uninitialized, .uninitialized): return true
        case (.loading, .loading): return true
        case (let .failed(lError), let .failed(rError)): return compare(lError, rError)
        case (.finished, .finished): return true
        default: return false
        }
    }
}
