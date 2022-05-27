//
//  SecondaryLargeButton.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/27/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

@IBDesignable
class SecondaryLargeButton: UIButton {
    // MARK: - Properties

    private let spinner = UIActivityIndicatorView(style: .medium)

    @IBInspectable var buttonColor: UIColor = .orange {
        didSet {
            layer.borderColor = buttonColor.cgColor
            tintColor = buttonColor
            setTitleColor(buttonColor, for: .normal)
        }
    }

    override var bounds: CGRect {
        didSet {
            spinner.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        }
    }

    override var backgroundColor: UIColor? {
        didSet {
            updateSpinnerForBackground()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Common Init

    private func commonInit() {
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
        spinner.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        addSubview(spinner)

        layer.borderWidth = 1.0
        layer.borderColor = UIColor.orange.cgColor
        layer.cornerRadius = 4.0

        setTitleColor(UIColor.orange, for: .normal)

        titleLabel?.font = UIFont.button
        tintColor = .clear

        updateSpinnerForBackground()
    }

    // MARK: - Appearance

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlight()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        unhighlight()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        unhighlight()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    private func updateSpinnerForBackground() {
        let background = backgroundColor ?? UIColor.white
        if let isLight = background.isLight(), isLight {
            spinner.style = .medium
        } else {
            spinner.style = .medium
        }
    }

    private func highlight() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [unowned self] in
                self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            },
            completion: { _ in }
        )
    }

    private func unhighlight() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [unowned self] in
                self.transform = CGAffineTransform.identity
            },
            completion: { _ in }
        )
    }

    func startAnimating() {
        spinner.startAnimating()
        titleLabel?.alpha = 0.0
    }

    func stopAnimating() {
        spinner.stopAnimating()
        titleLabel?.alpha = 1.0
    }
}

extension Reactive where Base: SecondaryLargeButton {
    /// Bindable sink for `hidden` property.
    var isAnimating: Binder<Bool> {
        Binder(base) { view, loading in
            if loading {
                view.startAnimating()
            } else {
                view.stopAnimating()
            }
        }
    }
}
