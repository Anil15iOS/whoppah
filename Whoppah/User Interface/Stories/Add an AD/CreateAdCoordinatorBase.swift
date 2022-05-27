//
//  CreateAdCoordinatorBase.swift
//  Whoppah
//
//  Created by Eddie Long on 27/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

enum CreateAdStepMode {
    case flow // Move to the next screen in the flow sequence
    case pop // Pop the screen
    case dismiss // Dismiss the nav/vc
}

protocol CreateAdBaseCoordinator: Coordinator {
    init(navigationController: UINavigationController, mode: CreateAdStepMode)
    var mode: CreateAdStepMode { get }
    func dismiss()
    func showDraftSavingDialog()
    func hideDraftSavingDialog(completed: (() -> Void)?)
    func showSaveDialog(onSave: @escaping (() -> Void), onDiscard: @escaping (() -> Void), onResume: @escaping (() -> Void))
}

extension CreateAdBaseCoordinator {
    func showSaveDialog(onSave: @escaping (() -> Void), onDiscard: @escaping (() -> Void), onResume: @escaping (() -> Void)) {
        CreateAdDialog.showSaveDialog(navigationController: navigationController, onSave: onSave, onDiscard: onDiscard, onResume: onResume)
    }

    func dismiss() {
        guard let top = navigationController.topViewController else { return }
        top.dismiss(animated: true, completion: {
            self.navigationController.viewControllers.removeAll()
        })
    }

    func hideDraftSavingDialog(completed: (() -> Void)?) {
        guard let top = navigationController.presentedViewController as? DraftSavingDialog else { completed?(); return }
        top.dismiss(animated: true, completion: completed)
    }

    func showDraftSavingDialog() {
        guard let top = navigationController.topViewController else { return }
        let dialog = DraftSavingDialog()
        top.present(dialog, animated: true, completion: nil)
    }
}
