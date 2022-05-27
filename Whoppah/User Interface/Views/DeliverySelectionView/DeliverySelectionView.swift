//
//  DeliverySelectionView.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/10/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
import WhoppahDataStore

protocol DeliverySelectionViewDelegate: AnyObject {
    func deliverySelectionView(didSelectMethod: DeliverySelectionView.SelectedMethod)
}

class DeliverySelectionView: UIView {
    override var bounds: CGRect {
        didSet {
            let width = bounds.width - 32.0
            for button in subviews.compactMap({ $0 as? ImageTextRadioButton }) {
                button.bounds.size = CGSize(width: width, height: button.frame.height)
                button.frame.origin = CGPoint(x: bounds.width / 2 - button.bounds.width / 2, y: button.frame.minY)
            }
        }
    }

    enum SelectedMethod {
        case delivery(method: ShippingMethod)
        case pickup
    }

    var selectedMethod: SelectedMethod? {
        didSet {
            guard let method = selectedMethod else {
                buttons.forEach { $0.value.isSelected = false }
                return
            }
            var slug = ""
            switch method {
            case .pickup:
                slug = GraphQL.DeliveryMethod.pickup.rawValue
            case let .delivery(method):
                slug = method.slug
            }

            buttons.forEach {
                $0.value.isSelected = ($0.key == slug)
            }
        }
    }

    private typealias ShippingMethodSlug = String
    private var buttons = [ShippingMethodSlug: ImageTextRadioButton]()

    weak var delegate: DeliverySelectionViewDelegate?
    private let bag = DisposeBag()

    func clearButtons() {
        for button in subviews.compactMap({ $0 as? ImageTextRadioButton }) {
            button.removeFromSuperview()
        }
    }

    @discardableResult
    func addButton(forMethod method: ShippingMethod,
                   price: Price,
                   showPrice: Bool = true,
                   descriptionPrefix: String = "") -> ImageTextRadioButton {
        let button = ImageTextRadioButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        button.isSkeletonable = true
        button.pinToEdges(of: self, orientation: .horizontal)
        button.setHeightAnchor(72)
        if let last = subviews.last(where: { $0 as? ImageTextRadioButton != nil && $0 != button }) {
            button.alignBelow(view: last, withPadding: 8)
        } else {
            button.verticalPin(to: self, orientation: .top)
        }
        let price = price.formattedPrice(includeCurrency: true, showFraction: price.amount.hasRemainder())
        observedLocalizedString("shipping-\(method.slug)").compactMap { $0 }.subscribe(onNext: { text in
            button.name = showPrice ? "\(text) \(price)" : text
        }).disposed(by: bag)

        if showPrice {
            let prefix = descriptionPrefix.isEmpty ? "" : "\(descriptionPrefix)-"
            observedLocalizedString("\(prefix)shipping-\(method.slug)-description").compactMap { $0 }.subscribe(onNext: { text in
                button.size = text
            }).disposed(by: bag)
        } else {
            button.size = R.string.localizable.checkoutCourierDescription()
        }

        if let selected = selectedMethod {
            if case let .delivery(selectedMethod) = selected {
                button.isSelected = method.id == selectedMethod.id
            }
        }

        let image = UIImage(named: "\(method.slug)-icon") ?? R.image.unknownShippingIcon()
        button.image = image
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.selectedMethod = .delivery(method: method)
            self.delegate?.deliverySelectionView(didSelectMethod: self.selectedMethod!)
        }).disposed(by: bag)

        button.addGestureRecognizer(tap)

        button.otherButtons = [ImageTextRadioButton](buttons.values)
        buttons[method.slug] = button
        return button
    }

    @discardableResult
    func addPickupButton() -> ImageTextRadioButton {
        let button = ImageTextRadioButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        button.isSkeletonable = true
        button.pinToEdges(of: self, orientation: .horizontal)
        button.setHeightAnchor(72)
        if let last = subviews.last(where: { $0 as? ImageTextRadioButton != nil && $0 != button }) {
            button.alignBelow(view: last, withPadding: 8)
        } else {
            button.verticalPin(to: self, orientation: .top)
        }
        button.name = R.string.localizable.checkoutPickupTitle()
        button.size = R.string.localizable.checkoutPickupDescription()
        button.image = R.image.pickupIcon()
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.selectedMethod = .pickup
            self.delegate?.deliverySelectionView(didSelectMethod: self.selectedMethod!)

        }).disposed(by: bag)
        button.addGestureRecognizer(tap)
        button.otherButtons = [ImageTextRadioButton](buttons.values)
        buttons[GraphQL.DeliveryMethod.pickup.rawValue] = button
        return button
    }
}
