//
//  HomeImageViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 12/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver

class TextBlockViewModel: BlockViewModel {
    private let block: TextBlock
    struct Inputs {
        let sectionClicked = PublishSubject<TextSection>()
    }
    
    enum Style {
        case carousel
        case single
        case type1
    }

    let inputs = Inputs()
    private let bag = DisposeBag()
    
    @Injected private var searchService: SearchService

    init(block: TextBlock) {
        self.block = block
        
        super.init()

        inputs.sectionClicked.subscribe(onNext: { [weak self] section in
            guard let self = self, let link = section.clickLink else { return }
            self.searchService.removeAllFilters()
            if DeeplinkManager.shared.handleDeeplink(url: link) {
                DeeplinkManager.shared.executeDeeplink()
            }
        }).disposed(by: bag)
    }

    var sections: [TextSectionViewModel] {
        var vms = [TextSectionViewModel]()
        for section in block.textSections {
            vms.append(TextSectionViewModel(section: section))
        }
        return vms
    }
    
    var showTitleView: Observable<Bool> {
        guard style != .type1 else {
            return Observable.just(false)
        }
        return Observable.just(block.clickLink != nil)
    }

    var title: Observable<String?> {
        guard style != .type1 else {
            return observedLocalizedString(block.titleKey)
        }
        
        if block.clickLink == nil { return Observable.just(nil) }
        return observedLocalizedString(block.titleKey)
    }
    
    var description: Observable<String?> {
        return observedLocalizedString(block.descriptionKey)
    }
    
    var button: Observable<String?> {
        if block.clickLink == nil { return Observable.just(nil) }
        return observedLocalizedString(block.buttonKey, placeholder: R.string.localizable.common_btn_show_all())
    }
    
    var image: Observable<URL?> {
        Observable.just(URL(string: block.image))
   }

    // MARK: Actions

    func didClickButton() {
        guard let link = block.clickLink else { return }
        searchService.removeAllFilters()
        if DeeplinkManager.shared.handleDeeplink(url: link) {
            DeeplinkManager.shared.executeDeeplink()
        }
    }
    
    var style: Style {
        guard block.slug.starts(with: "type-1") else {
            guard sections.count != 1 else { return .single }
            return .carousel
        }
        return .type1
    }

    public enum BlockType {
        case map
        case howWorksButton
        case cartButton
        case unknown
    }

    var blockType: BlockType {
        switch block.slug {
        case "home-map":
            return .map
        default:
            if block.slug.starts(with: "type-cart") {
                return .cartButton
            } else if block.slug.starts(with: "type-how-works") {
                return .howWorksButton
            }
            return .unknown
        }
    }
}
