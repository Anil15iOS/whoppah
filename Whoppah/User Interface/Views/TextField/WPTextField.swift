//
//  WPTextField.swift
//  Whoppah
//
//  Created by Eddie Long on 23/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

class WPTextField: UITextField {
    open var leftViewRect: CGRect?

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

    @IBInspectable open var contentHeight: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
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

    override var text: String? {
        didSet {
            if text != oldValue {
                errorMessage = nil
                editingChanged()
            }
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
    open override var placeholder: String? {
        didSet {
            setNeedsDisplay()
            updatePlaceholder()
            updateTitleLabel()
        }
    }

    open var skeletonable: Bool? {
        willSet {
            guard let skeleton = newValue else { return }
            isSkeletonable = skeleton
            subviews.forEach { $0.isSkeletonable = true }
        }
    }

    /// A String value for the error message to display.
    @IBInspectable
    open var errorMessage: String? {
        didSet {
            if errorMessage != oldValue {
                errorLabel.isVisible = hasErrorMessage
                hasError = hasErrorMessage
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
    private let offsetX: CGFloat = 10.0
    private var titleLabel: UILabel!
    private var errorLabel: UILabel!
    private let errorTopPadding: CGFloat = 5

    private var errorIcon: UIImageView!
    /// Whether an error is enabled, without a message
    var hasError: Bool = false {
        didSet {
            updateErrorIcon()
            updateControl(true)
        }
    }

    /// Whether an error message is set
    open var hasErrorMessage: Bool {
        errorMessage != nil && errorMessage != ""
    }

    private var border: CALayer!
    private var borderMaskLayer: CALayer!
    private var borderView: UIView!

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate final func commonInit() {
        textColor = .black
        createErrorLabel()
        createErrorImageview()
        createBorder()
        updateColors()
        createTitleLabel()
        updateBorderMask()
        addEditingChangedObserver()
        setup()
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

    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        if let rect = leftViewRect {
            let height = bounds.height - errorMessageHeight()
            return CGRect(x: rect.minX, y: height - rect.height, width: rect.width, height: rect.height)
        }
        return super.leftViewRect(forBounds: bounds)
    }

    /// Invoked when the interface builder renders the control
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        isSelected = true
        _renderingInInterfaceBuilder = true
        updateControl(false)
        invalidateIntrinsicContentSize()
    }

    open override var intrinsicContentSize: CGSize {
        CGSize(width: bounds.size.width, height: contentHeight + errorMessageHeight())
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        let existingX = rect.origin.x
        let minX = leftViewRect?.maxX ?? offsetX
        return CGRect(x: minX,
                      y: rect.origin.y,
                      width: rect.width - (offsetX - existingX),
                      height: rect.height - errorMessageHeight())
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        let existingX = rect.origin.x
        let minX = leftViewRect?.maxX ?? offsetX
        return CGRect(x: minX,
                      y: rect.origin.y,
                      width: rect.width - (offsetX - existingX),
                      height: rect.height - errorMessageHeight())
    }

    fileprivate func addEditingChangedObserver() {
        addTarget(self, action: #selector(WPTextField.editingChanged), for: .editingChanged)
    }

    @objc open func editingChanged() {
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
    }

    private func updateErrorIcon() {
        errorIcon.isVisible = (hasErrorMessage || hasError) && allowsErrorIcon
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
            borderView = PassthroughTouchView(frame: bounds)
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

        addSubview(label)
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
        hasText
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
            return font.lineHeight
        }
        return 15.0
    }

    // MARK: Colors

    private func updateColors() {
        updateBorderColor()
        updateErrorColor()
        updateTitleColor()
        updateTextColor()
    }

    private func getTitleOrBorderColor() -> UIColor {
        guard !hasErrorMessage, !hasError else { return errorColor }
        return titleColor
    }

    private func getTextColor() -> UIColor {
        guard !hasErrorMessage, !hasError else { return errorColor }
        guard text?.isEmpty == false else { return titleColor }
        return normalTextColor
    }

    private func updateTitleColor() {
        titleLabel?.textColor = getTitleOrBorderColor()
    }

    private func updateErrorColor() {
        errorLabel?.textColor = errorColor
    }

    private func updateTextColor() {
        super.textColor = getTextColor()
    }

    private func updateBorderColor() {
        border.borderColor = getTitleOrBorderColor().cgColor
    }

    // MARK: Placeholder

    fileprivate func updatePlaceholder() {
        guard let placeholder = placeholder, let font = font else {
            return
        }
        let color = getTitleOrBorderColor()
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font
            ]
        )
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
