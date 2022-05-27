//
//  PaymentCheckoutViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 11/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import Stripe

class PaymentCheckoutViewController: UIViewController {
    var viewModel: PaymentViewModel!
    private let bag = DisposeBag()
    private var cardButton: ImageTextRadioButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.checkoutTitle(), enabled: true)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        // Title + image
        let adTitleSection = PaymentViewFactory.getAdTitleView()
        root.addSubview(adTitleSection.root)
        adTitleSection.root.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        adTitleSection.root.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)
        setupAdData(adTitleSection)

        // Payment options
        let optionSection = getPaymentOptionsSection()
        root.addSubview(optionSection.root)
        optionSection.root.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        optionSection.root.alignBelow(view: adTitleSection.root, withPadding: 16)
        setupPaymentOptions(optionSection)

        // Payment totals
        let paymentTotals = getPaymentTotalsView()
        root.addSubview(paymentTotals.root)
        paymentTotals.root.alignBelow(view: optionSection.root, withPadding: 16)
        paymentTotals.root.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        setupPaymentTotals(paymentTotals)

        let nextButton = ViewFactory.createPrimaryButton(text: R.string.localizable.checkout_pay_now_btn())
        root.addSubview(nextButton)
        nextButton.alignBelow(view: paymentTotals.root, withPadding: 32)
        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.checkout()
        }.disposed(by: bag)
        viewModel.outputs.isLoading.bind(to: nextButton.rx.isAnimating).disposed(by: bag)
        viewModel.outputs.payButtonEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: bag)

        let nextDescription = ViewFactory.createLabel(text: R.string.localizable.checkoutPayButtonDescription(), lines: 0, alignment: .center, font: .smallText)
        root.addSubview(nextDescription)
        nextDescription.alignBelow(view: nextButton, withPadding: 4)
        nextDescription.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)

        root.verticalPin(to: nextDescription, orientation: .bottom, padding: UIConstants.margin)

        addCustomCloseButton().rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: bag)
    }

    // MARK: Ad title

    private func setupAdData(_ section: PaymentViewFactory.AdTitleView) {
        viewModel.outputs.adImage.subscribe(onNext: { result in
            section.image.setImage(forUrl: result)
        }).disposed(by: bag)

        viewModel.outputs.title.bind(to: section.title.rx.text).disposed(by: bag)
    }

    // MARK: Payment options section

    private struct PaymentOptionsSection {
        let root: UIView
        let title: UILabel
        let selectionView: ImageTextRadioSelectionView
    }

    private func getPaymentOptionsSection() -> PaymentOptionsSection {
        let root = ViewFactory.createView()

        let title = ViewFactory.createTitle(R.string.localizable.checkoutPaymentMethodTitle())
        root.addSubview(title)
        title.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        title.verticalPin(to: root, orientation: .top)
        title.pinToEdges(of: root, orientation: .horizontal)

        let selectionView = ImageTextRadioSelectionView(frame: .zero)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(selectionView)
        selectionView.alignBelow(view: title, withPadding: 16)
        selectionView.pinToEdges(of: root, orientation: .horizontal)

        root.verticalPin(to: selectionView, orientation: .bottom)

        return PaymentOptionsSection(root: root, title: title, selectionView: selectionView)
    }

    private func setupPaymentOptions(_ section: PaymentOptionsSection) {
        var buttons = [PaymentViewModel.PaymentProvider: ImageTextRadioButton]()
        for (index, provider) in viewModel.paymentSources.enumerated() {
            let image = UIImage(named: "\(provider.type.rawValue.lowercased())-icon") ?? R.image.whoppah_foreground()!
            let button = section.selectionView.addButton(text: provider.title, icon: image)
            button.setHeightAnchor(50)
            if index == 0 {
                button.isSelected = true
            }
            buttons[provider] = button

            if provider.type == .card {
                cardButton = button
            }
        }

        section.selectionView.selectedButton.compactMap { $0 }
            .subscribe(onNext: { [weak self] selected in
                guard let self = self else { return }
                guard let result = buttons.first(where: { $0.value == selected }) else { return }
                let source = result.key
                if source.type == .card {
                    self.showStripeCardScreen()
                } else {
                    result.value.isSelected = true
                    self.viewModel.providerSelected(source)
                }
            }).disposed(by: bag)
        if let last = section.selectionView.subviews.last {
            section.selectionView.verticalPin(to: last, orientation: .bottom)
        }

        viewModel.outputs.selectedProvider.subscribe(onNext: { provider in
            if let result = buttons[provider] {
                result.isSelected = true
            }
        }).disposed(by: bag)
    }

    // MARK: Payment totals

    private struct PaymentTotalRow {
        let root: UIView
        let left: UILabel
        let right: UILabel
    }

    private struct PaymentTotalsView {
        let root: UIView
        let title: UILabel
        let stack: UIStackView
        let subtotal: PaymentTotalRow
        let payment: PaymentTotalRow
        let delivery: PaymentTotalRow
        let discount: PaymentTotalRow
        let buyerProtection: PaymentTotalRow
        let whoppahFee: PaymentTotalRow
        let total: PaymentTotalRow
    }

    private func getPaymentTotalsView() -> PaymentTotalsView {
        let root = ViewFactory.createView()

        let title = ViewFactory.createTitle(R.string.localizable.checkoutOrderDetailsTitle())
        root.addSubview(title)
        title.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        title.verticalPin(to: root, orientation: .top)
        title.pinToEdges(of: root, orientation: .horizontal)

        let borderView = ViewFactory.createView()
        root.addSubview(borderView)
        borderView.backgroundColor = .white
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = UIColor.smoke.cgColor

        let stack = ViewFactory.createVerticalStack()
        root.addSubview(stack)
        stack.alignBelow(view: title, withPadding: 8)
        stack.pinToEdges(of: root, orientation: .horizontal)
        stack.alignment = .center
        stack.distribution = .fill

        borderView.horizontalPin(to: stack, orientation: .leading, padding: -1)
        borderView.horizontalPin(to: stack, orientation: .trailing, padding: 1)
        borderView.verticalPin(to: stack, orientation: .top, padding: -1)
        borderView.verticalPin(to: stack, orientation: .bottom, padding: 1)

        let subtotal = getPaymentTotalsRow()
        subtotal.left.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        subtotal.left.numberOfLines = 1
        subtotal.left.lineBreakMode = .byTruncatingTail
        subtotal.left.frame = CGRect(x: 16, y: 4, width: UIScreen.main.bounds.width - 128, height: 26)
        subtotal.left.translatesAutoresizingMaskIntoConstraints = true

        stack.addArrangedSubview(subtotal.root)
        subtotal.root.pinToEdges(of: stack, orientation: .horizontal)

        let delivery = getPaymentTotalsRow()
        delivery.left.text = R.string.localizable.checkoutShippingCost()
        stack.addArrangedSubview(delivery.root)
        delivery.root.pinToEdges(of: stack, orientation: .horizontal)

        let payment = getPaymentTotalsRow()
        payment.left.text = R.string.localizable.checkoutPaymentCost()
        stack.addArrangedSubview(payment.root)
        payment.root.pinToEdges(of: stack, orientation: .horizontal)

        let discount = getPaymentTotalsRow()
        discount.left.text = R.string.localizable.checkoutDiscount()
        stack.addArrangedSubview(discount.root)
        discount.root.pinToEdges(of: stack, orientation: .horizontal)
        
        let buyerProtection = getPaymentTotalsRow()
        buyerProtection.left.text = "Buyer protection"
        stack.addArrangedSubview(buyerProtection.root)
        buyerProtection.root.pinToEdges(of: stack, orientation: .horizontal)

        let fee = getPaymentTotalsRow()
        stack.addArrangedSubview(fee.root)
        fee.root.pinToEdges(of: stack, orientation: .horizontal)

        let total = getPaymentTotalsRow(background: UIColor(hexString: "#F3F4F5"), addBottomBorder: false)
        total.left.text = R.string.localizable.checkoutTotalCost()
        total.left.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        total.right.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        stack.addArrangedSubview(total.root)
        total.root.pinToEdges(of: stack, orientation: .horizontal)

        root.verticalPin(to: stack, orientation: .bottom)

        return PaymentTotalsView(root: root,
                                 title: title,
                                 stack: stack,
                                 subtotal: subtotal,
                                 payment: payment,
                                 delivery: delivery,
                                 discount: discount,
                                 buyerProtection: buyerProtection,
                                 whoppahFee: fee,
                                 total: total)
    }

    private func getPaymentTotalsRow(background: UIColor = UIColor(hexString: "#FCFCFC"), addBottomBorder: Bool = true) -> PaymentTotalRow {
        let root = ViewFactory.createView()
        root.backgroundColor = background

        let left = ViewFactory.createLabel(text: "", font: .descriptionText)
        root.addSubview(left)
        left.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        left.pinToEdges(of: root, orientation: .vertical, padding: 8)

        let right = ViewFactory.createLabel(text: "", font: .descriptionText)
        root.addSubview(right)
        right.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)
        right.center(withView: root, orientation: .vertical)

        if addBottomBorder {
            let divider = ViewFactory.createDivider(orientation: .horizontal)
            root.addSubview(divider)
            divider.pinToEdges(of: root, orientation: .horizontal)
            divider.verticalPin(to: root, orientation: .bottom)
        }
        return PaymentTotalRow(root: root, left: left, right: right)
    }

    private func setupPaymentTotals(_ section: PaymentTotalsView) {
        viewModel.outputs.totals
            .subscribe(onNext: { [weak self] totals in
                self?.updateTotals(section, totals: totals)
            }).disposed(by: bag)

        viewModel.outputs.paymentLabel.bind(to: section.payment.left.rx.text).disposed(by: bag)
        viewModel.outputs.title.bind(to: section.subtotal.left.rx.text).disposed(by: bag)
    }

    private func updateTotals(_ section: PaymentTotalsView, totals: PaymentTotals) {
        section.subtotal.right.text = totals.subtotal.formattedPrice(showFraction: true)

        section.payment.root.isHidden = totals.paymentCost.amount.isApproxZero
        section.payment.right.text = totals.paymentCost.formattedPrice(showFraction: true)

        section.delivery.root.isHidden = totals.shipping?.amount.isApproxZero ?? true
        section.delivery.right.text = totals.shipping?.formattedPrice(showFraction: true)

        section.discount.root.isHidden = totals.discount.amount.isApproxZero
        section.discount.right.text = "-\(totals.discount.formattedPrice(showFraction: true))"
        
        section.buyerProtection.root.isHidden = totals.buyerProtectionInclVat.amount.isApproxZero
        section.buyerProtection.right.text = totals.buyerProtectionInclVat.formattedPrice(showFraction: true)

        section.whoppahFee.root.isHidden = true
        // whoppahFeePriceLabel.text = totals.fee.formattedPrice(showFraction: true)

        section.total.right.text = totals.total.formattedPrice(showFraction: true)
    }
}

// MARK: Stripe

extension PaymentCheckoutViewController: STPPaymentOptionsViewControllerDelegate {
    func showStripeCardScreen() {
        // Setup payment options view controller
        let paymentOptionsViewController = STPPaymentOptionsViewController(configuration: STPPaymentConfiguration.shared,
                                                                           theme: STPTheme.defaultTheme,
                                                                           customerContext: viewModel.customerContext,
                                                                           delegate: self)

        // Present payment options view controller
        let navigationController = UINavigationController(rootViewController: paymentOptionsViewController)
        present(navigationController, animated: true)
    }

    func paymentOptionsViewControllerDidCancel(_: STPPaymentOptionsViewController) {
        dismiss(animated: true, completion: nil)
    }

    func paymentOptionsViewController(_: STPPaymentOptionsViewController, didFailToLoadWithError error: Error) {
        showError(error)
    }

    func paymentOptionsViewController(_: STPPaymentOptionsViewController, didSelect paymentOption: STPPaymentOption) {
        var stripeId: String?
        if let cardPayment = paymentOption as? STPCard {
            stripeId = cardPayment.stripeID
        } else if let card2 = paymentOption as? STPSourceProtocol {
            stripeId = card2.stripeID
        } else if let payment = paymentOption as? STPPaymentMethod {
            stripeId = payment.stripeId
        }

        if let id = stripeId, let card = viewModel.paymentSources.first(where: { $0.type == .card }) {
            viewModel.providerSelected(card, stripeId: id)
            cardButton?.isSelected = true
        }
    }

    func paymentOptionsViewControllerDidFinish(_: STPPaymentOptionsViewController) {
        dismiss(animated: true, completion: nil)
    }
}
