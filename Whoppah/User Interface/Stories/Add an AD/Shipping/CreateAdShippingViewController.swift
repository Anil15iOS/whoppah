//
//  CreateAdShippingViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 22/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxAnimated
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahDataStore

class CreateAdShippingViewController: CreateAdViewControllerBase {
    var viewModel: CreateAdShippingViewModel!
    private var addressVC: AddressSelectionViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.createAdCommonYourAdTitle(), transparent: false)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.createAdShippingTitle())
        root.addSubview(title)
        title.textColor = .black
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let addressTitle = ViewFactory.createTitle(R.string.localizable.createAdShippingAddressTitle(), font: .h2)
        root.addSubview(addressTitle)
        addressTitle.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        addressTitle.alignBelow(view: title, withPadding: UIConstants.titleBottomMargin)

        let addressDivider = ViewFactory.createDivider(orientation: .horizontal, backgroundColor: UIConstants.titleDividerColor)
        root.addSubview(addressDivider)
        addressDivider.pinToEdges(of: root, orientation: .horizontal)
        addressDivider.alignBelow(view: addressTitle, withPadding: 8)

        let addressSelectionView = ViewFactory.createView()
        root.addSubview(addressSelectionView)
        addressSelectionView.pinToEdges(of: root, orientation: .horizontal)
        addressSelectionView.alignBelow(view: addressDivider, withPadding: 8)

        setUpAddresses(root: addressSelectionView)

        let noAddressLabel = ViewFactory.createLabel(text: R.string.localizable.createAdShippingMissingAddressLabel(), font: .descriptionText)
        root.addSubview(noAddressLabel)
        noAddressLabel.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        noAddressLabel.alignBelow(view: addressDivider, withPadding: 24)

        let addButtonNoAddress = ViewFactory.createSecondaryButton(text: R.string.localizable.my_addresses_address_list_add(),
                                                                   icon: R.image.ic_plus_blue(),
                                                                   buttonColor: R.color.shinyBlue())
        root.addSubview(addButtonNoAddress)
        addButtonNoAddress.setHeightAnchor(UIConstants.buttonHeight)
        addButtonNoAddress.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        addButtonNoAddress.rx.tap.bind { [weak self] in
            self?.addressVC.addAddressAction(addButtonNoAddress)
        }.disposed(by: bag)
        addButtonNoAddress.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        addButtonNoAddress.alignBelow(view: noAddressLabel, withPadding: 24)

        let addButton = ViewFactory.createButton(text: R.string.localizable.my_addresses_address_list_add(),
                                                 image: R.image.ic_plus_blue())
        root.addSubview(addButton)
        addButton.setTitleColor(.shinyBlue, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.descriptionSize, weight: .semibold)
        addButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        addButton.setHeightAnchor(15)
        addButton.rx.tap.bind { [weak self] in
            self?.addressVC.addAddressAction(addButton)
        }.disposed(by: bag)
        addButton.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        addButton.alignBelow(view: addressSelectionView, withPadding: 16)

        viewModel.outputs.hasAddress.bind(to: addButton.rx.isVisible).disposed(by: bag)
        viewModel.outputs.hasAddress.map { !$0 }.bind(to: addButtonNoAddress.rx.isVisible).disposed(by: bag)
        viewModel.outputs.hasAddress.map { !$0 }.bind(to: noAddressLabel.rx.isVisible).disposed(by: bag)

        let shippingMethodTitle = ViewFactory.createTitle(R.string.localizable.create_ad_select_delivery_method_title())
        root.addSubview(shippingMethodTitle)
        shippingMethodTitle.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)

        var shippingTitleConstraint = shippingMethodTitle.alignBelow(view: addButtonNoAddress, withPadding: 32)
        viewModel.outputs.hasAddress.subscribe(onNext: { addressPresent in
            shippingMethodTitle.removeConstraint(shippingTitleConstraint)
            if addressPresent {
                shippingTitleConstraint = shippingMethodTitle.alignBelow(view: addButton, withPadding: 32)
            } else {
                shippingTitleConstraint = shippingMethodTitle.alignBelow(view: addButtonNoAddress, withPadding: 32)
            }
        }).disposed(by: bag)

        let verticalStack = getDeliveryMethodStackview()
        root.addSubview(verticalStack)
        verticalStack.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        verticalStack.alignBelow(view: shippingMethodTitle, withPadding: 16)

        let banner = getShippingCostBanner()
        root.addSubview(banner)
        banner.pinToEdges(of: root, orientation: .horizontal)
        banner.alignBelow(view: verticalStack, withPadding: 16)

        let deliverySelectionView = getShippingOptionsView()
        let shippingStack = ViewFactory.createVerticalStack()
        shippingStack.alignment = .center
        root.addSubview(shippingStack)
        shippingStack.pinToEdges(of: root, orientation: .horizontal)
        shippingStack.alignBelow(view: banner, withPadding: 32)
        shippingStack.addArrangedSubview(deliverySelectionView.root)
        deliverySelectionView.root.pinToEdges(of: shippingStack, orientation: .horizontal)
        deliverySelectionView.root.clipsToBounds = true
        deliverySelectionView.root.verticalPin(to: deliverySelectionView.customView.root, orientation: .bottom)

        viewModel.outputs.deliveryMethod.compactMap { $0 }.map { method -> Bool in
            if case .pickup = method {
                return false
            }
            return true
        }.bind(to: deliverySelectionView.root.rx.isVisible).disposed(by: bag)

        let buttonText = nextButtonText(viewModel, R.string.localizable.createAdShippingButtonTitle())
        let nextButton = ViewFactory.createPrimaryButton(text: buttonText)

        root.addSubview(nextButton)
        nextButton.alignBelow(view: shippingStack, withPadding: 16)
        setUpViewModel(shippingView: deliverySelectionView)

        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        viewModel.outputs.nextEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: bag)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.next()
        }.disposed(by: bag)
        viewModel.outputs.nextEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: bag)

        root.verticalPin(to: nextButton, orientation: .bottom, padding: UIConstants.margin)

        addCloseButtonIfRequired(viewModel)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard parent == nil else { return }
        viewModel.onDismiss()
    }

    private struct ShippingRadioView {
        let root: UIView
        let radio: RadioButton
        let text: UILabel
    }

    private func createShippingRadio(text: String, method: GraphQL.DeliveryMethod) -> ShippingRadioView {
        let stack = ViewFactory.createHorizontalStack(spacing: 8)
        stack.alignment = .center
        stack.distribution = .fill
        let radio = ViewFactory.createRadioButton(width: 24)
        stack.addArrangedSubview(radio)
        radio.selectedSubject
            .filter { $0 } // if selected
            .map { _ in method } // actually are selecting a delivery method
            .bind(to: viewModel.inputs.deliveryMethod) // pass along
            .disposed(by: bag)
        let text = ViewFactory.createLabel(text: text, font: .label)
        text.numberOfLines = 0
        stack.addArrangedSubview(text)
        radio.associatedTapView = stack

        return ShippingRadioView(root: stack, radio: radio, text: text)
    }

    private func getShippingCostBanner() -> UIView {
        ViewFactory.createTextBanner(title: R.string.localizable.create_ad_select_delivery_warning(),
                                     bannerColor: R.color.lightAzure()!).root
    }

    private struct ShippingView {
        let root: UIView
        let selectionView: DeliverySelectionView
        let customView: CustomShippingView
    }

    private func getShippingOptionsView() -> ShippingView {
        let root = ViewFactory.createView()
        let title = ViewFactory.createTitle(R.string.localizable.createAdShippingShippingMethodTitle())
        root.addSubview(title)
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top)

        let description = ViewFactory.createLabel(text: R.string.localizable.createAdShippingShippingDescription(),
                                                  font: UIConstants.descriptionFont)
        description.numberOfLines = 0
        root.addSubview(description)
        description.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        description.alignBelow(view: title, withPadding: 8)

        let selectionView = DeliverySelectionView(frame: .zero)
        selectionView.delegate = viewModel
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(selectionView)
        selectionView.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        selectionView.alignBelow(view: description, withPadding: 16)

        let customView = getCustomShippingView()
        root.addSubview(customView.root)
        customView.root.pinToEdges(of: root, orientation: .horizontal)
        customView.root.alignBelow(view: selectionView, withPadding: 24)

        return ShippingView(root: root, selectionView: selectionView, customView: customView)
    }

    private struct CustomShippingView {
        let root: UIView
        let switchView: ViewFactory.SwitchView
        let switchDivider: UIView
        let textfield: WPTextField
    }

    private func getCustomShippingView() -> CustomShippingView {
        let root = ViewFactory.createView()
        root.clipsToBounds = true

        let title = ViewFactory.createTitle(R.string.localizable.createAdShippingCustomTitle())
        root.addSubview(title)
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top)

        let description = ViewFactory.createLabel(text: R.string.localizable.createAdShippingCustomDescription())
        root.addSubview(description)
        description.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        description.alignBelow(view: title, withPadding: 4)

        let separator = ViewFactory.createDivider(orientation: .horizontal, backgroundColor: UIConstants.titleDividerColor)
        root.addSubview(separator)
        separator.pinToEdges(of: root, orientation: .horizontal)
        separator.alignBelow(view: description, withPadding: 4)

        let switchView = ViewFactory.createSwitchTextview(text: R.string.localizable.createAdShippingCustomSwitchLabel())
        root.addSubview(switchView.root)
        switchView.root.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        switchView.root.alignBelow(view: separator, withPadding: 16)

        let switchDivider = ViewFactory.createDivider(orientation: .horizontal)
        root.addSubview(switchDivider)
        switchDivider.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        switchDivider.horizontalPin(to: root, orientation: .trailing)
        switchDivider.alignBelow(view: switchView.root, withPadding: 16)

        let textfield = ViewFactory.createTextField(placeholder: R.string.localizable.createAdShippingCustomPlaceholder())
        root.addSubview(textfield)
        textfield.contentHeight = UIConstants.textfieldHeight
        textfield.keyboardType = .numberPad
        textfield.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        textfield.alignBelow(view: switchDivider, withPadding: 16)
        let currencyView = ViewFactory.createCurrencySymbolView(font: textfield.font)
        textfield.setCurrencyLeftView(currencyView.root)
        viewModel.outputs.currencySymbol.bind(to: currencyView.symbol.rx.text).disposed(by: bag)

        return CustomShippingView(root: root, switchView: switchView, switchDivider: switchDivider, textfield: textfield)
    }

    private func setUpAddresses(root: UIView) {
        let vc: AddressSelectionViewController = UIStoryboard(storyboard: .addAnAD).instantiateViewController()
        vc.viewModel = viewModel.addressVM
        addChild(vc)
        root.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.pinToEdges(of: root, orientation: .horizontal)
        vc.view.verticalPin(to: root, orientation: .top)
        vc.addressesTableView.isScrollEnabled = false
        root.verticalPin(to: vc.view, orientation: .bottom)
        root.layoutSubviews()
        addressVC = vc
    }

    private func setUpViewModel(shippingView: ShippingView) {
        let deliverySelectionView = shippingView.selectionView

        viewModel.outputs.shipping.subscribe(onNext: { method in
            guard let method = method else {
                deliverySelectionView.selectedMethod = nil
                return
            }
            switch method {
            case .custom:
                deliverySelectionView.selectedMethod = nil
            case let .existing(method):
                deliverySelectionView.selectedMethod = .delivery(method: method)
            }
        }).disposed(by: bag)

        let customView = shippingView.customView
        let isCustom = viewModel.outputs.shipping.compactMap { $0 }.map { method -> Bool in
            if case .custom = method { return true }
            return false
        }
        let hasShipping = viewModel.outputs.shipping.map { $0 != nil }

        isCustom.bind(to: customView.switchView.right.rx.isOn).disposed(by: bag)

        // If shipping is nil or if not custom then we enable the delivery items
        let enableDeliverySection = Observable.combineLatest(hasShipping, isCustom).map { !$0.0 || !$0.1 }
        enableDeliverySection.map { $0 ? 1.0 : 0.4 }.bind(animated: deliverySelectionView.rx.alpha).disposed(by: bag)
        enableDeliverySection.bind(to: deliverySelectionView.rx.isUserInteractionEnabled).disposed(by: bag)

        let customHeight = customView.root.verticalPin(to: customView.switchDivider, orientation: .bottom, padding: 100)
        customView.switchView.right.rx.isOn.map { $0 ? 100 : 0 }.bind(animated: customHeight.rx.animated.layout(duration: 0.33).constant).disposed(by: bag)

        let customPriceInput = customView.textfield.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]).asObservable().map { customView.textfield.text ?? "" }
        let customPrice = Observable.combineLatest(customView.switchView.right.rx.isOn, customPriceInput)
            .filter { $0.0 }
            .map { $0.1 }
        customPrice.subscribe(onNext: { [weak self] price in
            self?.viewModel.didSelectCustom(price: price)
        }).disposed(by: bag)

        // If the user disables the button ensure that the shipping method is cleared
        customView.switchView.right.rx.isOn.skip(1).filter { !$0 }.subscribe(onNext: { [weak self] _ in
            self?.viewModel.didSelectCustom(price: nil)
        }).disposed(by: bag)

        let inputPrice = viewModel.outputs.shipping.compactMap { $0 }.compactMap { method -> PriceInput? in
            if case let .custom(price) = method { return price }
            return nil
        }
        inputPrice
            .map { $0.amount.formatAsSimpleDecimal() }
            .bind(to: customView.textfield.rx.text).disposed(by: bag)

        var customHeightConstraint: NSLayoutConstraint?
        viewModel.outputs.shippingMethods.subscribe(onNext: { methods in
            deliverySelectionView.clearButtons()
            var hasCustom = false
            for method in methods {
                if method.slug != customShippingSlug {
                    deliverySelectionView.addButton(forMethod: method, price: method.pricing)
                } else {
                    hasCustom = true
                }
            }

            // Hide / show the custom view if the option there or not
            if !hasCustom {
                if customHeightConstraint == nil {
                    customHeightConstraint = customView.root.setHeightAnchor(0)
                }
            } else {
                if let constraint = customHeightConstraint {
                    customView.root.removeConstraint(constraint)
                    customHeightConstraint = nil
                }
            }
            if let last = deliverySelectionView.subviews.last {
                deliverySelectionView.verticalPin(to: last, orientation: .bottom)
            }
        }).disposed(by: bag)
    }

    private func getDeliveryMethodStackview() -> UIView {
        let verticalStack = ViewFactory.createVerticalStack(spacing: 24)

        let pickup = createShippingRadio(text: R.string.localizable.create_ad_select_delivery_method_pickup(), method: .pickup)
        verticalStack.addArrangedSubview(pickup.root)
        pickup.root.pinToEdges(of: verticalStack, orientation: .horizontal)
        let delivery = createShippingRadio(text: R.string.localizable.create_ad_select_delivery_method_delivery(), method: .delivery)
        verticalStack.addArrangedSubview(delivery.root)
        delivery.root.pinToEdges(of: verticalStack, orientation: .horizontal)
        let deliveryOrPickup = createShippingRadio(text: R.string.localizable.create_ad_select_delivery_method_both(), method: .pickupDelivery)
        verticalStack.addArrangedSubview(deliveryOrPickup.root)
        deliveryOrPickup.root.pinToEdges(of: verticalStack, orientation: .horizontal)
        let allButtons = [pickup.radio, delivery.radio, deliveryOrPickup.radio]
        pickup.radio.groupButtons = allButtons
        delivery.radio.groupButtons = allButtons
        deliveryOrPickup.radio.groupButtons = allButtons

        viewModel.outputs.deliveryMethod.compactMap { $0 }.subscribe(onNext: { method in
            switch method {
            case .delivery:
                delivery.radio.isSelected = true
            case .pickup:
                pickup.radio.isSelected = true
            case .pickupDelivery:
                deliveryOrPickup.radio.isSelected = true
            default: break
            }
        }).disposed(by: bag)
        return verticalStack
    }
}
