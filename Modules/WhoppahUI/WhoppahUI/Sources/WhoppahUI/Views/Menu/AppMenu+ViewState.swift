//
//  AppMenu+ViewState.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import Foundation
import WhoppahModel

public extension AppMenu {
    struct ViewState: Equatable {
        var model: Model
        var categories = [WhoppahModel.Category]()
        
        public static let initial = Self(model: .initial)
    }
}
