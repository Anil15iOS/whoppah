//
//  Bid+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 02/05/2022.
//

import Foundation
import WhoppahModel

extension WhoppahModel.Bid {
    static var random: Self {
        .init(id: UUID(),
              auction: UUID(),
              buyer: UUID(),
              merchant: UUID(),
              state: .accepted,
              order: nil,
              created: .init(),
              expiryDate: .init(),
              endDate: nil,
              amount: .init(amount: Double.random(in: 10...1000), currency: .eur),
              isCounter: false,
              thread: nil)
    }
}
