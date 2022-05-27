//
//  BankAccount.swift
//  WhoppahCore
//
//  Created by Eddie Long on 02/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol BankAccount {
    var accountNumber: String { get }
    var routingNumber: String? { get }
    var accountHolderName: String { get }
}

extension BankAccount {
    public func isValid() -> Bool {
        !accountNumber.isEmpty && !accountHolderName.isEmpty
    }
}
