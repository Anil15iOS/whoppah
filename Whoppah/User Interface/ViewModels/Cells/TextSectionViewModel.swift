//
//  ImageViewViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 12/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore

class TextSectionViewModel {
    struct Outputs {
        var onClick: Observable<TextSection> {
            _onClick.asObservable()
        }

        fileprivate let _onClick = PublishRelay<TextSection>()
    }

    let outputs = Outputs()

    private let section: TextSection
    init(section: TextSection) {
        self.section = section
    }

    var slug: Observable<String> { Observable.just(section.slug) }

    var title: Observable<String?> { observedLocalizedString(section.titleKey) }

    var description: Observable<String?> {
        guard let description = section.descriptionKey else { return Observable.just(nil) }
        return observedLocalizedString(description, placeholder: nil)
    }

    var image: Observable<URL?> {
        guard let url = section.imageURL else { return Observable.just(nil) }
        return Observable.just(url)
    }

    var button: Observable<String?> {
        if section.clickLink == nil { return Observable.just(nil) }
        return observedLocalizedString(section.buttonKey, placeholder: R.string.localizable.common_btn_shop_now())
    }

    func onClick() {
        outputs._onClick.accept(section)
    }
}
