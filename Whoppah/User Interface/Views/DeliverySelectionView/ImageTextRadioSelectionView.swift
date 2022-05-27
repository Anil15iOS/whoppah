//
//  ImageTextRadioSelectionView.swift
//  Whoppah
//
//  Created by Eddie Long on 11/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class ImageTextRadioSelectionView: UIView {
    override var bounds: CGRect {
        didSet {
            let width = bounds.width - 32.0
            for button in subviews.compactMap({ $0 as? ImageTextRadioButton }) {
                button.bounds.size = CGSize(width: width, height: button.frame.height)
                button.frame.origin = CGPoint(x: bounds.width / 2 - button.bounds.width / 2, y: button.frame.minY)
            }
        }
    }

    var selectedButton = BehaviorSubject<ImageTextRadioButton?>(value: nil)

    private let bag = DisposeBag()

    func clearButtons() {
        for button in subviews.compactMap({ $0 as? ImageTextRadioButton }) {
            button.removeFromSuperview()
        }
    }

    @discardableResult
    func addButton(text: String, icon: UIImage) -> ImageTextRadioButton {
        let button = ImageTextRadioButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        button.pinToEdges(of: self, orientation: .horizontal)
        if let last = subviews.last(where: { $0 as? ImageTextRadioButton != nil && $0 != button }) {
            button.alignBelow(view: last, withPadding: 8)
        } else {
            button.verticalPin(to: self, orientation: .top)
        }
        button.name = text
        button.size = ""
        button.image = icon
        let tap = UITapGestureRecognizer()
        tap.rx.event.map { _ in button }.bind(to: selectedButton).disposed(by: bag)
        button.addGestureRecognizer(tap)
        let buttons = subviews.compactMap { $0 as? ImageTextRadioButton }
        for button in buttons {
            button.otherButtons = buttons.filter { $0 != button }
        }
        return button
    }
}
