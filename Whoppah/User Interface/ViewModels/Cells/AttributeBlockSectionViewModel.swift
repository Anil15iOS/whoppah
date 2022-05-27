//
//  TrendViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 26/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol BlockDataSource {
    var id: UUID { get }
    var title: Observable<String?> { get }
    var slug: String { get }
    var image: Observable<URL?> { get }
    var filter: FilterAttribute? { get }
}

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsAttributeBlock.Attribute: BlockDataSource {
    var id: UUID {
        if let brand = asBrand {
            return brand.id
        } else if let artist = asArtist {
            return artist.id
        } else if let designer = asDesigner {
            return designer.id
        } else if let style = asStyle {
            return style.id
        } else if let material = asMaterial {
            return material.id
        } else if let color = asColor {
            return color.id
        } else {
            assertionFailure("Unexpected attribute type \(__typename)")
        }
        return UUID()
    }
    
    var title: Observable<String?> {
        if let brand = asBrand {
            return Observable.just(brand.title)
        } else if let artist = asArtist {
            return Observable.just(artist.title)
        } else if let designer = asDesigner {
            return Observable.just(designer.title)
        } else if let style = asStyle {
            return observedLocalizedString(styleTitleKey(style.slug))
        } else if let material = asMaterial {
            return observedLocalizedString(materialTitleKey(material.slug))
        } else if let color = asColor {
            return observedLocalizedString(colorTitleKey(color.slug))
        } else {
            assertionFailure("Unexpected attribute type \(__typename)")
        }
        return Observable.just(nil)
    }
    
    var slug: String {
        if let brand = asBrand {
            return brand.slug
        } else if let artist = asArtist {
            return artist.slug
        } else if let designer = asDesigner {
            return designer.slug
        } else if let style = asStyle {
            return style.slug
        } else if let material = asMaterial {
            return material.slug
        } else if let color = asColor {
            return color.slug
        } else {
            assertionFailure("Unexpected attribute type \(__typename)")
        }
        return ""
    }
    
    var image: Observable<URL?> {
        var url: String?
        if let brand = asBrand {
            url = brand.images.randomElement()?.asImage?.url
        } else if let artist = asArtist {
            url = artist.images.randomElement()?.asImage?.url
        } else if let material = asMaterial {
            url = material.images.randomElement()?.asImage?.url
        } else if let designer = asDesigner {
            url = designer.images.randomElement()?.asImage?.url
        } else if let style = asStyle {
            url = style.images.randomElement()?.asImage?.url
        } else if let color = asColor {
            url = color.images.randomElement()?.asImage?.url
        } else {
            assertionFailure("Unexpected attribute type \(__typename)")
        }
        return Observable.just(URL(string: url ?? ""))
    }
    
    var filter: FilterAttribute? {
        if let brand = asBrand {
            return FilterAttribute(type: .brand, slug: brand.slug, title: brand.title, children: nil)
//        } else if let artist = asArtist {
//            return FilterAttribute(type: .artist, slug: artist.slug, title: artist.title, children: nil)
        } else if let designer = asDesigner {
            return FilterAttribute(type: .designer, slug: designer.slug, title: designer.title, children: nil)
        } else if let style = asStyle {
            return FilterAttribute(type: .style, slug: style.slug, title: style.title, children: nil)
        } else if let color = asColor {
            return FilterAttribute(type: .color, slug: color.slug, title: color.hex, children: nil)
        } else if let material = asMaterial {
            return FilterAttribute(type: .material, slug: material.slug, title: material.title, children: nil)
        }
        return nil
    }
}

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsMerchantBlock.Merchant: BlockDataSource {
    var title: Observable<String?> {
        let merchantName = getMerchantDisplayName(type: type, businessName: businessName, name: name)
        return Observable.just(merchantName)
    }
    var image: Observable<URL?> {
        Observable.just(URL(string: avatar?.url ?? ""))
    }
    var filter: FilterAttribute? { nil }
}

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsCategoryBlock.Category: BlockDataSource {
    var title: Observable<String?> {
        observedLocalizedString(categoryTitleKey(slug))
    }
    var image: Observable<URL?> {
        Observable.just(URL(string: categoryImage?.url ?? ""))
    }
    var filter: FilterAttribute? {
        FilterAttribute(type: .category, slug: slug)
    }
}

class AttributeBlockSectionViewModel: BlockViewModel {
    private let datasource: BlockDataSource
    private let _showTitle: Bool

    struct Outputs {
        fileprivate let _objectClick = PublishSubject<BlockDataSource>()
        var objectClick: Observable<BlockDataSource> {
            _objectClick.asObserver()
        }
    }

    let outputs = Outputs()

    init(datasource: BlockDataSource, showTitle: Bool) {
        self.datasource = datasource
        _showTitle = showTitle
    }

    var title: Observable<String?> {
        datasource.title
    }
    
    var slug: String {
        datasource.slug
    }

    var showTrendTitle: Observable<Bool> {
        Observable.just(_showTitle)
    }

    var image: Observable<URL?> {
        datasource.image
    }

    var filter: FilterAttribute? {
        datasource.filter
    }

    func cellClicked() {
        outputs._objectClick.onNext(datasource)
    }
}
