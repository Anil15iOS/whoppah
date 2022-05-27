//
//  BidValidator.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 02/05/2022.
//

import Foundation
import WhoppahModel

struct BidValidator: TextInputValidatable {
    var failedMessage: String
    
    let minimumBidPrice: Price
    
    init(_ failedMessage: String) {
        self.failedMessage = failedMessage
        self.minimumBidPrice = .init(amount: 0, currency: .eur)
    }
    
    init(_ failedMessage: String, _ minimumBidPrice: Price) {
        self.failedMessage = failedMessage
        self.minimumBidPrice = minimumBidPrice
    }
    
    func isValid(_ input: String) -> Bool {
        guard let numericValue = Double(input),
              numericValue >= minimumBidPrice.amount
        else {
            return false
        }
        
        return true
    }
}
