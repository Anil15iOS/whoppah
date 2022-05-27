//
//  WhoppahUI+MockCategoriesClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 30/03/2022.
//

import Foundation
import WhoppahModel
import ComposableArchitecture

extension WhoppahUI.CategoriesClient {
    static let mockCategoriesClient = WhoppahUI.CategoriesClient { level in
        func c(_ categoryName: String, _ children: [WhoppahModel.Category]? = nil) -> WhoppahModel.Category {
            let uuid = UUID()
            return .init(
                id: uuid,
                children: children,
                title: categoryName,
                slug: "category-" + uuid.uuidString,
                image: Image(id: UUID(),
                             url: "https://picsum.photos/200/200?id=\(uuid.uuidString)",
                             type: .cover,
                             position: 0),
                images: [],
                videos: [])
        }
        
        let categories = [
            c("Meubels", [
                c("Baby & Kinderen", [
                    c("Baby en kinderkamerdecoratie"),
                    c("Babykamer"),
                    c("Kinderkamer")
                ]),
                c("Banken", [
                    c("2-zitsbanken"),
                    c("3-5 zitsbanken"),
                    c("Bankjes"),
                    c("Chaises longues"),
                    c("Hoekbanken"),
                    c("Voetenbanken")
                ])
            ]),
            c("Verlichting", [
                c("Badkamerlampen"),
                c("Hanglampen"),
                c("Kinderlampen"),
                c("Klemlampen"),
                c("Kroonluchters"),
                c("Plafondlampen"),
                c("Spotjes"),
                c("Tafellampen"),
                c("Vloerlampen"),
                c("Wandlampen")
            ]),
            c("Kunst", [
                c("Acquarel"),
                c("Beeldhouwkunst"),
                c("Mixed media"),
                c("Etsen & prenten"),
                c("Fotografie"),
                c("Litho's & zeefdrukken"),
                c("Schilderijen")
            ]),
            c("Woon decoratie", [
                c("Beeldwerk"),
                c("Decoratie"),
                c("Dienbladen"),
                c("Fotolijsten"),
                c("Kamerschermen"),
                c("Kandelaars"),
                c("Kapstokken"),
                c("Klokken"),
                c("Kussentjes"),
                c("Lijsten"),
                c("Schalen"),
                c("Spiegels"),
                c("Textiel", [
                    c("Dekens & plaids"),
                    c("Vloerkleden en tapijten"),
                    c("Vazen")
                ]),
                c("Wanddecoratie"),
                c("Wijnrek")
            ])
        ]

        return Effect(value: categories)
            .eraseToEffect()
    } fetchSubCategoriesBySlug: { slug in
        var categories = [WhoppahModel.Category]()
        let categoryCount = Int.random(in: 2...6)
        
        for i in 0...categoryCount {
            categories.append(.random)
        }
        
        return Effect(value: categories)
            .eraseToEffect()
    }
}
