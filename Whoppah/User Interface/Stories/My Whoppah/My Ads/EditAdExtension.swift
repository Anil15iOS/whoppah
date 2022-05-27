//
//  EditAdERxtension.swift
//  Whoppah
//
//  Created by Eddie Long on 03/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore

func getTemplate(_ product: ProductDetails, merchant _: LegacyMerchant) -> AdTemplate {
    let template = AdTemplate()
    template.id = product.id
    template.state = product.state
    template.title = product.title
    template.description = product.description
    if let price = product.price {
        template.price = PriceInput(currency: price.currency, amount: price.amount)
    }
    template.merchantFee = product.fee
    template.styles = product.styles
    template.quality = product.quality
    template.colors = product.colors
    template.categories = product.categoryList.map { $0 as AdAttribute } 
    template.artists = product.artists

    // Suggestion first, overwriten by a concrete brand later
    if let suggestion = product.brandSuggestion {
        template.brand = CustomAttribute(title: suggestion)
    }
    if let brand = product.brands.first {
        template.brand = brand
    }
    template.designers = product.designers
    template.images = product.originalImages
    template.videos = product.productVideos
    if let shipping = product.shipping {
        if shipping.slug == customShippingSlug, let price = product.customShippingPrice {
            template.shippingMethod = ShippingMethodInput(method: shipping, price: price.asInput())
        } else {
            template.shippingMethod = ShippingMethodInput(method: shipping, price: nil)
        }
    }
    template.delivery = product.deliveryMethod

    if let auction = product.currentAuction {
        var minBid: PriceInput?
        if let min = auction.minBid {
            minBid = PriceInput(price: min)
        }
        template.settings = ProductSettingsInput(allowBidding: auction.allowBid, allowBuyNow: auction.allowBuyNow, minBid: minBid)
    } else {
        template.settings = ProductSettingsInput(allowBidding: true, allowBuyNow: true, minBid: nil)
    }

    template.location = product.location
    template.width = product.width
    template.height = product.height
    template.depth = product.depth

    return template
}

extension UIViewController {
    func getEditAdVC(_ template: AdTemplate,
                     adCreator: ADCreator) -> UIViewController {
        adCreator.startEditing(template)

        if let state = template.state, case .draft = state {
            return showAdCompletionDialog(template, adCreator: adCreator)
        }
        return showAdSummaryScreen()
    }

    private func showAdCompletionDialog(_: AdTemplate,
                                        adCreator: ADCreator) -> UIViewController {
        let validationState = adCreator.validate(step: .all)
        switch validationState {
        case .none:
            return showAdSummaryScreen()
        default:
            let continueAdDialog = ContinueAdDialog()
            continueAdDialog.onContinueClicked = {
                let nav = WhoppahNavigationController()
                nav.isModalInPresentation = true
                if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }

                switch validationState {
                case .description:
                    let coordinator = CreateAdDescriptionCoordinatorImpl(navigationController: nav, mode: .flow)
                    coordinator.start()
                case .photos:
                    let coordinator = CreateAdSelectPhotosCoordinatorImpl(navigationController: nav, mode: .flow)
                    coordinator.start()
                case .video:
                    let coordinator = CreateAdVideoCoordinatorImpl(navigationController: nav, mode: .flow)
                    coordinator.start()
                case .details:
                    let coordinator = CreateAdDetailsCoordinatorImpl(navigationController: nav, mode: .flow)
                    coordinator.start()
                case .price:
                    let coordinator = CreateAdPriceCoordinatorImpl(navigationController: nav, mode: .flow)
                    coordinator.start()
                case .shipping:
                    let coordinator = CreateAdShippingCoordinatorImpl(navigationController: nav, mode: .flow)
                    coordinator.start()
                default: break
                }
                guard let tabs = continueAdDialog.getTabsVC() else { return }
                tabs.present(nav, animated: true, completion: nil)
            }
            return continueAdDialog
        }
    }

    private func showAdSummaryScreen() -> UINavigationController {
        let nav = WhoppahNavigationController()
        nav.isNavigationBarHidden = true
        nav.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
        let coordinator = CreateAdSummaryCoordinatorImpl(navigationController: nav, mode: .flow)
        coordinator.start()

        return nav
    }
}
