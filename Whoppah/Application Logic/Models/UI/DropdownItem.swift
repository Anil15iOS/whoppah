//
//  DropdownItem.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/1/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

class DropdownItem {
    // MARK: - Properties

    let ID: String
    let name: String
    let imageUrl: URL?
    var isSelected: Bool = false

    // MARK: - Initiazation

    init(ID: String, name: String, imageUrl: URL? = nil) {
        self.ID = ID
        self.name = name
        self.imageUrl = imageUrl
    }
}
