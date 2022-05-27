//
//  PaymentContactShippingViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 11/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import SwiftUI
import WhoppahUI

struct PaymentViewFactory {
    // MARK: Ad title view

    struct AdTitleView {
        let root: UIView
        let image: UIImageView
        let title: UILabel
    }

    static func getAdTitleView() -> AdTitleView {
        let root = ViewFactory.createView(skeletonable: true)
        let image = ViewFactory.createImage(image: nil, width: 88, aspect: 1.0, skeletonable: true)
        root.addSubview(image)
        image.layer.cornerRadius = 4
        image.verticalPin(to: root, orientation: .top)
        image.horizontalPin(to: root, orientation: .leading)
        image.clipsToBounds = true

        let title = ViewFactory.createTitle("", skeletonable: true)
        title.numberOfLines = 3
        title.lineBreakMode = .byTruncatingTail
        
        root.addSubview(title)
        title.center(withView: image, orientation: .vertical)
        title.alignAfter(view: image, withPadding: 16)
        title.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)

        root.verticalPin(to: image, orientation: .bottom)
        return AdTitleView(root: root, image: image, title: title)
    }
}

class PaymentContactShippingViewController: UIViewController {
    private var popupContent: ModalPopupContent = .initial

    var viewModel: PaymentViewModel!
    private let bag = DisposeBag()
    private var selectedIndexPath: IndexPath?
    private var validators = [ValidatorComponent]()
    private var phoneDescription: UILabel!
    private var phoneView: WPPhoneNumber!
    
    private var isIPad: Bool {
        UIScreen.main.traitCollection.userInterfaceIdiom == .pad
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        typealias l = R.string.localizable
        
        popupContent = .init(
            title: l.pdpPopupBiddingTitle(),
            contentItems: [
                ModalPopupContent.ParagraphItem(title: l.pdpPopupBiddingSubtitle1(),
                      content: l.pdpPopupBiddingDescription1()),
                ModalPopupContent.ParagraphItem(title: l.pdpPopupBiddingSubtitle2(),
                      content: l.pdpPopupBiddingDescription2()),
                ModalPopupContent.ParagraphItem(title: l.pdpPopupBiddingSubtitle3(),
                      content: l.pdpPopupBiddingDescription3()),
                ModalPopupContent.ParagraphItem(title: l.pdpPopupBiddingSubtitle4(),
                      content: l.pdpPopupBiddingDescription4())
            ],
            goBackButtonTitle: l.commonClose())

        setNavBar(title: R.string.localizable.checkoutTitle(), enabled: true)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root
        root.isSkeletonable = true

        // Title + image
        let adTitleSection = PaymentViewFactory.getAdTitleView()
        root.addSubview(adTitleSection.root)
        adTitleSection.root.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        adTitleSection.root.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)
        setupAdData(adTitleSection)

        // Personal info
        let personalInfoSection = getPersonalInfoView()
        root.addSubview(personalInfoSection.root)
        personalInfoSection.root.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        personalInfoSection.root.alignBelow(view: adTitleSection.root, withPadding: 16)
        setupPersonalInfoData(personalInfoSection, scrollview: scrollView.scroll)

        // Shipping
        let shippingSection = getShippingMethodView()
        root.addSubview(shippingSection.root)
        shippingSection.root.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        shippingSection.root.alignBelow(view: personalInfoSection.root, withPadding: 24)

        let addressSection = getAddressView()
        root.addSubview(addressSection.container)
        addressSection.root.pinToEdges(of: root, orientation: .horizontal)
        let addressTopConstraint = addressSection.root.alignBelow(view: shippingSection.root, withPadding: 24)
        
        let buyerProtectionModel = CheckoutBuyerProtection.Model(
            title: R.string.localizable.buyerProtectionTitle(),
            description: R.string.localizable.checkoutBuyerProtectionText(),
            listItems: [
                R.string.localizable.buyerProtectionUsp2(),
                R.string.localizable.buyerProtectionUsp3(),
                R.string.localizable.buyerProtectionUsp4(),
                R.string.localizable.buyerProtectionUsp5()
            ],
            switchEnabledTitle: R.string.localizable.checkoutBuyerProtectionActivated(),
            switchDisabledTitle: R.string.localizable.checkoutBuyerProtectionNotActivated())
        
        let buyerProtection = UIHostingController(
            rootView: CheckoutBuyerProtection(
                model: buyerProtectionModel,
                didTapMoreInfo: { [weak self] in
                    self?.showBuyerProtectionModal()
                },
                didChangeSelection: { [weak self] buyerProtectionSelected in
                    self?.viewModel.enableBuyerProtection = buyerProtectionSelected
                    self?.viewModel.updateTotals()
                }))
        buyerProtection.view.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(buyerProtection.view)
        
        if isIPad {
            buyerProtection.view.setWidthAnchor(440)
            buyerProtection.view.center(withView: root, orientation: .horizontal)
        } else {
            buyerProtection.view.pinToEdges(of: root, orientation: .horizontal)
        }
        let _ = buyerProtection.view.alignBelow(view: addressSection.root, withPadding: 24)
        
        let nextButton = ViewFactory.createPrimaryButton(text: R.string.localizable.checkoutNextButtonTitle(), skeletonable: true)
        root.addSubview(nextButton)
        let addressNextButtonConstraint = nextButton.alignBelow(view: buyerProtection.view, withPadding: 32)
        let shippingNextButtonConstraint = nextButton.alignBelow(view: buyerProtection.view, withPadding: 32)

        shippingNextButtonConstraint.isActive = false
        setupShippingData(shippingSection,
                          addressView: addressSection,
                          addressTopConstraint: addressTopConstraint,
                          addressNextButtonConstraint: addressNextButtonConstraint,
                          shippingNextButtonConstraint: shippingNextButtonConstraint)

        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.next()
        }.disposed(by: bag)
        viewModel.outputs.nextButtonEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: bag)
        viewModel.outputs.isLoading.bind(to: nextButton.rx.isAnimating).disposed(by: bag)

        viewModel.outputs.fetchingData.subscribe(onNext: { [weak self] loading in
            shippingSection.deliverySelection.isHidden = loading
            if loading {
                root.showAnimatedGradientSkeleton()
            } else {
                root.hideSkeleton()
                _ = self?.validateData()
            }
        }).disposed(by: bag)

        root.verticalPin(to: nextButton, orientation: .bottom, padding: UIConstants.margin)

        addCustomCloseButton().rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.onBackPressed()
        }.disposed(by: bag)
    }
    
    private func showBuyerProtectionModal() {
        let view = ModalPopUpView(content: .constant(popupContent),
                                  showPopup: .constant(true)) {
            self.dismiss(animated: true)
        }

        let buyerProtectionModal = UIHostingController(
         rootView: view)
        buyerProtectionModal.view.translatesAutoresizingMaskIntoConstraints = false
        buyerProtectionModal.view.isOpaque = false
        buyerProtectionModal.view.backgroundColor = .clear
        buyerProtectionModal.view.superview?.isOpaque = false
        buyerProtectionModal.view.superview?.backgroundColor = .clear
        buyerProtectionModal.view.superview?.superview?.isOpaque = false
        buyerProtectionModal.view.superview?.superview?.backgroundColor = .clear
        buyerProtectionModal.modalPresentationStyle = .overFullScreen
        buyerProtectionModal.modalTransitionStyle = .crossDissolve
        self.present(buyerProtectionModal, animated: true, completion: nil)
    }

    // MARK: Ad title

    private func setupAdData(_ section: PaymentViewFactory.AdTitleView) {
        viewModel.outputs.adImage.subscribe(onNext: { result in
            section.image.setImage(forUrl: result)
        }).disposed(by: bag)

        viewModel.outputs.title.bind(to: section.title.rx.text).disposed(by: bag)
    }

    // MARK: Personal info view

    private struct PersonalInfoView {
        let root: UIView
        let title: UILabel
        let nameStack: UIStackView
        let firstname: WPTextField
        let lastname: WPTextField
        let phone: WPPhoneNumber
    }

    private func getPersonalInfoView() -> PersonalInfoView {
        let root = ViewFactory.createView(skeletonable: true)
        let title = ViewFactory.createTitle(R.string.localizable.checkoutMemberDetailsTitle(), skeletonable: true)
        root.addSubview(title)
        title.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        title.verticalPin(to: root, orientation: .top)
        title.pinToEdges(of: root, orientation: .horizontal)

        let nameStack = ViewFactory.createVerticalStack(spacing: 16, skeletonable: true)
        root.addSubview(nameStack)
        nameStack.pinToEdges(of: root, orientation: .horizontal)
        nameStack.alignBelow(view: title, withPadding: UIConstants.titleBottomMargin)
        nameStack.distribution = .equalSpacing
        nameStack.alignment = .leading

        let firstname = ViewFactory.createTextField(placeholder: R.string.localizable.checkout_first_name_text_placeholder(), skeletonable: true)
        firstname.keyboardType = .namePhonePad
        firstname.textContentType = .givenName
        nameStack.addArrangedSubview(firstname)
        firstname.pinToEdges(of: nameStack, orientation: .horizontal)
        firstname.contentHeight = UIConstants.textfieldHeight
        
        validators.append(TextValidationComponent(firstname,
                                                  errorMessage: R.string.localizable.commonMissingFirstName(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        let lastname = ViewFactory.createTextField(placeholder: R.string.localizable.checkout_last_name_text_placeholder(), skeletonable: true)
        nameStack.addArrangedSubview(lastname)
        lastname.keyboardType = .namePhonePad
        lastname.textContentType = .familyName
        lastname.pinToEdges(of: nameStack, orientation: .horizontal)
        lastname.contentHeight = UIConstants.textfieldHeight
        
        validators.append(TextValidationComponent(lastname,
                                                  errorMessage: R.string.localizable.commonMissingLastName(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        let phoneStack = ViewFactory.createVerticalStack(spacing: 4, skeletonable: true)
        nameStack.addArrangedSubview(phoneStack)

        phoneStack.pinToEdges(of: root, orientation: .horizontal)

        let phone = ViewFactory.createPhoneNumber(placeholder: R.string.localizable.commonPhoneNumberPlaceholder(), skeletonable: true)
        phoneStack.addArrangedSubview(phone)
        phone.pinToEdges(of: root, orientation: .horizontal)
        phone.textfield.sendActions(for: .editingChanged)
        phone.setHeightAnchor(UIConstants.textfieldHeight)
        validators.append(PhoneValidationComponent(phone, errorMessage: R.string.localizable.commonMissingPhoneNumber(), validator: { phone -> Bool in
            phone.textfield.isValid.value
        }))
        self.phoneView = phone

        let phoneDescription = ViewFactory.createLabel(text: R.string.localizable.checkoutPhoneNumberDescription(),
                                                       lines: 0,
                                                       font: .smallText,
                                                       skeletonable: true)
        phoneStack.addArrangedSubview(phoneDescription)

        phoneDescription.pinToEdges(of: root, orientation: .horizontal)
        phoneDescription.alignBelow(view: phone, withPadding: 4)
        self.phoneDescription = phoneDescription
        
        root.verticalPin(to: phoneStack, orientation: .bottom)

        return PersonalInfoView(root: root, title: title, nameStack: nameStack, firstname: firstname, lastname: lastname, phone: phone)
    }

    private func setupPersonalInfoData(_ section: PersonalInfoView, scrollview: UIScrollView) {
        viewModel.outputs.givenNameButton.bind(to: section.firstname.rx.messageType).disposed(by: bag)
        viewModel.outputs.givenNameButton
            .filter { $0.error != nil }
            .map { _ in () }
            .subscribe(onNext: {
                scrollview.setContentOffset(CGPoint(x: 0.0, y: section.root.frame.origin.y), animated: true)
            }).disposed(by: bag)
        section.firstname.rx.text.orEmpty.bind(to: viewModel.inputs.givenName).disposed(by: bag)

        viewModel.outputs.lastNameButton.bind(to: section.lastname.rx.messageType).disposed(by: bag)
        viewModel.outputs.lastNameButton
            .filter { $0.error != nil }
            .map { _ in () }
            .subscribe(onNext: {
                scrollview.setContentOffset(CGPoint(x: 0.0, y: section.root.frame.origin.y), animated: true)
            }).disposed(by: bag)
        section.lastname.rx.text.orEmpty.bind(to: viewModel.inputs.familyName).disposed(by: bag)

        let phone = section.phone

        // Any change resets the color back to default
        phone.textfield.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .asObservable()
            .map { _ in phone.textfield.getNumber(format: .E164) }
            .bind(to: viewModel.inputs.phoneNumber)
            .disposed(by: bag)
        
        [phone.textfield,
         section.firstname,
         section.lastname].forEach { inputField in
            inputField
                .rx
                .controlEvent([.editingDidEnd, .editingDidEndOnExit])
                .subscribe { _ in _ = self.validateData() }
                .disposed(by: bag)
        }

        viewModel.outputs.phoneNumber
            .filter { $0.error != nil }
            .map { _ in () }
            .subscribe(onNext: {
                scrollview.setContentOffset(CGPoint(x: 0.0, y: section.root.frame.origin.y), animated: true)
            })
            .disposed(by: bag)
        viewModel.outputs.phoneNumber.bind(to: phone.rx.messageType).disposed(by: bag)

        viewModel.outputs.showNameFields.bind(to: section.firstname.rx.isVisible).disposed(by: bag)
        viewModel.outputs.showNameFields.bind(to: section.lastname.rx.isVisible).disposed(by: bag)
    }

    // MARK: Shipping method

    private struct ShippingMethodView {
        let root: UIView
        let deliverySelection: DeliverySelectionView
    }

    private func getShippingMethodView() -> ShippingMethodView {
        let root = ViewFactory.createView(skeletonable: true)

        let title = ViewFactory.createTitle(R.string.localizable.checkoutDeliveryMethodTitle(), skeletonable: true)
        root.addSubview(title)
        title.verticalPin(to: root, orientation: .top)
        title.pinToEdges(of: root, orientation: .horizontal)

        let selectionView = DeliverySelectionView(frame: .zero)
        selectionView.isSkeletonable = true
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.delegate = self
        root.addSubview(selectionView)
        selectionView.pinToEdges(of: root, orientation: .horizontal)
        selectionView.alignBelow(view: title, withPadding: 16)

        root.verticalPin(to: selectionView, orientation: .bottom)

        return ShippingMethodView(root: root, deliverySelection: selectionView)
    }

    private func setupShippingData(_ section: ShippingMethodView,
                                   addressView: AddressesView,
                                   addressTopConstraint: NSLayoutConstraint,
                                   addressNextButtonConstraint: NSLayoutConstraint,
                                   shippingNextButtonConstraint: NSLayoutConstraint) {
        viewModel.outputs.deliverySelected.bind(to: addressView.root.rx.isVisible).disposed(by: bag)

        viewModel.outputs.addresses.compactMap { $0.first }.subscribe(onNext: { [weak self] vm in
            self?.selectedIndexPath = IndexPath(row: 0, section: 0)
            self?.viewModel.addressSelected(vm)
        }).disposed(by: bag)

        Observable
            .zip(addressView.tableView.rx.itemSelected, addressView.tableView.rx.modelSelected(DeliveryCellViewModel.self))
            .bind { [weak self] indexPath, model in
                guard let self = self else { return }
                if indexPath.row != self.selectedIndexPath?.row {
                    self.selectedIndexPath = indexPath
                    self.viewModel.addressSelected(model)
                }
                addressView.tableView.deselectRow(at: indexPath, animated: false)
            }.disposed(by: bag)

        viewModel.outputs.addresses.bind(to: addressView.tableView.rx.items(cellIdentifier: DeliveryCell.identifier, cellType: DeliveryCell.self)) { [weak self] _, data, cell in
            guard let self = self else { return }
            cell.configure(with: data, bag: self.bag)
        }.disposed(by: bag)

        let showAddressObserver = Observable.combineLatest(viewModel.outputs.deliverySelected, viewModel.outputs.addresses).observeOn(MainScheduler.instance)
        showAddressObserver
            .map { !$0.0 ? 0 : CGFloat($0.1.count) * 64.0 }
            .bind(to: addressView.tableHeight.rx.constant)
            .disposed(by: bag)

        showAddressObserver
            .map { !$0.0 ? 0 : 32 }
            .bind(animated: addressTopConstraint.rx.animated.layout(duration: 0.33).constant)
            .disposed(by: bag)

        showAddressObserver.map { !$0.1.isEmpty }.subscribe(onNext: { result in
            addressView.noAddressViews.forEach { $0.isVisible = !result }
            addressView.hasAddressViews.forEach { $0.isVisible = result }
        }).disposed(by: bag)

        showAddressObserver.map { $0.0 }.subscribe(onNext: { result in
            addressNextButtonConstraint.isActive = result
            shippingNextButtonConstraint.isActive = !result
        }).disposed(by: bag)

        viewModel.outputs.missingAddressError.map { $0 ? R.color.redInvalidLight()! : .black }
            .bind(to: addressView.missingAddressLabel.rx.textColor).disposed(by: bag)

        var deliveryButton: ImageTextRadioButton?
        var pickupButton: ImageTextRadioButton?
        var verticalConstraint: NSLayoutConstraint?
        Observable.combineLatest(viewModel.outputs.isDeliveryVisible,
                                 viewModel.outputs.customShippingPrice,
                                 viewModel.outputs.shippingMethod,
                                 viewModel.outputs.isPickupVisible,
                                 viewModel.outputs.addresses,
                                 viewModel.outputs.totals)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                section.deliverySelection.clearButtons()
                if result.0, let shipping = result.2 {
                    let price = result.1 ?? result.5.shipping ?? shipping.pricing
                    let hasAtLeastOneAddress = !result.4.isEmpty && (result.5.shipping?.amount ?? 0) > 0
                    deliveryButton = section.deliverySelection.addButton(forMethod: shipping,
                                                                         price: price,
                                                                         showPrice: hasAtLeastOneAddress,
                                                                         descriptionPrefix: "checkout")
                }
                if result.3 {
                    pickupButton = section.deliverySelection.addPickupButton()
                }
                if let last = section.deliverySelection.subviews.last {
                    if let constraint = verticalConstraint {
                        section.deliverySelection.removeConstraint(constraint)
                    }
                    verticalConstraint = section.deliverySelection.verticalPin(to: last, orientation: .bottom)
                }
            }).disposed(by: bag)

        Observable.combineLatest(viewModel.outputs.deliverySelected,
                                 viewModel.outputs.shippingMethod,
                                 viewModel.outputs.totals)
            .subscribe(onNext: { result in
                if result.0 {
                    if result.1 != nil {
                        deliveryButton?.isSelected = true
                    }
                } else {
                    pickupButton?.isSelected = true
                }
            }).disposed(by: bag)
    }

    private struct AddressesView {
        let container: UIStackView
        let root: UIView
        let title: UILabel
        let tableView: UITableView
        let tableHeight: NSLayoutConstraint
        let missingAddressLabel: UILabel
        let noAddressViews: [UIView]
        let hasAddressViews: [UIView]
    }

    private func getAddressView() -> AddressesView {
        let container = ViewFactory.createVerticalStack()
        let root = ViewFactory.createView()
        container.addArrangedSubview(root)

        let title = ViewFactory.createTitle(R.string.localizable.checkoutDeliveryAddressTitle())
        root.addSubview(title)
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top)

        let divider = ViewFactory.createDivider(orientation: .horizontal)
        root.addSubview(divider)
        divider.pinToEdges(of: root, orientation: .horizontal)
        divider.alignBelow(view: title, withPadding: 16)

        let verticalStack = ViewFactory.createVerticalStack(spacing: 8)
        verticalStack.distribution = .equalSpacing
        verticalStack.alignment = .center
        root.addSubview(verticalStack)
        verticalStack.pinToEdges(of: root, orientation: .horizontal)
        verticalStack.alignBelow(view: divider, withPadding: 8)

        let tableview = UITableView(frame: .zero)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.isScrollEnabled = false
        verticalStack.addArrangedSubview(tableview)
        tableview.pinToEdges(of: verticalStack, orientation: .horizontal)

        tableview.delegate = self
        tableview.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.margin, bottom: 0, right: UIConstants.margin)
        tableview.register(UINib(nibName: DeliveryCell.nibName, bundle: nil), forCellReuseIdentifier: DeliveryCell.identifier)
        let tableHeight = tableview.setHeightAnchor(0)
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableview.frame.size.width, height: 1))
        tableview.tableFooterView = footer

        let dividerBottom = ViewFactory.createDivider(orientation: .horizontal)
        verticalStack.addArrangedSubview(dividerBottom)
        dividerBottom.pinToEdges(of: verticalStack, orientation: .horizontal)

        let noAddressLabel = ViewFactory.createLabel(text: R.string.localizable.createAdShippingMissingAddressLabel(), font: .descriptionText)
        verticalStack.addArrangedSubview(noAddressLabel)
        noAddressLabel.pinToEdges(of: verticalStack, orientation: .horizontal, padding: UIConstants.margin)
        noAddressLabel.isHidden = true

        let addButtonNoAddress = ViewFactory.createSecondaryButton(text: R.string.localizable.my_addresses_address_list_add(),
                                                                   icon: R.image.ic_plus_blue(),
                                                                   buttonColor: R.color.shinyBlue())
        verticalStack.addArrangedSubview(addButtonNoAddress)
        addButtonNoAddress.setHeightAnchor(UIConstants.buttonHeight)
        addButtonNoAddress.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        addButtonNoAddress.rx.tap.bind { [weak self] in
            self?.viewModel.selectAddress()
        }.disposed(by: bag)
        addButtonNoAddress.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        addButtonNoAddress.alignBelow(view: noAddressLabel, withPadding: 24)
        addButtonNoAddress.isHidden = true

        let blueButton = ViewFactory.createBlueTextButton(text: R.string.localizable.checkoutAddNewAddressButton(),
                                                          image: R.image.ic_plus_blue(),
                                                          font: .descriptionSemibold)
        blueButton.imageView?.contentMode = .scaleAspectFit
        blueButton.imageEdgeInsets = UIEdgeInsets(top: 4,
                                                  left: 0,
                                                  bottom: 4,
                                                  right: 0)
        blueButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        verticalStack.addArrangedSubview(blueButton)
        blueButton.rx.tap.bind { [weak self] in
            self?.viewModel.selectAddress()
        }.disposed(by: bag)
        blueButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)

        root.verticalPin(to: verticalStack, orientation: .bottom)

        return AddressesView(container: container,
                             root: root,
                             title: title,
                             tableView: tableview,
                             tableHeight: tableHeight,
                             missingAddressLabel: noAddressLabel,
                             noAddressViews: [noAddressLabel, addButtonNoAddress],
                             hasAddressViews: [tableview, blueButton, dividerBottom])
    }
    
    var phoneDescriptionHeightAnchor: NSLayoutConstraint?
    
    private func validateData() -> Bool {
        var isValid = true
        for validator in validators {
            isValid = validator.validate() && isValid
        }

        // Temporary hack, we'll rebuild in SwiftUI soon.
        let topAnchor: CGFloat = isValid ? 20 : 45
        
        if let existing = phoneDescriptionHeightAnchor {
            existing.constant = topAnchor
        } else {
            phoneDescriptionHeightAnchor = phoneDescription.setHeightAnchor(topAnchor)
        }
        
        return isValid
    }
}

// MARK: - UITableViewDelegate

extension PaymentContactShippingViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        64.0
    }
}

extension PaymentContactShippingViewController: DeliverySelectionViewDelegate {
    func deliverySelectionView(didSelectMethod: DeliverySelectionView.SelectedMethod) {
        switch didSelectMethod {
        case .pickup:
            viewModel.selectPickup()
        case .delivery:
            viewModel.selectDelivery()
        }
    }
}
