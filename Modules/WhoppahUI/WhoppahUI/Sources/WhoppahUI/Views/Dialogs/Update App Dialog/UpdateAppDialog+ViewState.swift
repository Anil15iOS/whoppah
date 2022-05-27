//
//  UpdateAppDialog+ViewState.swift
//  
//
//  Created by Dennis Ippel on 16/11/2021.
//

import Foundation

public extension UpdateAppDialog {
    struct ViewState: Equatable {
        var model: Model
        
        public static let initial = Self(model: .initial)
    }
}
