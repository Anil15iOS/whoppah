//
//  CreateAdViewModelBase.swift
//  Whoppah
//
//  Created by Eddie Long on 27/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver

class CreateAdViewModelBase {
    @Injected var adCreator: ADCreator
    @Injected var adService: ADsService
    @Injected var eventTracking: EventTrackingService

    private let bag = DisposeBag()
    private let coordinator: CreateAdBaseCoordinator

    init(coordinator: CreateAdBaseCoordinator) {
        self.coordinator = coordinator
    }

    var showSaveButton: Bool {
        switch coordinator.mode {
        case .flow: return true
        default: return false
        }
    }

    var returnsToSummary: Bool {
        switch coordinator.mode {
        case .flow: return false
        default: return true
        }
    }

    var showCloseButton: Bool { coordinator.navigationController.viewControllers.count == 1 }

    func showSaveDialog() {
        let onSave: () -> Void = {
            self.coordinator.showDraftSavingDialog()
            self.adCreator.saveDraft()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.eventTracking.createAd.trackDraftSave()
                    self.coordinator.hideDraftSavingDialog {
                        self.coordinator.dismiss()
                    }
                }, onError: { [weak self] error in
                    self?.coordinator.hideDraftSavingDialog(completed: {
                        self?.coordinator.showError(error)
                    })
                }).disposed(by: self.bag)
        }
        let onDiscard: () -> Void = {
            if let id = self.adCreator.template?.id, let state = self.adCreator.template?.state {
                self.adService.deleteAd(id: id, state: state, reason: nil).subscribe(onNext: { _ in
                }).disposed(by: self.bag)
            }
            self.close()
        }
        let onResume: () -> Void = {
            self.eventTracking.createAd.trackDraftResume()
        }
        coordinator.showSaveDialog(onSave: onSave, onDiscard: onDiscard, onResume: onResume)
    }

    func close() {
        adCreator.cancelCreating()
        dismiss()
    }

    func dismiss() {
        coordinator.dismiss()
    }
}

func hasArtCategory(_ categories: [WhoppahCore.AdAttribute]) -> Bool {
    for category in categories.compactMap({ $0 as? WhoppahCore.CategoryBasic }) {
        if category.isArt { return true }
        
        var parent = category.ancestor
        while let ancestor = parent {
            if ancestor.isArt { return true }
            parent = ancestor.ancestor
        }
    }
    return categories.first?.isArt ?? false
}
