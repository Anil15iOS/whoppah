//
//  BulletText.swift
//  Whoppah
//
//  Created by Eddie Long on 21/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

struct BulletText {
    private static func getTopLevelCategorySlug(categories: [AdAttribute]) -> String? {
        for category in categories.compactMap({ $0 as? WhoppahCore.CategoryBasic }) {
            var parent = category.ancestor
            while true {
                guard let ancestor = parent?.ancestor else { break }
                parent = ancestor.ancestor
            }
            return parent?.slug
        }
        return categories.first?.slug
    }
    
    static func fetch(forScreen screenTitle: String, categories: [AdAttribute]) -> [String] {
        let screenBulletTitle = "\(screenTitle)-bullet"
        var i = 1
        let categorySlug = getTopLevelCategorySlug(categories: categories)
        let bullet = "\(screenBulletTitle)\(i)-\(categorySlug ?? "")"
        let hasCategory = localizedString(bullet, placeholder: nil, logError: false) != nil
        var bullets = [String]()
        while true {
            if hasCategory {
                let bullet = "\(screenBulletTitle)\(i)-\(categorySlug ?? "")"
                guard let text = localizedString(bullet, placeholder: nil, logError: false) else { break }
                bullets.append(text)
            } else {
                let bullet = "\(screenBulletTitle)\(i)"
                guard let text = localizedString(bullet, placeholder: nil, logError: false) else { break }
                bullets.append(text)
            }
            i += 1
        }
        return bullets
    }
}
