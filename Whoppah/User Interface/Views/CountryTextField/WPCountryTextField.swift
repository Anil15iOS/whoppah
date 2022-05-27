//
//  WPCountryTextField.swift
//  Whoppah
//
//  Created by Eddie Long on 29/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class WPCountryTextField: WPTextField {
    let picker: UIPickerView = UIPickerView()
    private let bag = DisposeBag()

    override init() {
        super.init()
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let downArrow = ViewFactory.createImage(image: R.image.downArrowLight())
        addSubview(downArrow)
        downArrow.center(withView: self, orientation: .vertical)
        downArrow.horizontalPin(to: self, orientation: .trailing, padding: -UIConstants.margin)

        picker.translatesAutoresizingMaskIntoConstraints = false
        inputView = picker

        let countries = Observable.just(Country.allCases.map { $0.title })
        countries.bind(to: picker.rx.itemTitles) { _, element in
            element
        }
        .disposed(by: bag)

        contentHeight = UIConstants.textfieldHeight
    }

    override func caretRect(for _: UITextPosition) -> CGRect { .zero }
}
