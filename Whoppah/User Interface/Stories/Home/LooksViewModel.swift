//
//  LooksViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 25/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahDataStore
import Resolver

class LooksViewModel {
    private let repository: LooksRepository
    let coordinator: LooksCoordinator

    private let bag = DisposeBag()
    
    @Injected private var eventTracking: EventTrackingService
    @Injected private var search: SearchService

    struct Inputs {
        let searchText = PublishSubject<String>()
    }

    let inputs = Inputs()
    var lookList = BehaviorSubject<ListAction>(value: .initial)
    var lookSections = [LookSection]()

    init(repository: LooksRepository, coordinator: LooksCoordinator) {
        self.repository = repository
        self.coordinator = coordinator

        _ = repository.lookSections.subscribe(onNext: { [weak self] lookList in
            guard let self = self else { return }
            guard !lookList.isEmpty else {
                return self.lookList.onNext(.loadingInitial)
            }

            self.lookSections = lookList.filter { section in
                section.looks.forEach {
                    $0.outputs.objectClick.subscribe(onNext: { [weak self] attribute in
                        guard let self = self else { return }
                        self.onLookClicked(attribute)
                    }).disposed(by: self.bag)
                }
                return !section.looks.isEmpty
            }

            self.lookList.onNext(.reloadAll)
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.lookList.onError(error)
        }).disposed(by: bag)

        inputs.searchText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.coordinator.openSearch(text: text)
        }).disposed(by: bag)

        repository.loadLooks()
    }
}

// MARK: Looks datasource

extension LooksViewModel {
    func getCell(section: Int, row: Int) -> AttributeBlockSectionViewModel {
        assert(section < lookSections.count)
        assert(row < lookSections[section].looks.count)
        let cell = lookSections[section].looks[row]
        return cell
    }

    func numberOfSections() -> Int {
        lookSections.count
    }

    func numberOfRows(inSection section: Int) -> Int {
        let total = lookSections[section].looks.count
        return total >= 3 ? 3 : 1
    }

    func onLookClicked(_ datasource: BlockDataSource) {
        guard let attribute = datasource as? GraphQL.GetPageQuery.Data.PageByKey.Block.AsAttributeBlock.Attribute else { return }
        search.removeAllFilters()
        if let brand = attribute.asBrand {
            eventTracking.home.trackClickedLook(name: brand.slug, page: .looks)
            search.brands.append(FilterAttribute(type: .brand, slug: brand.slug, title: brand.title, children: nil))
//        } else if let artist = attribute.asArtist {
//            eventTracking.home.trackClickedLook(name: artist.slug, page: .looks)
//            search.artists.append(FilterAttribute(type: .artist, slug: artist.slug, title: artist.title, children: nil))
        } else if let designer = attribute.asDesigner {
            eventTracking.home.trackClickedLook(name: designer.slug, page: .looks)
            search.designers.append(FilterAttribute(type: .designer, slug: designer.slug, title: designer.title, children: nil))
        } else if let style = attribute.asStyle {
            eventTracking.home.trackClickedLook(name: style.slug, page: .looks)
            search.styles.append(FilterAttribute(type: .style, slug: style.slug, title: style.title, children: nil))
        } else if let color = attribute.asColor {
            eventTracking.home.trackClickedLook(name: color.slug, page: .looks)
            search.colors.append(FilterAttribute(type: .color, slug: color.slug, title: color.hex, children: nil))
        } else if let material = attribute.asMaterial {
            eventTracking.home.trackClickedLook(name: material.slug, page: .looks)
            search.materials.append(FilterAttribute(type: .material, slug: material.slug, title: material.title, children: nil))
        }
        coordinator.openSearch()
    }
}
