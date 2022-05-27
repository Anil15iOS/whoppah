//
//  CategoryCellViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 24/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import RxSwift

class CircleImageCellViewModel {
    let title: Observable<String?>
    let image: Observable<URL?>
    let slug: String
    
    struct Outputs {
        let itemClicked = PublishSubject<Void>()
    }

    let outputs = Outputs()
    
    init(title: String, url: URL?, slug: String) {
        self.title = observedLocalizedString(title)
        self.image = Observable.just(url)
        self.slug = slug
    }
    
    init(title: Observable<String?>, url: Observable<URL?>, slug: String) {
        self.title = title
        self.image = url
        self.slug = slug
    }
    
    func onClick() {
        outputs.itemClicked.onNext(())
    }
}
