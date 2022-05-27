//
//  IBANValidator.swift
//  WhoppahCore
//
//  Created by Eddie Long on 07/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import IBANtools_iOS

public struct IBANValidator {
    public static func isValid(_ iban: String) -> Bool {
        IBANtools.isValidIBAN(iban)
    }
}
