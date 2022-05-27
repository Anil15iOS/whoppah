//
//  WPTextView.swift
//  Whoppah
//
//  Created by Eddie Long on 15/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import UIKit

class WPTextViewContainer: UIView {
    @IBInspectable open var cornerRadius: CGFloat = 4 {
        didSet {
            updateBorder()
        }
    }

    @IBInspectable open var borderWidth: CGFloat = 1.0 {
        didSet {
            updateBorder()
        }
    }

    @IBInspectable open var maskBorder: Bool = true {
        didSet {
            updateBorder()
        }
    }

    @IBInspectable open var normalTextColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }

    @IBInspectable open var titleColor: UIColor = .silver {
        didSet {
            updateColors()
        }
    }

    @IBInspectable open var errorColor: UIColor = R.color.redInvalidLight()! {
        didSet {
            updateColors()
        }
    }

    /// The String to display when the textfield is not editing and the input is not empty.
    @IBInspectable open var title: String? {
        didSet {
            updateTitleLabel()
            updateBorderMask()
        }
    }

    @IBInspectable open var allowsErrorIcon: Bool = true {
        didSet {
            updateErrorIcon()
        }
    }

    /**
     The String to display when the input field is empty.
     The placeholder can also appear in the title label when both `title` `selectedTitle` and are `nil`.
     */
    @IBInspectable
    open var placeholder: String? {
        didSet {
            textview.placeholder = placeholder
            setNeedsDisplay()
            updateTitleLabel()
        }
    }

    /// A String value for the error message to display.
    @IBInspectable
    open var errorMessage: String? {
        didSet {
            if errorLabel.isVisible != hasErrorMessage {
                errorLabel.isVisible = hasErrorMessage
                updateErrorIcon()
                updateControl(true)
                UIView.animate(withDuration: 0.1) {
                    self.invalidateIntrinsicContentSize()
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                }
            }
        }
    }

    fileprivate var _renderingInInterfaceBuilder: Bool = false
    private let textOffsetX: CGFloat = 10.0
    private var titleLabel: UILabel!
    private var errorLabel: UILabel!
    private let errorTopPadding: CGFloat = 5
    private var textviewBottomConstraint: NSLayoutConstraint!
    private var errorIcon: UIImageView!
    open var hasErrorMessage: Bool {
        errorMessage != nil && errorMessage != ""
    }

    private var border: CALayer!
    private var borderMaskLayer: CALayer!
    private var borderView: UIView!
    let textview: IQTextView

    init() {
        textview = IQTextView()
        super.init(frame: .zero)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        textview = IQTextView()
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate final func commonInit() {
        textview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textview)
        textview.pinToEdges(of: self, orientation: .horizontal, padding: 8)
        textview.verticalPin(to: self, orientation: .top, padding: 6)
        textviewBottomConstraint = textview.verticalPin(to: self, orientation: .bottom, padding: -5)
        textview.textColor = .black
        textview.backgroundColor = .clear
        createErrorLabel()
        createErrorImageview()
        createBorder()
        updateColors()
        createTitleLabel()
        updateBorder()
        updateBorderMask()
        addEditingChangedObserver()
        setup()
        bringSubviewToFront(errorIcon)
        bringSubviewToFront(errorLabel)
    }

    func setup() {}

    /// Invoked by layoutIfNeeded automatically
    open override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = titleLabelRectForBounds(bounds, editing: isTitleVisible() || _renderingInInterfaceBuilder)
        errorLabel.frame = errorLabelRectForBounds(bounds, editing: hasErrorMessage || _renderingInInterfaceBuilder)
        errorIcon.frame = errorIconRectForBounds(bounds)
        updateBorder()
    }

    /// Invoked when the interface builder renders the control
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        _renderingInInterfaceBuilder = true
        updateControl(false)
        invalidateIntrinsicContentSize()
    }

    open override var intrinsicContentSize: CGSize {
        CGSize(width: bounds.size.width, height: textview.contentHeight + errorMessageHeight())
    }

    private func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = bounds
        let existingX = rect.origin.x
        return CGRect(x: textOffsetX,
                      y: rect.origin.y,
                      width: rect.width - (textview.offsetX - existingX),
                      height: rect.height - errorMessageHeight())
    }

    fileprivate func addEditingChangedObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(editingChanged), name: UITextView.textDidChangeNotification, object: textview)
    }

    @objc open func editingChanged() {
        errorMessage = nil
        updateControl(true)
        updateTitleLabel(true)
    }

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateControl(true)
        return result
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updateControl(true)
        return result
    }

    private func updateControl(_ animated: Bool = false) {
        updateTitleLabel(animated)
        updateErrorLabel(animated)
        updateColors()
        updateTextviewSize()
    }

    private func updateErrorIcon() {
        errorIcon.isVisible = hasErrorMessage && allowsErrorIcon
    }

    private func updateTextviewSize() {
        let newPadding = -5 - errorMessageHeight()
        if textviewBottomConstraint.constant != newPadding {
            textviewBottomConstraint.constant = newPadding
            UIView.animate(withDuration: 0.1) {
                self.layoutIfNeeded()
            }
        }
    }

    // MARK: Border

    private func createBorder() {
        updateBorder()
    }

    private func updateBorderMask() {
        guard titleLabel != nil else { return }
        guard maskBorder, isTitleVisible() else {
            borderMaskLayer?.removeFromSuperlayer()
            borderMaskLayer = nil
            return
        }

        borderMaskLayer?.removeFromSuperlayer()
        let frame: CGRect = titleLabelRectForBounds(bounds, editing: true)
        let fontAttributes = [NSAttributedString.Key.font: titleLabel.font as Any]
        let text = placeholder ?? ""
        let titleSize = (text as NSString).size(withAttributes: fontAttributes)
        let padding: CGFloat = 3
        let borderFrame = CGRect(x: frame.minX - padding, y: -frame.height / 2, width: titleSize.width + padding * 2, height: frame.height)
        let inner = UIBezierPath(rect: borderFrame)
        let mask = CAShapeLayer()
        mask.path = inner.cgPath
        mask.fillColor = UIColor.white.cgColor
        borderView.layer.addSublayer(mask)
        borderMaskLayer = mask
    }

    private func updateBorder() {
        if let borderView = borderView {
            borderView.frame = bounds
        } else {
            let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            borderView = PassthroughTouchView(frame: frame)
            borderView.isUserInteractionEnabled = true
            borderView.backgroundColor = .clear
            addSubview(borderView)
        }

        if border == nil {
            border = CALayer()
            borderView.layer.addSublayer(border)
        }
        border.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - errorMessageHeight())
        border.cornerRadius = cornerRadius
        border.borderWidth = borderWidth / UIScreen.main.scale

        updateBorderMask()
        updateBorderColor()
    }

    // MARK: Title

    private let titleFadeInDuration: TimeInterval = 0.2
    private let titleFadeOutDuration: TimeInterval = 0.3

    private func createTitleLabel() {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIConstants.textfieldTitleFont
        label.backgroundColor = .clear

        insertSubview(label, aboveSubview: borderView)
        titleLabel = label

        updateTitleColor()
    }

    private func createErrorLabel() {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIConstants.textfieldTitleFont
        label.textColor = errorColor

        addSubview(label)
        errorLabel = label
    }

    private func createErrorImageview() {
        let image = UIImageView()
        image.image = R.image.textfield_error_icon()
        image.isHidden = true
        addSubview(image)
        errorIcon = image
    }

    private func updateTitleLabel(_ animated: Bool = false) {
        guard let titleLabel = titleLabel else { return }
        titleLabel.text = titleOrPlaceholder()
        updateTitleVisibility(animated)
    }

    private func updateErrorLabel(_ animated: Bool = false) {
        guard let errorLabel = errorLabel else { return }

        var errorText: String?
        if hasErrorMessage, let error = errorMessage {
            errorText = error
        } else {
            errorText = ""
        }
        errorLabel.text = errorText

        updateErrorVisibility(animated)
    }

    private func titleOrPlaceholder() -> String? {
        guard let title = title ?? placeholder else {
            return nil
        }
        return title
    }

    private func updateTitleVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
        let alpha: CGFloat = isTitleVisible() ? 1.0 : 0.0
        let frame: CGRect = titleLabelRectForBounds(bounds, editing: isTitleVisible())

        let updateBlock = { () -> Void in
            self.titleLabel.alpha = alpha
            self.titleLabel.frame = frame
            self.updateBorderMask()
        }
        if animated {
            let animationOptions: UIView.AnimationOptions = .curveEaseOut
            let duration = isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }

    private func updateErrorVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
        let alpha: CGFloat = hasErrorMessage ? 1.0 : 0.0
        let frame: CGRect = errorLabelRectForBounds(bounds, editing: hasErrorMessage)
        let updateBlock = { () -> Void in
            self.errorLabel.alpha = alpha
            self.errorLabel.frame = frame
        }
        if animated {
            let animationOptions: UIView.AnimationOptions = .curveEaseOut
            let duration = hasErrorMessage ? titleFadeInDuration : titleFadeOutDuration
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }

    private func isTitleVisible() -> Bool {
        textview.hasText
    }

    private func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let rect = textRect(forBounds: bounds)
        if editing {
            return CGRect(x: rect.minX, y: -titleHeight() / 2, width: bounds.size.width - rect.minX, height: titleHeight())
        }
        return CGRect(x: rect.minX, y: titleHeight(), width: bounds.size.width - rect.minX, height: titleHeight())
    }

    private func errorLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let rect = textRect(forBounds: bounds)
        let y = bounds.height - errorMessageHeight()
        if editing {
            return CGRect(x: rect.minX, y: y, width: bounds.size.width - rect.minX, height: errorMessageHeight())
        }
        return CGRect(x: rect.minX, y: y, width: bounds.size.width - rect.minX, height: errorMessageHeight())
    }

    private func errorIconRectForBounds(_ bounds: CGRect) -> CGRect {
        guard let imageSize = errorIcon.image?.size else { return .zero }
        let y = (bounds.height - errorMessageHeight() - imageSize.height) / 2
        return CGRect(x: bounds.width - imageSize.width - 10, y: y, width: imageSize.width, height: imageSize.height)
    }

    private func titleHeight() -> CGFloat {
        if let titleLabel = titleLabel,
            let font = titleLabel.font {
            return font.lineHeight.rounded(.up)
        }
        return 16.0
    }

    // MARK: Colors

    private func updateColors() {
        updateBorderColor()
        updateErrorColor()
        updateTitleColor()
        updateTextColor()
    }

    private func getTitleOrBorderColor() -> UIColor {
        guard !hasErrorMessage else { return errorColor }
        return titleColor
    }

    private func getTextColor() -> UIColor {
        guard !hasErrorMessage else { return errorColor }
        guard textview.text?.isEmpty == false else { return titleColor }
        return normalTextColor
    }

    private func updateTitleColor() {
        titleLabel?.textColor = getTitleOrBorderColor()
    }

    private func updateErrorColor() {
        errorLabel?.textColor = errorColor
    }

    private func updateTextColor() {
        textview.textColor = getTextColor()
    }

    private func updateBorderColor() {
        guard let border = border else { return }
        border.borderColor = getTitleOrBorderColor().cgColor
    }

    // MARK: Errors

    private func errorMessageHeight() -> CGFloat {
        if let errorLabel = errorLabel,
            hasErrorMessage,
            let font = errorLabel.font {
            return font.lineHeight + errorTopPadding
        }
        return 0.0
    }
}
