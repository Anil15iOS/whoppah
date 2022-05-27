//
//  AttributeTextButtonCell.swift
//  Whoppah
//
//  Created by Eddie Long on 02/07/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

class AttributeTextButtonCell: UICollectionViewCell {
    // MARK: - Constants

    static let identifier = "AttributeTextButtonCell"
    static let nibName = "AttributeTextButtonCell"
    static let aspect: CGFloat = 0.285
    // MARK: - IBOutlets

    @IBOutlet var button: UIButton!
    
    // MARK: - Properties

    var viewModel: AttributeBlockSectionViewModel!
    var bag: DisposeBag!
    // MARK: - Nib

    // MARK: - State

    func configure(with vm: AttributeBlockSectionViewModel) {
        viewModel = vm
        bag = DisposeBag()
        vm.title.bind(animated: button.rx.title(for: .normal)).disposed(by: bag)
        button.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel?.cellClicked()
        }).disposed(by: bag)
    }
}
