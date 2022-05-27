//
//  UIView.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/22/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

// MARK: Visual

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func makeCircular() {
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }
}

// MARK: Gestures

extension UIView {
    func removeGestures() {
        guard let recognizers = gestureRecognizers else { return }
        recognizers.forEach { removeGestureRecognizer($0) }
    }
}

// MARK: Visibility

extension UIView {
    var isVisible: Bool {
        get {
            !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
}

// MARK: Layout

extension UIView {
    var heightConstaint: NSLayoutConstraint? {
        get {
            constraints.filter {
                if $0.firstAttribute == .height, $0.relation == .equal {
                    return true
                }
                return false
            }.first
        }
        set { setNeedsLayout() }
    }

    var widthConstaint: NSLayoutConstraint? {
        get {
            constraints.filter {
                if $0.firstAttribute == .width, $0.relation == .equal {
                    return true
                }
                return false
            }.first
        }
        set { setNeedsLayout() }
    }

    enum Alignment {
        case below
        case above
    }

    @discardableResult
    func alignVertically(with other: UIView, alignment: Alignment, padding: CGFloat = 0.0, safeArea: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        let guide = safeArea ? other.safeAreaLayoutGuide : other.layoutMarginsGuide
        switch alignment {
        case .below:
            constraint = topAnchor.constraint(equalTo: guide.bottomAnchor,
                                              constant: padding)
        case .above:
            constraint = bottomAnchor.constraint(equalTo: guide.topAnchor,
                                                 constant: padding)
        }
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func alignAbove(view: UIView, withPadding padding: CGFloat = 0.0) -> NSLayoutConstraint {
        alignVertically(with: view, alignment: .above, padding: padding)
    }

    @discardableResult
    func alignBelow(view: UIView, withPadding padding: CGFloat = 0.0) -> NSLayoutConstraint {
        alignVertically(with: view, alignment: .below, padding: padding)
    }

    enum VerticalPinOrientation {
        case top
        case bottom
    }

    @discardableResult
    func verticalPin(to other: UIView, orientation: VerticalPinOrientation, padding: CGFloat = 0.0, safeArea: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        switch orientation {
        case .top:
            constraint = topAnchor.constraint(equalTo: safeArea ? other.safeAreaLayoutGuide.topAnchor : other.topAnchor,
                                              constant: padding)
        case .bottom:
            constraint = bottomAnchor.constraint(equalTo: safeArea ? other.safeAreaLayoutGuide.bottomAnchor : other.bottomAnchor,
                                                 constant: padding)
        }
        constraint.isActive = true
        return constraint
    }

    enum HAlignment {
        case before
        case after
    }

    @discardableResult
    func alignHorizontally(with other: UIView, alignment: HAlignment, padding: CGFloat = 0.0, safeArea: Bool = false) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        switch alignment {
        case .before:
            constraint = trailingAnchor.constraint(equalTo: safeArea ? other.safeAreaLayoutGuide.leadingAnchor : other.leadingAnchor,
                                                   constant: padding)
        case .after:
            constraint = leadingAnchor.constraint(equalTo: safeArea ? other.safeAreaLayoutGuide.trailingAnchor : other.trailingAnchor,
                                                  constant: padding)
        }
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func alignBefore(view: UIView, withPadding padding: CGFloat = 0.0, safeArea: Bool = true) -> NSLayoutConstraint {
        alignHorizontally(with: view, alignment: .before, padding: padding, safeArea: safeArea)
    }

    @discardableResult
    func alignAfter(view: UIView, withPadding padding: CGFloat = 0.0, safeArea: Bool = true) -> NSLayoutConstraint {
        alignHorizontally(with: view, alignment: .after, padding: padding, safeArea: safeArea)
    }

    enum HorizontalPinOrientation {
        case leading
        case trailing
    }

    @discardableResult
    func horizontalPin(to other: UIView, orientation: HorizontalPinOrientation, padding: CGFloat = 0.0, safeArea: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        switch orientation {
        case .leading:
            constraint = leadingAnchor.constraint(equalTo: safeArea ? other.safeAreaLayoutGuide.leadingAnchor : other.leadingAnchor,
                                                  constant: padding)

        case .trailing:
            constraint = trailingAnchor.constraint(equalTo: safeArea ? other.safeAreaLayoutGuide.trailingAnchor : other.trailingAnchor,
                                                   constant: padding)
        }

        constraint.isActive = true
        return constraint
    }

    enum PinOrientation {
        case horizontal
        case vertical
    }

    func pinToEdges(of other: UIView, orientation: PinOrientation, padding: CGFloat = 0.0, safeArea: Bool = true) {
        switch orientation {
        case .horizontal:
            horizontalPin(to: other, orientation: .leading, padding: padding, safeArea: safeArea)
            horizontalPin(to: other, orientation: .trailing, padding: -padding, safeArea: safeArea)
        case .vertical:
            verticalPin(to: other, orientation: .top, padding: padding, safeArea: safeArea)
            verticalPin(to: other, orientation: .bottom, padding: -padding, safeArea: safeArea)
        }
    }

    func pinToAllEdges(of other: UIView, padding: CGFloat = 0.0, safeArea: Bool = true) {
        pinToEdges(of: other, orientation: .horizontal, padding: padding, safeArea: safeArea)
        pinToEdges(of: other, orientation: .vertical, padding: padding, safeArea: safeArea)
    }

    func center(withView other: UIView, orientation: PinOrientation, padding: CGFloat = 0.0, safeArea _: Bool = true) {
        switch orientation {
        case .horizontal:
            centerXAnchor.constraint(equalTo: other.centerXAnchor,
                                     constant: padding).isActive = true
        case .vertical:
            centerYAnchor.constraint(equalTo: other.centerYAnchor,
                                     constant: padding).isActive = true
        }
    }

    func setAtLeastEqualsSize(toView other: UIView, orientation: PinOrientation, value: CGFloat = 0.0) {
        switch orientation {
        case .horizontal:
            widthAnchor.constraint(greaterThanOrEqualTo: other.widthAnchor, multiplier: 1, constant: value).isActive = true
        case .vertical:
            heightAnchor.constraint(greaterThanOrEqualTo: other.heightAnchor, multiplier: 1, constant: value).isActive = true
        }
    }

    func setEqualsSize(toView other: UIView, orientation: PinOrientation, padding: CGFloat = 0.0, safeArea: Bool = true) {
        switch orientation {
        case .horizontal:
            widthAnchor.constraint(equalTo: safeArea ? other.safeAreaLayoutGuide.widthAnchor : other.widthAnchor,
                                   constant: padding).isActive = true
        case .vertical:
            heightAnchor.constraint(equalTo: safeArea ? other.safeAreaLayoutGuide.heightAnchor : other.heightAnchor,
                                    constant: padding).isActive = true
        }
    }

    func setAspect(_ value: CGFloat) {
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: value, constant: 0))
    }

    @discardableResult
    func setWidthAnchor(_ value: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: value)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func setHeightAnchor(_ value: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: value)
        constraint.isActive = true
        return constraint
    }

    func setMinHeightAnchor(_ value: CGFloat) {
        heightAnchor.constraint(greaterThanOrEqualToConstant: value).isActive = true
    }

    func setMinWidthAnchor(_ value: CGFloat) {
        widthAnchor.constraint(greaterThanOrEqualToConstant: value).isActive = true
    }

    func setSize(_ width: CGFloat, _ height: CGFloat) {
        setWidthAnchor(width)
        setHeightAnchor(height)
    }
}

// MARK: - Reactive

extension Reactive where Base: UIView {
    /// Bindable sink for `hidden` property.
    public var isVisible: Binder<Bool> {
        Binder(base) { view, visible in
            view.isVisible = visible
        }
    }
}
