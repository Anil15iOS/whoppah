//
//  MerchantBasic.swift
//  WhoppahCore
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol MerchantBasic {
    var id: UUID { get }
    var name: String { get }
    var thumbnail: Image? { get }
    var isVerified: Bool { get }
    var isExpertSeller: Bool? { get }
}
