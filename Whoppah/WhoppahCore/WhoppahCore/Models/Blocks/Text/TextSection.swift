//
//  TextSection.swift
//  WhoppahCore
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol TextSection {
    var id: UUID { get }
    var titleKey: String { get }
    var buttonKey: String { get }
    var slug: String { get }
    var imageURL: URL? { get }
    var descriptionKey: String? { get }
    var clickLink: URL? { get }
}
