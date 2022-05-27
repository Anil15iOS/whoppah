//
//  RepeatPasswordValidator.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 18/01/2022.
//

import Foundation

struct RepeatPasswordValidator: TextInputValidatable {
    let failedMessage: String
    private let password: String
    
    init(_ failedMessage: String) {
        self.failedMessage = failedMessage
        self.password = ""
    }
    
    init(_ failedMessage: String, password: String) {
        self.failedMessage = failedMessage
        self.password = password
    }
    
    func isValid(_ input: String) -> Bool {
        return !input.isEmpty && input == password
    }
}
