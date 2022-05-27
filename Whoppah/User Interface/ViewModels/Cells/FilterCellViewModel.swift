//
//  FilterCellViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 19/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahDataStore

func getFilterCellPrice(min: Money?, max: Money?) -> String {
    let symbol = GraphQL.Currency.eur.text
    var price: String!
    if min != nil, max != nil {
        price = "\(symbol)\(min!) - \(symbol)\(max!)"
    } else if min != nil {
        price = "\(symbol)\(min!) <"
    } else if max != nil {
        price = "< \(symbol)\(max!)"
    }
    return price
}

func getFilterCellQuality(_ quality: GraphQL.ProductQuality) -> String {
    var text = ""
    switch quality {
    case .good: text = R.string.localizable.create_ad_main_condition_value_1()
    case .great: text = R.string.localizable.create_ad_main_condition_value_2()
    case .perfect: text = R.string.localizable.create_ad_main_condition_value_3()
    default: text = ""
    }
    return text
}

class FilterCellViewModel {
    enum CellStyle {
        case deletable
        case selectable
    }

    private(set) var cellStyle: CellStyle

    enum CellType {
        case single(text: String)
        case color(hex: String)
    }

    private(set) var cellType: CellType

    var filter: FilterItem
    init(item: FilterItem, style: CellStyle) {
        filter = item
        cellStyle = style
        switch item {
        case let .price(min, max):
            let price = getFilterCellPrice(min: min, max: max)
            cellType = .single(text: price)
        case let .postalCode(code):
            cellType = .single(text: code)
        case let .radius(value):
            cellType = .single(text: R.string.localizable.search_filters_distance_title() + ": \(String(format: "%d", value)) km")
        case let .quality(quality):
            let text = getFilterCellQuality(quality)
            cellType = .single(text: text)
        case let .category(category):
            cellType = .single(text: category.title.value ?? "")
        case let .filterAttribute(attribute):
            switch attribute.type {
            case .color:
                cellType = .color(hex: attribute.title.value!)
            default:
                cellType = .single(text: attribute.title.value ?? "")
            }
        case .arReady:
            cellType = .single(text: R.string.localizable.search_filters_ar())
        }
    }

    func getWidth(includeDelete: Bool) -> CGFloat {
        switch cellType {
        case let .single(text):
            return text.width(withConstrainedHeight: UIFont.button.lineHeight, font: UIFont.button) + (includeDelete ? 52.0 : 32.0)
        case .color:
            return 64.0
        }
    }
}
