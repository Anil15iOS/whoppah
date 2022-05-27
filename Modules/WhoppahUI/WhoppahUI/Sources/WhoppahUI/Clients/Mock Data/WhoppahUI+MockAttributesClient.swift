//
//  WhoppahUI+MockAttributesClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/03/2022.
//

import Foundation
import WhoppahModel
import SwiftUI
import ComposableArchitecture

extension WhoppahUI.AttributesClient {
    static let mockClient = WhoppahUI.AttributesClient { attributeType in
        var attributes = [AbstractAttribute]()
        switch attributeType {
        case .brand:
            for i in 0...Int.random(in: 20...30) {
                attributes.append(Brand(id: UUID(),
                                        title: RandomWord.randomWords(0...4),
                                        slug: "brand-\(i)"))
            }
        case .material:
            for i in 0...Int.random(in: 8...20) {
                attributes.append(Material(id: UUID(),
                                           title: RandomWord.randomWords(0...3, wordLength: 3...5),
                                           slug: "material-\(i)"))
            }
        case .style:
            for i in 0...Int.random(in: 8...20) {
                attributes.append(Style(id: UUID(),
                                        title: RandomWord.randomWords(0...4),
                                        slug: "style-\(i)"))
            }
        case .color:
            for i in 0...Int.random(in: 8...20) {
                attributes.append(Color(id: UUID(),
                                        title: RandomWord.randomWords(0...4),
                                        slug: "color-\(i)",
                                        hex: SwiftUI.Color.random.hex))
            }
        default:
            break
        }
        return Effect(value: attributes).eraseToEffect()
    }
}
