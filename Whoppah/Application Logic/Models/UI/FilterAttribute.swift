//
//  FilterAttribute.swift
//  Whoppah
//
//  Created by Eddie Long on 22/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahModel

enum FilterAttributeType: String {
    case category
    case brand
    case style
//    case artist
    case designer
    case material
    case color
    
    // Temporary, while we're transitiong to the new architecture.
    var toNewModel: SearchFilterKey {
        switch self {
        case .category:     return .category
        case .brand:        return .brand
        case .style:        return .style
        case .material:     return .material
        case .color:        return .color
        case .designer:     return .unknown
        }
    }
}

struct FilterAttribute {
    let type: FilterAttributeType
    let slug: String
    let title: BehaviorRelay<String?>
    let children: [FilterAttribute]?
    private let bag = DisposeBag()

    // Certain attributes require a title to be fetched from the localisable strings
    // Others such as brands, artists and designers we can display the titles directly unlocalized
    init(type: FilterAttributeType, slug: String, title: String? = nil, children: [FilterAttribute]? = nil) {
        self.type = type
        self.slug = slug
        self.children = children
        self.title = BehaviorRelay<String?>(value: title)
        switch type {
        case .category, .style, .material:
            fetchDisplayTitle()
                .bind(to: self.title)
                .disposed(by: bag)
        default:
            break
        }
    }

    private func fetchDisplayTitle() -> Observable<String?> {
        switch type {
        case .category:
            return observedLocalizedString(categoryTitleKey(slug))
        case .style:
            return observedLocalizedString(styleTitleKey(slug))
        case .material:
            return observedLocalizedString(materialTitleKey(slug))
        default:
            assertionFailure("Expected a category, style or material")
            return Observable.just("")
        }
    }
    
    // Temporary, while we're transitiong to the new architecture.
    var toNewModel: FilterInput {
        .init(key: self.type.toNewModel,
              value: self.slug)
    }
}

extension FilterAttribute: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(slug.hashValue)
        hasher.combine(type.hashValue)
    }
}

extension FilterAttribute: Equatable {
    static func == (lhs: FilterAttribute, rhs: FilterAttribute) -> Bool {
        lhs.slug == rhs.slug && lhs.type == rhs.type
    }
}
