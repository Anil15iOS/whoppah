//
//  WPPhoneNumber.swift
//  Whoppah
//
//  Created by Eddie Long on 23/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import FlagPhoneNumber
import Foundation
import RxCocoa
import RxSwift
import UIKit

class WPPhoneTextfield: FPNTextField {
    var isValid = BehaviorRelay<Bool>(value: false)

    private let leftViewSize: CGFloat = 70.0
    private let bag = DisposeBag()

    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return CGRect(x: rect.minX, y: rect.minY, width: leftViewSize + 8, height: rect.height)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        setCountries(including: Country.phoneCodes)
        flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)

        rx.text.orEmpty
            .map { [weak self] text in
                guard !text.isEmpty else { return false }
                guard let phone = self?.getFormattedPhoneNumber(format: .E164) else { return false }
                guard !phone.contains("(null)") else { return false }
                return true
            }
            .bind(to: isValid).disposed(by: bag)
    }

    func getNumber(format: FPNFormat) -> String? {
        guard isValid.value else { return nil }
        return getFormattedPhoneNumber(format: format)
    }
}

class WPPhoneNumber: UIView {
    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var textfield: WPPhoneTextfield!
    
    var errorLabel: UILabel!
    private let errorTopPadding: CGFloat = 5
    private var errorIcon: UIImageView!
    
    private let errorFadeInDuration: TimeInterval = 0.2
    private let errorFadeOutDuration: TimeInterval = 0.3
    
    open var hasErrorMessage: Bool {
        errorMessage != nil && errorMessage != ""
    }
    
    var errorMessage: String? {
        didSet {
            if errorMessage != oldValue {
                errorLabel.text = errorMessage
                errorLabel.isVisible = hasErrorMessage
                updateErrorVisibility(true, completion: nil)
            }
        }
    }

    var borderColor: UIColor? {
        didSet {
            contentView.layer.borderColor = borderColor?.cgColor ?? UIColor.silver.cgColor
            textfield.textColor = borderColor ?? UIColor.black
        }
    }
    
    @IBInspectable open var errorColor: UIColor = R.color.redInvalidLight()! {
        didSet {
            errorLabel.textColor = errorColor
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

    // MARK: - Common

    private func commonInit() {
        Bundle.main.loadNibNamed("WPPhoneNumber", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1 / UIScreen.main.scale
        contentView.layer.borderColor = UIColor.silver.cgColor
        
        // Add tap view so the user can tap the country code
        let buttonWidth = textfield.flagButtonSize.width
        let viewRect = textfield.leftViewRect(forBounds: bounds)
        let originX = viewRect.origin.x + buttonWidth
        let size = CGSize(width: viewRect.width - buttonWidth, height: viewRect.height)
        let tapView = UIView(frame: CGRect(origin: CGPoint(x: originX, y: 20), size: size))
        tapView.backgroundColor = .clear
        addSubview(tapView)
        textfield.flagButton.imageView?.isHidden = true
        textfield.flagButtonSize = .zero
        textfield.hasPhoneNumberExample = false
        textfield.placeholder = R.string.localizable.commonPhoneNumberPlaceholder()

        guard let left = textfield.leftView else { return }
        guard let lastView = left.subviews.last else { return }
        lastView.removeConstraints(lastView.constraints)
        lastView.horizontalPin(to: left, orientation: .leading, padding: 12)
        lastView.pinToEdges(of: left, orientation: .vertical)

        let arrow = ViewFactory.createImage(image: R.image.phoneExpandMore(), width: 24, aspect: 1.0)
        left.addSubview(arrow)
        arrow.center(withView: left, orientation: .vertical)

        let divider = ViewFactory.createDivider(orientation: .vertical)
        left.addSubview(divider)
        divider.alignAfter(view: arrow, withPadding: 8)
        divider.center(withView: left, orientation: .vertical)
        divider.horizontalPin(to: left, orientation: .trailing, padding: -8)
        divider.pinToEdges(of: left, orientation: .vertical, padding: 8)
        arrow.alignBefore(view: divider, withPadding: -8)
        
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIConstants.textfieldTitleFont
        label.textColor = errorColor

        addSubview(label)
        errorLabel = label
        
        updateErrorVisibility()

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapNumber))
        left.addGestureRecognizer(tap)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        errorLabel.frame = errorLabelRectForBounds(bounds)
    }
    
    private func errorLabelRectForBounds(_ bounds: CGRect) -> CGRect {
        let minX: CGFloat = 12
        let y = bounds.height
        return CGRect(x: minX, y: y, width: bounds.size.width - minX, height: errorMessageHeight())
    }
    
    private func errorMessageHeight() -> CGFloat {
        if let errorLabel = errorLabel,
            hasErrorMessage,
            let font = errorLabel.font {
            return font.lineHeight + errorTopPadding
        }
        return 0.0
    }
    
    private func updateErrorVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
        let alpha: CGFloat = hasErrorMessage ? 1.0 : 0.0
        let frame: CGRect = errorLabelRectForBounds(bounds)
        let updateBlock = { () -> Void in
            self.errorLabel.alpha = alpha
            self.errorLabel.frame = frame
        }
        if animated {
            let animationOptions: UIView.AnimationOptions = .curveEaseOut
            let duration = hasErrorMessage ? errorFadeInDuration : errorFadeOutDuration
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }
    
    @objc func tapNumber() {
        textfield.flagButton.sendActions(for: .touchUpInside)
    }
}
