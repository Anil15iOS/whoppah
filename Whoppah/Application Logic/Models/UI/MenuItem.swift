//
//  MenuItem.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/15/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class MenuItem {
    // MARK: - Properties

    let title: String
    let icon: UIImage?

    // MARK: - Initialization

    init(title: String, icon: UIImage?) {
        self.title = title
        self.icon = icon
    }
}
