//
//  StoreInitializable.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 16/02/2022.
//

import Foundation
import ComposableArchitecture

public protocol StoreInitializable {
    associatedtype ViewState
    associatedtype Action
    
    init(store: Store<ViewState, Action>?)
}
