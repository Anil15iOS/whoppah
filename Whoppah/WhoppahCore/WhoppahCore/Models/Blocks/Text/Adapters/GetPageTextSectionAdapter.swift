//
//  GetPageTextSectionAdapter.swift
//  WhoppahCore
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsTextBlock.Section: TextSection {
    public var imageURL: URL? {
        URL(string: image)
    }

    public var clickLink: URL? {
        guard let link = link else { return nil }
        return URL(string: link)
    }

    public var titleKey: String { slug.titleKey }

    public var buttonKey: String { slug.buttonKey }

    public var descriptionKey: String? { slug.descriptionKey }
}
