//
//  Fee.swift
//  WhoppahCore
//
//  Created by Eddie Long on 02/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

public protocol Fee {
    var type: GraphQL.CalculationMethod { get }
    var amount: Double { get }
}
