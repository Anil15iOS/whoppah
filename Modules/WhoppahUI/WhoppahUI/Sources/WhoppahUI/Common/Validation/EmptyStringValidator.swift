//
//  EmptyStringValidator.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 24/12/2021.
//

import Foundation

struct EmptyStringValidator: TextInputValidatable {
    let failedMessage: String
    
    init(_ failedMessage: String) {
        self.failedMessage = failedMessage
    }
    
    func isValid(_ input: String) -> Bool {
        return !input.isEmpty
    }
}
