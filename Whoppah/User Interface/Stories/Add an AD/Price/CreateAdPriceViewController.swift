//
//  CreateAdPriceViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 22/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import EasyTipView
import Foundation
import RxCocoa
import RxSwift

class CreateAdPriceViewController: CreateAdViewControllerBase {
    var viewModel: CreateAdPriceViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.createAdCommonYourAdTitle(), transparent: false)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.createAdPriceTitle())
        root.addSubview(title)
        title.textColor = .black
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let price = getPriceTextfield()
        root.addSubview(price)
        price.contentHeight = UIConstants.textfieldHeight
        price.alignBelow(view: title, withPadding: UIConstants.titleBottomMargin)
        price.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)

        let priceCurrencyView = getCurrencySymbolView(font: price.font)
        price.setCurrencyLeftView(priceCurrencyView)

        let feeDescription = ViewFactory.createLabel(text: "", font: UIConstants.descriptionFont)
        feeDescription.numberOfLines = 0
        root.addSubview(feeDescription)
        feeDescription.alignBelow(view: price, withPadding: 8)
        feeDescription.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        viewModel.outputs.feeExplanationText.bind(to: feeDescription.rx.text).disposed(by: bag)
        viewModel.outputs.totals.map { $0 == nil }.bind(to: feeDescription.rx.isVisible).disposed(by: bag)

        let verticalStack = getPriceBreakdownView()
        root.addSubview(verticalStack)
        verticalStack.alignBelow(view: price)
        verticalStack.pinToEdges(of: root, orientation: .horizontal)

        let bidTitle = ViewFactory.createTitle(R.string.localizable.createAdPriceBiddingSectionTitle())
        root.addSubview(bidTitle)
        let descriptionStackConstraint = bidTitle.alignBelow(view: verticalStack, withPadding: 32)
        bidTitle.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        let feeBottomConstraint = bidTitle.alignBelow(view: feeDescription, withPadding: 32)
        feeBottomConstraint.isActive = false

        viewModel.outputs.totals.subscribe(onNext: { [weak self] totals in
            guard let self = self else { return }
            descriptionStackConstraint.isActive = totals != nil
            feeBottomConstraint.isActive = totals == nil
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }).disposed(by: bag)

        let bidDescription = ViewFactory.createLabel(text: R.string.localizable.create_ad_select_allow_bids_description(), font: UIConstants.descriptionFont)
        bidDescription.numberOfLines = 0
        root.addSubview(bidDescription)
        bidDescription.alignBelow(view: bidTitle, withPadding: 4)
        bidDescription.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)

        let descriptionDivider = ViewFactory.createDivider(orientation: .horizontal, backgroundColor: UIConstants.titleDividerColor)
        root.addSubview(descriptionDivider)
        descriptionDivider.alignBelow(view: bidDescription, withPadding: 4)
        descriptionDivider.pinToEdges(of: root, orientation: .horizontal)

        let bidSection = getBidSection()
        root.addSubview(bidSection)
        bidSection.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        bidSection.alignBelow(view: descriptionDivider)

        let bidDivider = ViewFactory.createDivider(orientation: .horizontal)
        root.addSubview(bidDivider)
        bidDivider.verticalPin(to: bidSection, orientation: .bottom)
        bidDivider.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        bidDivider.horizontalPin(to: root, orientation: .trailing)

        let bidStack = getMinBidSection()
        root.addSubview(bidStack)
        bidStack.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        bidStack.alignBelow(view: bidDivider, withPadding: 16)

        let buttonText = nextButtonText(viewModel, R.string.localizable.createAdPriceButtonTitle())
        let nextButton = ViewFactory.createPrimaryButton(text: buttonText)
        root.addSubview(nextButton)
        nextButton.alignBelow(view: bidStack, withPadding: 40)
        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.next()
        }.disposed(by: bag)
        viewModel.outputs.nextEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: bag)

        root.verticalPin(to: nextButton, orientation: .bottom, padding: 16)

        addCloseButtonIfRequired(viewModel)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard parent == nil else { return }
        viewModel.onDismiss()
    }

    struct PriceRow {
        let root: UIView
        let left: UILabel
        let right: UILabel
    }

    private func getPriceRow(label: String, price: String, backgroundColor: UIColor? = nil) -> PriceRow {
        let root = ViewFactory.createView()

        let left = ViewFactory.createLabel(text: label, font: UIConstants.descriptionFont)
        root.addSubview(left)
        left.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin * 2)
        left.center(withView: root, orientation: .vertical)

        let right = ViewFactory.createLabel(text: price, font: UIConstants.descriptionFont)
        root.addSubview(right)
        right.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin * 2)
        right.center(withView: root, orientation: .vertical)

        if let background = backgroundColor {
            root.backgroundColor = background
        } else {
            let divider = ViewFactory.createDivider(orientation: .horizontal)
            root.addSubview(divider)
            divider.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
            divider.horizontalPin(to: root, orientation: .trailing)
            divider.verticalPin(to: root, orientation: .bottom)
        }
        return PriceRow(root: root, left: left, right: right)
    }

    private func getTipView() -> UIView {
        let infoIcon = ViewFactory.createButton(image: R.image.ic_info_icon_blue())
        infoIcon.setAspect(1.0)
        infoIcon.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont.systemFont(ofSize: 11)
            preferences.drawing.foregroundColor = .white
            preferences.drawing.backgroundColor = .shinyBlue
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top

            let ev = EasyTipView(text: self.viewModel.tipText(), preferences: preferences, delegate: nil)
            ev.show(animated: true, forView: infoIcon, withinSuperview: self.navigationController?.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                ev.dismiss()
            }
        }.disposed(by: bag)
        return infoIcon
    }

    private func getMinBidTextfield() -> WPTextField {
        let minBidAmount = ViewFactory.createTextField(placeholder: R.string.localizable.createAdPriceMinBidPlaceholder())
        minBidAmount.keyboardType = .numberPad
        minBidAmount.contentHeight = UIConstants.textfieldHeight
        minBidAmount.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]).asObservable().map { minBidAmount.text ?? "" }.bind(to: viewModel.inputs.minBid).disposed(by: bag)
        viewModel.outputs.biddingEnabled.bind(to: minBidAmount.rx.isVisible).disposed(by: bag)
        viewModel.outputs.minBid.bind(to: minBidAmount.rx.messageType).disposed(by: bag)

        return minBidAmount
    }

    private func getPriceTextfield() -> WPTextField {
        let price = ViewFactory.createTextField(placeholder: R.string.localizable.create_ad_select_price_input_title())
        price.keyboardType = .numberPad
        price.contentHeight = UIConstants.textfieldHeight
        price.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]).asObservable().map { price.text ?? "" }.bind(to: viewModel.inputs.price).disposed(by: bag)
        viewModel.outputs.price.bind(to: price.rx.messageType).disposed(by: bag)
        return price
    }

    private func getPriceBreakdownView() -> UIView {
        let verticalStack = ViewFactory.createVerticalStack(spacing: 0)

        let subtotal = getPriceRow(label: R.string.localizable.create_ad_select_price_merchant_ask_price(), price: "")
        subtotal.root.setHeightAnchor(40)
        verticalStack.addArrangedSubview(subtotal.root)

        let whoppahFee = getPriceRow(label: "Whoppah Fee", price: "")
        whoppahFee.root.setHeightAnchor(40)
        viewModel.outputs.showFeeView.bind(animated: whoppahFee.root.rx.isVisible).disposed(by: bag)
        verticalStack.addArrangedSubview(whoppahFee.root)

        let infoIcon = getTipView()
        whoppahFee.root.addSubview(infoIcon)
        infoIcon.center(withView: whoppahFee.root, orientation: .vertical)
        infoIcon.alignAfter(view: whoppahFee.left, withPadding: 4)

        let vat = getPriceRow(label: "BTW", price: "")
        vat.root.setHeightAnchor(40)
        verticalStack.addArrangedSubview(vat.root)

        let total = getPriceRow(label: R.string.localizable.create_ad_select_price_merchant_receive(),
                                price: "",
                                backgroundColor: .lightBlue)
        total.root.setHeightAnchor(40)
        verticalStack.addArrangedSubview(total.root)

        viewModel.outputs.totals.compactMap { $0 }.subscribe(onNext: { totals in
            subtotal.right.text = totals.price
            whoppahFee.left.text = totals.whoppahFeeLabel
            whoppahFee.right.text = totals.whoppahFee
            vat.left.text = totals.vatLabel
            vat.right.text = totals.vat
            total.right.text = totals.total
        }).disposed(by: bag)
        viewModel.outputs.showVATView.bind(to: vat.root.rx.isVisible).disposed(by: bag)
        viewModel.outputs.totals.map { $0 != nil }.bind(to: verticalStack.rx.isVisible).disposed(by: bag)

        return verticalStack
    }

    private func getBidSection() -> UIView {
        let bidSection = ViewFactory.createView()
        bidSection.setHeightAnchor(44)

        let bidLeft = ViewFactory.createLabel(text: R.string.localizable.createAdPriceBiddingSwitchTitle(), font: .descriptionLabel)
        bidSection.addSubview(bidLeft)
        bidLeft.horizontalPin(to: bidSection, orientation: .leading)
        bidLeft.center(withView: bidSection, orientation: .vertical)

        let bidSwitch = ViewFactory.createSwitch()
        bidSection.addSubview(bidSwitch)
        bidSwitch.horizontalPin(to: bidSection, orientation: .trailing)
        bidSwitch.center(withView: bidSection, orientation: .vertical)
        bidSwitch.rx.isOn.skip(1).bind(to: viewModel.inputs.allowBid).disposed(by: bag)
        viewModel.outputs.biddingEnabled.bind(to: bidSwitch.rx.isOn).disposed(by: bag)
        return bidSection
    }

    private func getMinBidSection() -> UIView {
        let bidStack = ViewFactory.createVerticalStack(spacing: 4)

        let minBidAmount = getMinBidTextfield()
        bidStack.addArrangedSubview(minBidAmount)
        minBidAmount.contentHeight = UIConstants.textfieldHeight
        minBidAmount.pinToEdges(of: bidStack, orientation: .horizontal)

        let currencyView = getCurrencySymbolView(font: minBidAmount.font)
        minBidAmount.setCurrencyLeftView(currencyView)

        let minBidDescription = ViewFactory.createLabel(text: R.string.localizable.createAdPriceMinBidDescription(), font: UIConstants.descriptionFont)
        bidStack.addArrangedSubview(minBidDescription)
        minBidDescription.pinToEdges(of: bidStack, orientation: .horizontal)

        viewModel.outputs.biddingEnabled.bind(to: minBidAmount.rx.isVisible).disposed(by: bag)
        viewModel.outputs.biddingEnabled.bind(to: minBidDescription.rx.isVisible).disposed(by: bag)
        return bidStack
    }

    private func getCurrencySymbolView(font: UIFont?) -> UIView {
        let currencyView = ViewFactory.createCurrencySymbolView(font: font)
        viewModel.outputs.currencySymbol.bind(to: currencyView.symbol.rx.text).disposed(by: bag)
        return currencyView.root
    }
}
