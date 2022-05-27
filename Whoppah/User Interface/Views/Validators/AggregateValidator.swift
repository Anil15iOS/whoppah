//
//  AggregateValidator.swift
//  Whoppah
//
//  Created by Eddie Long on 02/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation

struct AggregateValidator: ValidatorComponent {
    var children = [ValidatorComponent]()
    init(_ children: ValidatorComponent...) {
        self.children.append(contentsOf: children)
    }

    func validate() -> Bool {
        for validator in children {
            if !validator.validate() {
                return false
            }
        }
        return true
    }
}
