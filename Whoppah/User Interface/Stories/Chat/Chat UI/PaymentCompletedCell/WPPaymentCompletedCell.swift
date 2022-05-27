//
//  WPPaymentCompletedCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/3/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import RxSwift
import UIKit
import WhoppahCore
import WhoppahDataStore

protocol WPPaymentCompletedCellDelegate: AnyObject {
    func expandToggled(withOrderId orderId: UUID, andValue value: Bool)
}

class WPPaymentCompletedCell: MSGMessageCell {
    // MARK: - IBOutlets

    @IBOutlet var bubbleView: UIView!
    @IBOutlet var avatarView: UIImageView!

    @IBOutlet var bubbleTitle: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var adPriceContainerView: UIView!
    @IBOutlet var adPriceLabel: UILabel!
    @IBOutlet var transactionFeeLabel: UILabel!
    @IBOutlet var transactionFeeContainerView: UIView!
    @IBOutlet var whoppahFeeTitleLabel: UILabel!
    @IBOutlet var whoppahFeeLabel: UILabel!
    @IBOutlet var whoppahFeeContainerView: UIView!
    @IBOutlet var vatListLabel: UILabel!
    @IBOutlet var vatLabel: UILabel!
    @IBOutlet var vatContainerView: UIView!
    @IBOutlet var deliveryCostLabel: UILabel!
    @IBOutlet var deliveryCostContainerView: UIView!
    @IBOutlet var totalPriceContainerView: UIView!
    @IBOutlet var totalPriceTitleLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var expandImage: UIImageView!
    @IBOutlet var addressTitleLabel: UILabel!
    @IBOutlet var deliveryTipLabel: UILabel!
    @IBOutlet var addressName: UILabel!
    @IBOutlet var addressLabelLine1: UILabel!
    @IBOutlet var addressLabelLine2: UILabel!

    private static let titleHeight: CGFloat = 55
    private static let descriptionTipHeight: CGFloat = 46
    private static let totalRowHeight: CGFloat = 30
    private static let totalAddressSpacing: CGFloat = 8
    private static let fullAddressHeight: CGFloat = 108
    private static let deliveryTipLabelHeight: CGFloat = 32

    // MARK: - Properties

    var avatarGestureRecognizer: UITapGestureRecognizer!
    private let bag = DisposeBag()
    weak var cellDelegate: WPPaymentCompletedCellDelegate?

    // MARK: - Override

    open override var message: MSGMessage? {
        didSet {
            reloadMessage()
        }
    }

    override var isLastInSection: Bool {
        didSet {
            avatarView?.isHidden = !isLastInSection
        }
    }

    var isExpanded: Bool = true {
        didSet {
            reloadMessage()
            if isExpanded {
                expandImage.image = R.image.orderExpandUp()
            } else {
                expandImage.image = R.image.orderExpandDown()
            }
        }
    }

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        bubbleView.clipsToBounds = true
        bubbleView.layer.cornerRadius = 20.0
        bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        bubbleView.layer.borderColor = UIColor.smoke.cgColor
        bubbleView.layer.borderWidth = 1.0

        avatarView?.layer.cornerRadius = 17.0
        avatarView?.layer.masksToBounds = true

        avatarGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarView?.addGestureRecognizer(avatarGestureRecognizer)
        avatarView?.isUserInteractionEnabled = true

        addressTitleLabel.text = R.string.localizable.chat_cell_payment_complete_delivery_address().localizedUppercase

        let tap = UITapGestureRecognizer()
        tap.rx.event.bind { [weak self] _ in
            guard let self = self else { return }
            self.isExpanded = !self.isExpanded
            guard let dataMessage = self.chatMessage else { return }
            switch dataMessage.type {
            case let .paymentCompletedBuyer(payload):
                self.cellDelegate?.expandToggled(withOrderId: payload.orderId, andValue: self.isExpanded)
            case let .paymentCompletedSeller(payload):
                self.cellDelegate?.expandToggled(withOrderId: payload.orderId, andValue: self.isExpanded)
            case let .paymentCompletedMerchant(payload):
                self.cellDelegate?.expandToggled(withOrderId: payload.orderId, andValue: self.isExpanded)
            default: break
            }
        }.disposed(by: bag)
        totalPriceContainerView.addGestureRecognizer(tap)
    }

    // MARK: - Action

    @objc func avatarTapped(_: UITapGestureRecognizer) {
        guard let user = message?.user else { return }
        delegate?.cellAvatarTapped(for: user)
    }

    private enum TotalRow {
        case subtotal(value: String)
        case whoppahFee(label: String, value: String)
        case payment(value: String)
        case shipping(value: String)
        case vat(label: String, value: String)
    }

    private struct OrderStatementComponents {
        let components: [TotalRow]
        let addressSection: Bool
    }

    private static func getShippingRow(shippingCost: PriceInput?, isExpanded: Bool) -> TotalRow? {
        guard isExpanded, let deliveryCost = shippingCost, deliveryCost.amount > Double.ulpOfOne else { return nil }
        return TotalRow.shipping(value: "+ \(deliveryCost.formattedPrice(showFraction: true))")
    }

    private static func getOrderLayoutBuyer(payload: PaymentCompletedBuyerPayload, isExpanded: Bool) -> OrderStatementComponents {
        guard isExpanded else { return OrderStatementComponents(components: [], addressSection: payload.deliveryMethod == .delivery) }
        var components = [TotalRow]()

        components.append(TotalRow.subtotal(value: "\(payload.adPrice.formattedPrice(showFraction: true))"))

        if payload.paymentFee.amount > Double.ulpOfOne {
            components.append(TotalRow.payment(value: "+ \(payload.paymentFee.formattedPrice(showFraction: true))"))
        }

        let addressSection = payload.deliveryMethod == .delivery
        if addressSection, let shipping = getShippingRow(shippingCost: payload.shippingCost, isExpanded: isExpanded) {
            if case let .shipping(value) = shipping {
                components.append(TotalRow.shipping(value: value))
            }
        }

        return OrderStatementComponents(components: components, addressSection: addressSection)
    }

    private static func getOrderLayoutSeller(payload: PaymentCompletedSellerPayload, isExpanded: Bool) -> OrderStatementComponents {
        guard isExpanded else { return OrderStatementComponents(components: [], addressSection: payload.deliveryMethod == .delivery) }
        var components = [TotalRow]()

        components.append(TotalRow.subtotal(value: "\(payload.adPrice.formattedPrice(showFraction: true))"))

        if payload.whoppahFee.amount > Double.ulpOfOne {
            let feeTitle: String
            if payload.whoppahFeeType == .percentage, let value = payload.whoppahFeePercent {
                feeTitle = "\(R.string.localizable.chat_cell_payment_complete_merchant_fee()) (\(value.formatAsSimpleDecimal() ?? "")%)"
            } else {
                feeTitle = R.string.localizable.chat_cell_payment_complete_merchant_fee()
            }

            components.append(TotalRow.whoppahFee(label: feeTitle,
                                                  value: "- \(payload.whoppahFee.formattedPrice(showFraction: true))"))
        }

        let addressSection = payload.deliveryMethod == .delivery
        if addressSection, let shipping = getShippingRow(shippingCost: payload.shippingCost, isExpanded: isExpanded) {
            if case let .shipping(value) = shipping {
                components.append(TotalRow.shipping(value: value))
            }
        }

        return OrderStatementComponents(components: components, addressSection: addressSection)
    }

    private static func getOrderLayoutMerchant(payload: PaymentCompletedMerchantPayload, isExpanded: Bool) -> OrderStatementComponents {
        guard isExpanded else { return OrderStatementComponents(components: [], addressSection: payload.deliveryMethod == .delivery) }
        var components = [TotalRow]()

        components.append(TotalRow.subtotal(value: "\(payload.adPrice.formattedPrice(showFraction: true))"))

        if payload.whoppahFee.amount > Double.ulpOfOne {
            let feeTitle: String
            if payload.whoppahFeeType == .percentage, let value = payload.whoppahFeePercent {
                feeTitle = "\(R.string.localizable.chat_cell_payment_complete_merchant_fee()) (\(value.formatAsSimpleDecimal() ?? "")%)"
            } else {
                feeTitle = R.string.localizable.chat_cell_payment_complete_merchant_fee()
            }
            components.append(TotalRow.whoppahFee(label: feeTitle,
                                                  value: "- \(payload.whoppahFeeExclVAT.formattedPrice(showFraction: true))"))
        }

        if payload.vatFee.amount > Double.ulpOfOne {
            let vatTitle = R.string.localizable.chat_cell_payment_complete_merchant_vat_fee(Int(payload.vatPercent.rounded()))
            components.append(TotalRow.vat(label: vatTitle,
                                           value: "- \(payload.vatFee.formattedPrice(showFraction: true))"))
        }

        let addressSection = payload.deliveryMethod == .delivery
        if addressSection, let shipping = getShippingRow(shippingCost: payload.shippingCost, isExpanded: isExpanded) {
            if case let .shipping(value) = shipping {
                components.append(TotalRow.shipping(value: value))
            }
        }

        return OrderStatementComponents(components: components, addressSection: addressSection)
    }

    private var chatMessage: ChatMessage? {
        guard let uiMessage = message else { return nil }
        guard case let MSGMessageBody.custom(body) = uiMessage.body else { return nil }
        return body as? ChatMessage
    }

    private func getDescriptionLabel(forMethod method: GraphQL.DeliveryMethod, shippingSlug: String?, isBuyer: Bool) -> String? {
        let person = isBuyer ? "buyer" : "seller"
        let methodText = method == .pickup ? "pickup" : "delivery"
        if let shippingSlug = shippingSlug {
            if let text = localizedString("chat-cell-order-confirm-\(person)-\(methodText)-\(shippingSlug)-description", logError: false) {
                return text
            }
        }
        return localizedString("chat-cell-order-confirm-\(person)-\(methodText)-description", logError: false)
    }

    private func reloadMessage() {
        guard let dataMessage = chatMessage else { return }

        var buyerName: String!
        var address: LegacyAddressInput?
        var showAddress: Bool = false
        var totalPrice: PriceInput?
        var components = [TotalRow]()
        if case let .paymentCompletedBuyer(payload) = dataMessage.type {
            let buyer = Self.getOrderLayoutBuyer(payload: payload, isExpanded: isExpanded)
            buyerName = payload.buyerName
            address = payload.address
            showAddress = buyer.addressSection
            components = buyer.components
            totalPrice = payload.totalPrice
            bubbleTitle.setTitle(R.string.localizable.chatCellOrderConfirmBuyerTitle(), for: .normal)
            descriptionLabel.text = getDescriptionLabel(forMethod: payload.deliveryMethod, shippingSlug: payload.shippingSlug, isBuyer: true)
            totalPriceTitleLabel.text = R.string.localizable.chat_cell_payment_buyer_total_title()
        } else if case let .paymentCompletedSeller(payload) = dataMessage.type {
            buyerName = payload.buyerName
            address = payload.address
            totalPrice = payload.payout
            let seller = Self.getOrderLayoutSeller(payload: payload, isExpanded: isExpanded)
            showAddress = seller.addressSection
            components = seller.components
            bubbleTitle.setTitle(R.string.localizable.chatCellOrderConfirmSellerTitle(), for: .normal)
            descriptionLabel.text = getDescriptionLabel(forMethod: payload.deliveryMethod, shippingSlug: payload.shippingSlug, isBuyer: false)
            totalPriceTitleLabel.text = R.string.localizable.chat_cell_payment_total()
        } else if case let .paymentCompletedMerchant(payload) = dataMessage.type {
            buyerName = payload.buyerName
            address = payload.address
            totalPrice = payload.payout
            let merchant = Self.getOrderLayoutMerchant(payload: payload, isExpanded: isExpanded)
            showAddress = merchant.addressSection
            components = merchant.components
            bubbleTitle.setTitle(R.string.localizable.chatCellOrderConfirmSellerTitle(), for: .normal)
            descriptionLabel.text = getDescriptionLabel(forMethod: payload.deliveryMethod, shippingSlug: payload.shippingSlug, isBuyer: false)
            totalPriceTitleLabel.text = R.string.localizable.chat_cell_payment_total()
        }

        totalPriceLabel.text = totalPrice?.formattedPrice(showFraction: true)

        adPriceContainerView.isVisible = false
        whoppahFeeContainerView.isVisible = false
        transactionFeeContainerView.isVisible = false
        vatContainerView.isVisible = false
        deliveryCostContainerView.isVisible = false
        components.forEach { component in
            switch component {
            case let .whoppahFee(label, value):
                whoppahFeeTitleLabel.text = label
                whoppahFeeLabel.text = value
                whoppahFeeContainerView.isVisible = true
            case let .payment(value):
                transactionFeeLabel.text = value
                transactionFeeContainerView.isVisible = true
            case let .vat(label, value):
                vatListLabel.text = label
                vatLabel.text = value
                vatContainerView.isVisible = true
            case let .subtotal(value):
                adPriceLabel.text = value
                adPriceContainerView.isVisible = true
            case let .shipping(value):
                deliveryCostLabel.text = value
                deliveryCostContainerView.isVisible = true
            }
        }

        if showAddress {
            addressTitleLabel.isHidden = false
            addressName.isHidden = false
            addressLabelLine1.isHidden = false
            addressLabelLine2.isHidden = false
            deliveryTipLabel.isHidden = true
            if let location = address {
                addressName.text = buyerName
                addressLabelLine1.text = location.line1
                if let line2 = location.line2, !line2.isEmpty {
                    addressLabelLine2.text = "\(line2)\n\(location.postalCode) \(location.city)"
                } else {
                    addressLabelLine2.text = "\(location.postalCode) \(location.city)"
                }

                if let display = location.displayCountry, let text = addressLabelLine2.text {
                    addressLabelLine2.text = "\(text) \(display)"
                }
            }
        } else {
            deliveryCostContainerView.isHidden = true
            addressTitleLabel.isHidden = true
            addressName.isHidden = true
            addressLabelLine1.isHidden = true
            addressLabelLine2.isHidden = true
            deliveryTipLabel.isHidden = false
            deliveryTipLabel.text = R.string.localizable.chat_cell_buyer_will_pick_up()
        }

        avatarView!.loadChatAvatar(message)
    }

    private static func getCellHeight(components: [TotalRow], addressSection: Bool) -> CGFloat {
        var height = titleHeight + descriptionTipHeight + CGFloat(components.count) * totalRowHeight
        height += totalRowHeight // The total
        height += totalAddressSpacing
        if addressSection {
            height += fullAddressHeight
        } else {
            height += deliveryTipLabelHeight
        }
        return height
    }

    static func size(forSize availableSize: CGSize, payload: PaymentCompletedBuyerPayload, expanded: Bool) -> CGSize {
        let layout = getOrderLayoutBuyer(payload: payload, isExpanded: expanded)
        let height = getCellHeight(components: layout.components, addressSection: layout.addressSection)
        return CGSize(width: availableSize.width, height: height)
    }

    static func size(forSize availableSize: CGSize, payload: PaymentCompletedSellerPayload, expanded: Bool) -> CGSize {
        let layout = getOrderLayoutSeller(payload: payload, isExpanded: expanded)
        let height = getCellHeight(components: layout.components, addressSection: layout.addressSection)
        return CGSize(width: availableSize.width, height: height)
    }

    static func size(forSize availableSize: CGSize, payload: PaymentCompletedMerchantPayload, expanded: Bool) -> CGSize {
        let layout = getOrderLayoutMerchant(payload: payload, isExpanded: expanded)
        let height = getCellHeight(components: layout.components, addressSection: layout.addressSection)
        return CGSize(width: availableSize.width, height: height)
    }
}
