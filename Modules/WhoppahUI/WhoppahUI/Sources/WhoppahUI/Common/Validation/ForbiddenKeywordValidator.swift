//
//  ForbiddenKeywordValidator.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 16/05/2022.
//

import Foundation

struct ForbiddenKeywordValidator: TextInputValidatable {
    let failedMessage: String
    
    private let forbiddenWords = ["whoppah"]
    
    init(_ failedMessage: String) {
        self.failedMessage = failedMessage
    }
    
    func isValid(_ input: String) -> Bool {
        forbiddenWords.allSatisfy { !input.lowercased().contains($0) }
    }
}
