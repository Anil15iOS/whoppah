//
//  PaymentRepositoryImpl.swift
//
//
//  Created by Eddie Long on 11/10/2019.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class PaymentRepositoryImpl: PaymentRepository {
    var paymentInfo: Observable<PaymentViewData> { _paymentInfo }
    private let _paymentInfo = PublishSubject<PaymentViewData>()

    var totals: Observable<PaymentTotals> { _totals.compactMap { $0 } }
    private let _totals = BehaviorSubject<PaymentTotals?>(value: nil)

    private let bag = DisposeBag()
    
    @Injected private var apollo: ApolloService

    func loadOrder(id: UUID) -> Observable<GraphQL.OrderQuery.Data.Order> {
        apollo.fetch(query: GraphQL.OrderQuery(id: id)).compactMap { $0.data?.order }
    }

    func load(id: UUID, bidId: UUID) {
        apollo.fetch(query: GraphQL.ProductQuery(id: id), cache: .fetchIgnoringCacheData)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                if let data = data.data?.product,
                    let auction = data.currentAuction {
                    guard auction.allBids.first(where: { $0.id == bidId }) != nil else {
                        self._paymentInfo.onError(PaymentError.noMatchingBidFound)
                        return
                    }
                    let paymentData = PaymentViewData(productUrl: URL(string: data.thumbnails.first?.url ?? ""),
                                                      productTitle: data.title,
                                                      deliveryMethod: data.deliveryMethod,
                                                      bidId: bidId,
                                                      shippingMethod: data.shipping,
                                                      shippingCost: data.shipping?.pricing,
                                                      customShippingCost: data.customShippingCost,
                                                      originCountry: data.address?.country ?? "NL",
                                                      currency: data.originalPrice?.currency ?? .eur)
                    self._paymentInfo.onNext(paymentData)
                    self._paymentInfo.onCompleted()
                } else {
                    self._paymentInfo.onError(PaymentError.noPaymentFound)
                }
            }, onError: { [weak self] error in
                self?._paymentInfo.onError(error)
            }).disposed(by: bag)
    }

    func loadTotals(input: GraphQL.OrderInput, currency: GraphQL.Currency) {
        let query = GraphQL.GetOrderTotalsQuery(values: input)
        apollo.fetch(query: query)
            .subscribe(onNext: { [weak self] result in
                if let totals = result.data?.getOrderTotals {
                    let totals = PaymentTotals(subtotal: PriceInput(currency: currency, amount: totals.subtotalInclVat),
                                               shipping: PriceInput(currency: currency, amount: totals.shippingInclVat),
                                               paymentCost: PriceInput(currency: currency, amount: totals.paymentInclVat),
                                               discount: PriceInput(currency: currency, amount: totals.discountInclVat),
                                               total: PriceInput(currency: currency, amount: totals.totalInclVat),
                                               buyerProtectionInclVat: PriceInput(currency: currency, amount: totals.buyerProtectionInclVat),
                                               buyerProtectionExclVat: PriceInput(currency: currency, amount: totals.buyerProtectionExclVat))
                    self?._totals.onNext(totals)
                }
            }, onError: { [weak self] error in
                self?._totals.onError(error)
            }).disposed(by: bag)
    }
}
