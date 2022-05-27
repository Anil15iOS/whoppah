//
//  LargeButton.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

@IBDesignable
class PrimaryLargeButton: UIButton {
    enum Style: Int {
        case primary
        case secondary
        case tertiary
        case shinyBlue
    }

    // MARK: - Properties

    private let spinner = UIActivityIndicatorView(style: .medium)
    var style: Style = .primary {
        didSet { updateStyle() }
    }

    // MARK: - IBInspectable

    @IBInspectable var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }

    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 16.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }

    override var bounds: CGRect {
        didSet {
            spinner.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        }
    }

    // MARK: - States

    override var isEnabled: Bool {
        didSet {
            titleLabel?.alpha = isEnabled ? 1.0 : 0.5
            if isEnabled {
                switch style {
                case .primary:
                    backgroundColor = .orange
                    shadowOpacity = 0.0
                case .secondary:
                    backgroundColor = .blue
                    shadowOpacity = 0.0
                case .tertiary:
                    backgroundColor = .white
                    shadowOpacity = 0.1
                case .shinyBlue:
                    backgroundColor = .shinyBlue
                    shadowOpacity = 0.0
                }
            } else {
                shadowOpacity = 0.0
                backgroundColor = .silver
            }
        }
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

    private func highlight() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [unowned self] in
                self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                self.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.shadowRadius = 8.0
            },
            completion: { _ in }
        )
    }

    private func unhighlight() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [unowned self] in
                self.transform = CGAffineTransform.identity
                self.shadowOffset = CGSize(width: 0.0, height: 4.0)
                self.shadowRadius = 16.0
            },
            completion: { _ in }
        )
    }

    private func updateStyle() {
        switch style {
        case .primary:
            cornerRadius = 4.0
            backgroundColor = .orange
            shadowColor = backgroundColor
            shadowOpacity = 0.0
            shadowOffset = .zero
            shadowRadius = 0.0
            setTitleColor(UIColor.white, for: .normal)
            titleLabel?.font = UIFont.button
        case .secondary:
            cornerRadius = 4.0
            backgroundColor = .blue
            shadowColor = backgroundColor
            shadowOpacity = 0.0
            shadowOffset = .zero
            shadowRadius = 0.0
            setTitleColor(UIColor.white, for: .normal)
            titleLabel?.font = UIFont.button
        case .tertiary:
            cornerRadius = 4.0
            backgroundColor = .white
            shadowColor = UIColor.black
            shadowOpacity = 0.1
            shadowOffset = .zero
            shadowRadius = 0.0
            setTitleColor(UIColor.space, for: .normal)
            titleLabel?.font = UIFont.button
        case .shinyBlue:
            cornerRadius = 4.0
            backgroundColor = .shinyBlue
            shadowColor = backgroundColor
            shadowOpacity = 0.0
            shadowOffset = .zero
            shadowRadius = 0.0
            setTitleColor(UIColor.white, for: .normal)
            titleLabel?.font = UIFont.button
        }
    }

    func startAnimating() {
        spinner.startAnimating()
        titleLabel?.alpha = 0.0
    }

    func stopAnimating() {
        spinner.stopAnimating()
        titleLabel?.alpha = 1.0
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

        updateStyle()
    }
}

extension Reactive where Base: PrimaryLargeButton {
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

// Cannot set style via interface builder
// This 'workaround' allows the setting of a button class so we don't need an outlet just to set style

@IBDesignable
class PrimaryLargeButtonPrimary: PrimaryLargeButton {
    override var style: PrimaryLargeButton.Style {
        get { .primary }
        set {}
    }
}

@IBDesignable
class PrimaryLargeButtonShinyBlue: PrimaryLargeButton {
    override var style: PrimaryLargeButton.Style {
        get { .shinyBlue }
        set {}
    }
}

@IBDesignable
class PrimaryLargeButtonSecondary: PrimaryLargeButton {
    override var style: PrimaryLargeButton.Style {
        get { .secondary }
        set {}
    }
}

@IBDesignable
class PrimaryLargeButtonTertiary: PrimaryLargeButton {
    override var style: PrimaryLargeButton.Style {
        get { .tertiary }
        set {}
    }
}
