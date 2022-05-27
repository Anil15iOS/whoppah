//
//  TextBlock.swift
//  WhoppahCore
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol TextBlock {
    var id: UUID { get }
    var slug: String { get }
    var titleKey: String { get }
    var descriptionKey: String { get }
    var buttonKey: String { get }
    var clickLink: URL? { get }
    var image: String { get }
    var textSections: [TextSection] { get }
}
