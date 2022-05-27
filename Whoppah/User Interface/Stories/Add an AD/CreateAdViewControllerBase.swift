//
//  CreateAdBaseViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 27/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

class CreateAdViewControllerBase: UIViewController {
    let bag = DisposeBag()

    func addSaveButton(_ viewModel: CreateAdViewModelBase) {
        if viewModel.showSaveButton {
            let saveButton = UIBarButtonItem(title: R.string.localizable.createAdNavbarSaveButton(), style: .plain, target: nil, action: nil)
            navigationItem.rightBarButtonItem = saveButton
            saveButton.rx.tap.bind { [weak viewModel] _ in
                viewModel?.showSaveDialog()
            }.disposed(by: bag)
        }
    }

    func addCloseButtonIfRequired(_ viewModel: CreateAdViewModelBase) {
        if viewModel.showCloseButton {
            addCloseButton(image: R.image.ic_close()).rx.tap.bind { [weak viewModel] _ in
                viewModel?.close()
            }.disposed(by: bag)
        }
    }

    func nextButtonText(_ viewModel: CreateAdViewModelBase, _ defaultText: String) -> String {
        if viewModel.returnsToSummary {
            return R.string.localizable.createAdCommonSaveToSummaryButton()
        }
        return defaultText
    }
}
