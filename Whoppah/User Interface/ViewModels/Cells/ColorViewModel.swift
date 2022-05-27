//
//  ColorViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 20/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

class ColorViewModel {
    enum BackingData {
        case color(data: Color)
        case filterAttribute(data: FilterAttribute)
    }

    var selected: Bool
    let data: BackingData

    init(color: Color, selected: Bool) {
        data = BackingData.color(data: color)
        self.selected = selected
    }

    init(attribute: FilterAttribute, selected: Bool) {
        data = BackingData.filterAttribute(data: attribute)
        self.selected = selected
    }

    var hex: String {
        switch data {
        case let .color(data):
            return data.hex
        case let .filterAttribute(data):
            return data.title.value ?? ""
        }
    }
}

extension ColorViewModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hex)
    }

    static func == (lhs: ColorViewModel, rhs: ColorViewModel) -> Bool {
        lhs.hex == rhs.hex
    }
}
