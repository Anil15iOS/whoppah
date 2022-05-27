//
//  Label+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/03/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Label {
    class MockLocalizer: DataStoreLocalizer<WhoppahModel.Label> {
        override func localize(_ path: KeyPath<Label, String>,
                               model: Label,
                               params: [String]) -> String
        {
            switch path {
            case \.title:
                switch model.slug {
                case "label-lowered-in-price": return "lowered in price"
                case "label-sale": return "sale"
                case "label-whoppah-loves": return "Whoppah Loves"
                case "label-good-deal-alert": return "Bargain!"
                case "label-gallery-piece": return "Gallery Piece"
                case "label-expert-seller": return "Expert seller"
                case "label-collectors-item": return "Collector's Item"
                case "label-award-winning-design": return "Iconic chairs"
                case "label-100-authenticated": return "100% authentic"
                case "label-best-deal": return "Best Deal"
                case "label-new": return "New"
                default: return "Unknown Label"
                }
            case \.hex!:
                return model.hex ?? "#ff0000"
            default:
                return ""
            }
        }
    }
}
