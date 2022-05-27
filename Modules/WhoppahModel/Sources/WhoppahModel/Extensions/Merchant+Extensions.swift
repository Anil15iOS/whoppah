//
//  Merchant+Extensions.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 16/03/2022.
//

import Foundation

public extension Merchant {
    var isVerified: Bool {
        self.complianceLevel ?? 0 > 0
    }
    
    var vatRate: Float { return 21.0 }
}
