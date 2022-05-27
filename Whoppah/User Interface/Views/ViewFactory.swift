//
//  ViewFactory.swift
//  Whoppah
//
//  Created by Eddie Long on 20/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import WhoppahCore
import WhoppahRepository
import AuthenticationServices

private extension UIView {
    func setSkeletonable(_ value: Bool? = nil) {
        if let skeleton = value {
            isSkeletonable = skeleton
        }
    }
}

class ViewFactory {
    enum DividerOrientation {
        case vertical
        case horizontal
    }

    static func createDivider(orientation: DividerOrientation, backgroundColor: UIColor = .smoke) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        switch orientation {
        case .vertical:
            view.setWidthAnchor(1.0)
        case .horizontal:
            view.setHeightAnchor(1.0)
        }
        view.backgroundColor = backgroundColor
        return view
    }

    class RootView: UIView {
        weak var scrollView: UIScrollView?
        override var bounds: CGRect {
            didSet {
                scrollView?.contentSize = bounds.size
            }
        }
    }

    static func createView(skeletonable: Bool? = nil) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setSkeletonable(skeletonable)
        return view
    }

    struct ScrollViews {
        let scroll: UIScrollView
        let root: RootView
    }

    enum ScrollOrientation {
        case horizontal
        case vertical
    }

    static func createScrollView(orientation: ScrollOrientation = .vertical) -> ScrollViews {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let root = RootView()
        root.scrollView = scrollView
        root.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(root)
        switch orientation {
        case .vertical:
            root.pinToEdges(of: scrollView, orientation: .horizontal)
        case .horizontal:
            root.pinToEdges(of: scrollView, orientation: .vertical)
        }
        return ScrollViews(scroll: scrollView, root: root)
    }

    static func createRoundedRect(withColor color: UIColor, radius: CGFloat = 10, height: CGFloat?) -> UIView {
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.layer.cornerRadius = radius
        base.layer.masksToBounds = true
        base.backgroundColor = color
        if let height = height {
            base.setHeightAnchor(height)
        }
        return base
    }

    static func createLabel(text: String,
                            lines: Int? = nil,
                            alignment: NSTextAlignment? = nil,
                            font: UIFont? = nil,
                            skeletonable: Bool? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        if let lines = lines {
            label.numberOfLines = lines
        }
        if let align = alignment {
            label.textAlignment = align
        }
        if let font = font {
            label.font = font
        } else {
            label.font = UIConstants.bodyFont
        }
        if text.containsHtml() {
            label.setHtml(text)
        } else {
            label.text = text
        }
        label.setSkeletonable(skeletonable)
        return label
    }

    static func createTextView(placeholder: String = "") -> WPTextViewContainer {
        let textview = WPTextViewContainer()
        textview.textview.font = UIConstants.textviewFont
        textview.textview.textColor = .black
        textview.placeholder = placeholder
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }

    static func createTextview(_ text: String) -> UITextView {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.text = text
        textview.font = UIConstants.titleFont
        textview.textColor = .black
        return textview
    }

    static func createTitle(_ text: String, font: UIFont? = nil, skeletonable: Bool? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        if let font = font {
            label.font = font
        } else {
            label.font = UIConstants.titleFont
        }
        label.textColor = .black
        label.setSkeletonable(skeletonable)
        return label
    }

    static func createCheckbox(width: CGFloat? = nil) -> CheckBox {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            checkbox.setSize(width, width)
        }
        return checkbox
    }

    static func createRadioButton(width: CGFloat? = nil, skeletonable: Bool? = nil) -> RadioButton {
        let radio = RadioButton()
        radio.translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            radio.setWidthAnchor(width)
            radio.setHeightAnchor(width)
        }
        radio.setSkeletonable(skeletonable)
        return radio
    }

    static func createCurvedCard() -> CurvedCard {
        let card = CurvedCard(frame: .zero)
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }

    static func createCurvedCardImage(image: UIImage?) -> CurvedCardImage {
        let card = CurvedCardImage(frame: .zero)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.image = image
        return card
    }

    static func createImage(image: UIImage?,
                            width: CGFloat? = nil,
                            height: CGFloat? = nil,
                            aspect: CGFloat? = nil,
                            skeletonable: Bool? = nil) -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = image
        if let width = width {
            iv.setWidthAnchor(width)
        }
        if let aspect = aspect {
            iv.setAspect(aspect)
        } else if let height = height {
            iv.setHeightAnchor(height)
        }
        iv.setSkeletonable(skeletonable)
        return iv
    }

    static func createMediaView() -> MediaView {
        let mediaView = MediaView(frame: .zero)
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        return mediaView
    }

    static func createImageButton(image: UIImage?, width: CGFloat, height: CGFloat? = nil, circular: Bool = false) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.setWidthAnchor(width)
        if circular {
            button.setAspect(1.0)
        } else if let height = height {
            button.setHeightAnchor(height)
        }
        return button
    }

    static func createButton(text: String? = nil,
                             image: UIImage? = nil,
                             skeletonable _: Bool? = nil) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        if let image = image {
            button.setImage(image, for: .normal)
        }
        button.titleLabel?.font = UIConstants.buttonFont
        return button
    }

    static func createPrimaryButton(text: String,
                                    style: PrimaryLargeButton.Style = .primary,
                                    skeletonable: Bool? = nil) -> PrimaryLargeButton {
        let button = PrimaryLargeButton(type: .custom)
        button.style = style
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIConstants.buttonFont
        button.setSkeletonable(skeletonable)
        return button
    }

    static func createSecondaryButton(text: String, icon: UIImage? = nil, buttonColor: UIColor? = nil) -> SecondaryLargeButton {
        let button = SecondaryLargeButton(type: .custom)
        if let buttonColor = buttonColor {
            button.buttonColor = buttonColor
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIConstants.buttonFont

        if let icon = icon {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            button.setImage(icon, for: .normal)
        }
        return button
    }

    private static func createStack(views: [UIView]? = nil, axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, skeletonable: Bool? = nil) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views ?? [])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.spacing = spacing
        stack.setSkeletonable(skeletonable)
        return stack
    }

    static func createHorizontalStack(views: [UIView]? = nil, spacing: CGFloat = 0, skeletonable: Bool? = nil) -> UIStackView {
        createStack(views: views, axis: .horizontal, spacing: spacing, skeletonable: skeletonable)
    }

    static func createVerticalStack(views: [UIView]? = nil, spacing: CGFloat = 0, skeletonable: Bool? = nil) -> UIStackView {
        createStack(views: views, axis: .vertical, spacing: spacing, skeletonable: skeletonable)
    }

    static func createTextField(placeholder: String = "", skeletonable: Bool? = nil) -> WPTextField {
        let textfield = WPTextField()
        textfield.placeholder = placeholder
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.skeletonable = skeletonable

        return textfield
    }

    static func createPhoneNumber(placeholder _: String = "", skeletonable: Bool? = nil) -> WPPhoneNumber {
        let phone = WPPhoneNumber(frame: .zero)
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.setSkeletonable(skeletonable)
        return phone
    }

    static func createSwitch() -> UISwitch {
        let view = UISwitch(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

// MARK: View groups

extension ViewFactory {
    static func createCountryTextField(placeholder: String) -> WPCountryTextField {
        let textfield = WPCountryTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = placeholder
        return textfield
    }

    static func createEmail(placeholder: String) -> WPTextField {
        let email = ViewFactory.createTextField(placeholder: placeholder)
        email.keyboardType = .emailAddress
        email.textContentType = .username
        email.autocorrectionType = .no
        email.autocapitalizationType = .none
        return email
    }

    struct PasswordViews {
        let textfield: WPTextField
        let eye: UIView
    }

    static func createPassword(passwordPlaceholder: String, bag: DisposeBag) -> PasswordViews {
        let password = ViewFactory.createTextField(placeholder: passwordPlaceholder)
        password.isSecureTextEntry = true
        password.textContentType = .password
        password.allowsErrorIcon = false

        let eye = ViewFactory.createImageButton(image: R.image.ic_eye_inactive(), width: 18, height: 13)

        eye.rx.tap.bind {
            password.isSecureTextEntry = !password.isSecureTextEntry
            let image = password.isSecureTextEntry ? R.image.ic_eye_inactive() : R.image.eye()
            eye.setImage(image, for: .normal)
        }.disposed(by: bag)
        return PasswordViews(textfield: password, eye: eye)
    }

    struct SocialView {
        let stack: UIView
        let facebook: UIButton
        let google: UIButton
        lazy var apple: ASAuthorizationAppleIDButton? = nil
    }

    static func createSocialLoginView(root: UIView, isLogin: Bool, bag: DisposeBag, onLogin: @escaping ((SocialNetwork) -> Void)) -> SocialView {
        let socialStack = ViewFactory.createHorizontalStack(spacing: 4)
        socialStack.alignment = .center
        socialStack.distribution = .fillEqually
        root.addSubview(socialStack)
        let leftDivider = ViewFactory.createDivider(orientation: .horizontal)
        leftDivider.setContentHuggingPriority(UILayoutPriority(250.0), for: .horizontal)
        let loginText = isLogin ? R.string.localizable.auth_sign_in_quick_sign_in() : R.string.localizable.auth_sign_up_quick_sign_up()
        let label = ViewFactory.createLabel(text: loginText)
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(1000.0), for: .horizontal)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        let rightDivider = ViewFactory.createDivider(orientation: .horizontal)
        rightDivider.setContentHuggingPriority(UILayoutPriority(250.0), for: .horizontal)
        socialStack.addArrangedSubview(leftDivider)
        socialStack.addArrangedSubview(label)
        socialStack.addArrangedSubview(rightDivider)
        label.pinToEdges(of: socialStack, orientation: .vertical)
        socialStack.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        var socialRootView: UIView = socialStack
        var authButton: UIControl?
        var authorizationButton: ASAuthorizationAppleIDButton!
        let style = ASAuthorizationAppleIDButton.Style.black
        if isLogin {
            authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: style)
        } else {
            authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: style)
        }
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        authorizationButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { _ in
                onLogin(.apple)
            }).disposed(by: bag)
        root.addSubview(authorizationButton)
        authorizationButton.center(withView: root, orientation: .horizontal)
        authorizationButton.alignBelow(view: socialStack, withPadding: 8)
        socialRootView = authorizationButton
        authButton = authorizationButton
        
        let facebook = ViewFactory.createImageButton(image: R.image.btn_facebook(), width: 33, circular: true)
        root.addSubview(facebook)
        facebook.center(withView: root, orientation: .horizontal, padding: -20)
        facebook.alignBelow(view: socialRootView, withPadding: 8)
        facebook.rx.tap.bind {
            onLogin(.facebook)
        }.disposed(by: bag)

        let google = ViewFactory.createImageButton(image: R.image.btn_google(), width: 33, circular: true)
        root.addSubview(google)
        google.center(withView: root, orientation: .horizontal, padding: 20)
        google.center(withView: facebook, orientation: .vertical)
        google.rx.tap.bind {
            onLogin(.google)
        }.disposed(by: bag)

        return SocialView(stack: socialStack,
                          facebook: facebook,
                          google: google,
                          apple: (authButton as! ASAuthorizationAppleIDButton))
    }

    static func createLargeButton(image: UIImage!) -> UIButton {
        let button = ViewFactory.createButton(image: image)
        button.imageEdgeInsets = UIEdgeInsets(top: UIConstants.margin, left: UIConstants.margin, bottom: UIConstants.margin, right: UIConstants.margin)
        button.setSize(image.size.width + UIConstants.margin * 2, image.size.height + UIConstants.margin * 2)
        return button
    }

    static func getBulletsView(title: String, bullets: [String]) -> (UILabel, UIView) {
        let bulletTitle = ViewFactory.createLabel(text: title)
        bulletTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)

        let verticalStack = ViewFactory.createVerticalStack(spacing: 4)
        for bulletText in bullets {
            let stack = ViewFactory.createHorizontalStack(spacing: 8)
            stack.alignment = .center
            let bullet = RoundedView()
            bullet.rounded = true
            bullet.setSize(8, 8)
            bullet.backgroundColor = .orange
            stack.addArrangedSubview(bullet)
            bullet.center(withView: stack, orientation: .vertical)

            let text = ViewFactory.createLabel(text: bulletText, font: .descriptionText)
            stack.addArrangedSubview(text)
            bullet.center(withView: text, orientation: .vertical)
            text.pinToEdges(of: stack, orientation: .vertical)

            verticalStack.addArrangedSubview(stack)
        }

        return (bulletTitle, verticalStack)
    }

    static func createWarningView(text: String) -> UIView {
        let view = createView()
        let label = createLabel(text: text, font: .smallText)
        let icon = createImage(image: R.image.ic_alert2(), width: 25, aspect: 25 / 26)
        view.addSubview(label)
        view.addSubview(icon)
        icon.center(withView: view, orientation: .vertical)
        icon.horizontalPin(to: view, orientation: .leading, padding: UIConstants.margin)
        label.center(withView: view, orientation: .vertical)
        label.alignAfter(view: icon, withPadding: 16)
        label.horizontalPin(to: view, orientation: .trailing, padding: UIConstants.margin)
        view.backgroundColor = R.color.lightAzure()
        view.setHeightAnchor(48)
        return view
    }

    static func createBlueTextButton(text: String, image: UIImage? = nil, font: UIFont) -> UIButton {
        let button = ViewFactory.createButton(text: text, image: image)
        button.titleLabel?.font = font
        button.setTitleColor(.shinyBlue, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }

    struct BannerView {
        let root: UIView
        let icon: UIImageView?
        let text: UILabel
    }

    static func createTextBanner(title: String, icon: UIImage? = nil, iconSize: CGFloat? = nil, bannerColor: UIColor = .lightBlue) -> BannerView {
        let banner = ViewFactory.createView()
        banner.backgroundColor = bannerColor

        let bannerStack = ViewFactory.createHorizontalStack(spacing: 16)
        bannerStack.alignment = .center
        bannerStack.distribution = .fill
        banner.addSubview(bannerStack)
        banner.pinToEdges(of: bannerStack, orientation: .vertical)
        bannerStack.pinToEdges(of: banner, orientation: .horizontal, padding: UIConstants.margin)

        let bannerTitle = ViewFactory.createLabel(text: title, font: .smallText)
        bannerTitle.numberOfLines = 0

        var image: UIImageView?
        if let icon = icon {
            let imageV = ViewFactory.createImage(image: icon)
            bannerStack.addArrangedSubview(imageV)
            if let size = iconSize {
                imageV.setWidthAnchor(size)
            }
            imageV.center(withView: bannerStack, orientation: .vertical)
            imageV.setAspect(1.0)
            image = imageV
        }

        bannerStack.addArrangedSubview(bannerTitle)
        bannerTitle.verticalPin(to: bannerStack, orientation: .top, padding: 16)
        bannerStack.verticalPin(to: bannerTitle, orientation: .bottom, padding: 16)
        bannerTitle.sizeToFit()
        return BannerView(root: banner, icon: image, text: bannerTitle)
    }

    struct MediaCountView {
        let root: UIView
        let text: UILabel
    }

    static func createMediaCountView() -> MediaCountView {
        let root = ViewFactory.createView()
        root.setHeightAnchor(22)
        root.backgroundColor = UIColor(hexString: "#181B1E", alpha: 0.5)
        root.layer.cornerRadius = 4
        root.clipsToBounds = true
        let text = ViewFactory.createLabel(text: "", alignment: .center, font: .descriptionLabel)
        root.addSubview(text)
        text.textColor = .white
        text.pinToEdges(of: root, orientation: .horizontal, padding: 8)
        text.pinToEdges(of: root, orientation: .vertical, padding: 4)
        return MediaCountView(root: root, text: text)
    }

    struct TextRowView {
        let root: UIView
        let leftText: UILabel
        let rightText: UILabel?
        let rightView: UIView?
    }

    static func createTextRowView(left: String,
                                  right: String? = nil,
                                  font: UIFont = .descriptionLabel,
                                  rightTextColor: UIColor? = nil,
                                  customRightView: UIView? = nil) -> TextRowView {
        let root = ViewFactory.createView()
        let leftView = ViewFactory.createLabel(text: left, font: font)
        root.addSubview(leftView)
        leftView.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        leftView.verticalPin(to: root, orientation: .top, padding: UIConstants.margin)
        leftView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .horizontal)

        let divider = ViewFactory.createDivider(orientation: .horizontal)
        root.addSubview(divider)
        divider.verticalPin(to: root, orientation: .bottom)
        divider.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        divider.horizontalPin(to: root, orientation: .trailing)

        guard let right = right else {
            let rightView = customRightView ?? ViewFactory.createView()
            root.addSubview(rightView)
            rightView.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)
            rightView.center(withView: root, orientation: .vertical)
            rightView.verticalPin(to: leftView, orientation: .top)
            rightView.heightAnchor.constraint(greaterThanOrEqualTo: leftView.heightAnchor, multiplier: 1).isActive = true
            root.verticalPin(to: rightView, orientation: .bottom, padding: UIConstants.margin)
            leftView.alignBefore(view: rightView, withPadding: -8)

            return TextRowView(root: root, leftText: leftView, rightText: nil, rightView: rightView)
        }

        let rightView = ViewFactory.createLabel(text: right, alignment: .right, font: font)
        rightView.numberOfLines = 0
        rightView.textColor = rightTextColor
        root.addSubview(rightView)
        rightView.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)
        rightView.center(withView: root, orientation: .vertical)
        rightView.verticalPin(to: leftView, orientation: .top)
        rightView.heightAnchor.constraint(greaterThanOrEqualTo: leftView.heightAnchor, multiplier: 1).isActive = true
        root.verticalPin(to: rightView, orientation: .bottom, padding: UIConstants.margin)
        leftView.alignBefore(view: rightView, withPadding: -8)

        return TextRowView(root: root, leftText: leftView, rightText: rightView, rightView: nil)
    }

    struct SwitchView {
        let root: UIView
        let left: UILabel
        let right: UISwitch
    }

    static func createSwitchTextview(text: String) -> SwitchView {
        let root = createView()
        let label = createLabel(text: text)
        root.addSubview(label)
        label.horizontalPin(to: root, orientation: .leading)
        let switchView = createSwitch()
        root.addSubview(switchView)
        switchView.horizontalPin(to: root, orientation: .trailing)
        switchView.center(withView: label, orientation: .vertical)
        label.alignBefore(view: switchView, withPadding: -8)
        label.verticalPin(to: root, orientation: .top)
        label.verticalPin(to: root, orientation: .bottom)
        return SwitchView(root: root, left: label, right: switchView)
    }

    struct CurrencySymbolView {
        let root: UIView
        let symbol: UILabel
    }

    static func createCurrencySymbolView(font: UIFont?) -> CurrencySymbolView {
        let root = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: UIConstants.textfieldHeight))
        let symbol = UILabel(frame: CGRect(x: 8, y: -2, width: 20, height: UIConstants.textfieldHeight))
        symbol.font = font
        root.addSubview(symbol)

        return CurrencySymbolView(root: root, symbol: symbol)
    }
}
