//
//  User.swift
//  Whoppah
//
//  Created by Eddie Long on 11/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

struct Auth {
    static func isValidUsername(_ text: String) -> Bool {
        let userRegex = "^[\\w]{1,20}$"
        let userTest = NSPredicate(format: "SELF MATCHES %@", userRegex)
        return userTest.evaluate(with: text)
    }

    struct PasswordResult {
        let hasCapitalLetter: Bool
        let hasLowerLetter: Bool
        let hasNumber: Bool
        let validLength: Bool

        var isValid: Bool {
            hasCapitalLetter && hasLowerLetter && hasNumber && validLength
        }
    }

    static func validatePassword(_ currentText: String) -> PasswordResult {
        let capitalLetterRegEx = ".*[A-Z]+.*"
        let capTest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = capTest.evaluate(with: currentText)

        let lowerLetterRegEx = ".*[a-z]+.*"
        let lowerTest = NSPredicate(format: "SELF MATCHES %@", lowerLetterRegEx)
        let lowerResult = lowerTest.evaluate(with: currentText)

        let numberRegEx = ".*[0-9]+.*"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let numberResult = numberTest.evaluate(with: currentText)

        let lengthResult = currentText.count >= Auth.passwordMinimumLength

        return PasswordResult(hasCapitalLetter: capitalResult, hasLowerLetter: lowerResult, hasNumber: numberResult, validLength: lengthResult)
    }

    static var passwordMinimumLength = 8
}

extension ChatUser {
    func getCharacterForAvatarIcon() -> Character? {
        guard !displayName.isEmpty else { return "-" }
        return displayName.uppercased()[displayName.startIndex]
    }
}
