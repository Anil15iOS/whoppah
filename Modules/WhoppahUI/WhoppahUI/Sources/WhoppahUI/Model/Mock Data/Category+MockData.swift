//
//  Category+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 17/05/2022.
//

import Foundation
import WhoppahModel

extension WhoppahModel.Category {
    static var random: Self {
        let id = UUID()
        
        return .init(id: id,
                     parent: nil,
                     children: nil,
                     title: RandomWord.randomWords(1...3),
                     description: nil,
                     slug: "category-slug-\(id.uuidString)",
                     link: nil,
                     level: nil,
                     route: nil,
                     showInStyles: nil,
                     showInBrands: nil,
                     image: .init(id: UUID(),
                                  url: "https://picsum.photos/200/200?id=\(id.uuidString)",
                                  type: .avatar,
                                  orientation: nil,
                                  width: 200,
                                  height: 200,
                                  aspectRatio: nil,
                                  position: 0,
                                  backgroundColor: nil),
                     images: [],
                     video: nil,
                     videos: [])
    }
}
