//
//  TextInputValidatable.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 24/12/2021.
//

import Foundation

protocol TextInputValidatable {
    init(_ failedMessage: String)
    
    var failedMessage: String { get }
    func isValid(_ input: String) -> Bool
}
