//
//  Label+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/03/2022.
//

import Foundation
import WhoppahModel
import SwiftUI

extension WhoppahModel.Label {
    static var random: Self {
        let slug = ["label-lowered-in-price",
                    "label-sale",
                    "label-whoppah-loves",
                    "label-good-deal-alert",
                    "label-gallery-piece",
                    "label-expert-seller",
                    "label-collectors-item",
                    "label-award-winning-design",
                    "label-100-authenticated",
                    "label-best-deal",
                    "label-new"]
                       .randomElement() ?? ""
        
        return .init(
            id: UUID(),
            title: RandomWord.randomWords(1...3),
            description: RandomWord.randomWords(2...6),
            slug: slug,
            hex: SwiftUI.Color.random.hex)
    }
}
