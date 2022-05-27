//
//  AttributeBlockViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 20/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

protocol BlockSectionDataSource {
    var slug: String { get }
    var link: String? { get }
    var sections: [BlockDataSource] { get }
}

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsAttributeBlock: BlockSectionDataSource {
    var sections: [BlockDataSource] { attributes.map { $0 } }
}

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsMerchantBlock: BlockSectionDataSource {
    var sections: [BlockDataSource] { merchants.map { $0 } }
}

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsCategoryBlock: BlockSectionDataSource {
    var sections: [BlockDataSource] { categories.map { $0 } }
}

class AttributeBlockViewModel: BlockViewModel {
    enum BlockStyle {
        case horizontalList
        case carousel
        case grid
    }
    
    struct Outputs {
        let sectionClicked = PublishSubject<BlockDataSource>()
    }

    let outputs = Outputs()

    private let block: BlockSectionDataSource

    @Injected private var search: SearchService
    
    init(block: BlockSectionDataSource) {
        self.block = block
    }

    var sections: [AttributeBlockSectionViewModel] {
        guard style == .carousel else {
            return block.sections.map { AttributeBlockSectionViewModel(datasource: $0,
                                                                       showTitle: block.sections.count == 1) }
         }
        var vms = [AttributeBlockSectionViewModel]()
        // We just pick the first item and display it
        let attribute = block.sections.chooseOne
        vms.append(AttributeBlockSectionViewModel(datasource: attribute, showTitle: block.sections.count == 1))
        return vms
    }

    var title: Observable<String?> {
        guard style == .carousel else {
            return observedLocalizedString(block.slug.titleKey)
        }
        if block.link == nil { return Observable.just(nil) }
        return observedLocalizedString(block.slug.titleKey)
    }

    var button: Observable<String?> {
        if block.link == nil { return Observable.just(nil) }
        return observedLocalizedString(block.slug.buttonKey, placeholder: R.string.localizable.common_btn_show_all())
    }
    
    var style: BlockStyle {
        if block.slug.starts(with: "top") {
            return .horizontalList
        } else if block.slug.starts(with: "popular") {
            return .grid
        }
        return .carousel
    }

    // MARK: Actions

    func didClickButton() {
        guard let link = block.link, let url = URL(string: link) else { return }
        search.removeAllFilters()
        if DeeplinkManager.shared.handleDeeplink(url: url) {
            DeeplinkManager.shared.executeDeeplink()
        }
    }
}
