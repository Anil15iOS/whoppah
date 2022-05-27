//
//  WhoppahUI+ProductDetailsClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/04/2022.
//

import Foundation
import WhoppahModel
import ComposableArchitecture

public extension WhoppahUI {
    struct ProductDetailsClient {
        public typealias FetchProductClosure = (UUID) -> Effect<Product, Error>
        public typealias FetchProductBySlugClosure = (String) -> Effect<Product, Error>
        public typealias FetchRelatedItemsClosure = (String) -> Effect<[ProductTileItem], Error>
        public typealias FetchReviewsClosure = (UUID) -> Effect<[ProductReview], Error>
        public typealias SendProductMessageClosure = (UUID, String) -> Effect<UUID?, Error>
        public typealias CreateBidClosure = (WhoppahModel.Product, WhoppahModel.Price, Bool) -> Effect<WhoppahModel.Bid, Error>
        public typealias TranslateClosure = (String, WhoppahModel.Lang) -> Effect<String, Error>
        public typealias ReportAbuseClosure = (AbuseReportInput) -> Effect<Bool, Error>
        
        var fetchProduct: FetchProductClosure
        var fetchProductBySlug: FetchProductBySlugClosure
        var fetchRelatedItems: FetchRelatedItemsClosure
        var fetchReviews: FetchReviewsClosure
        var sendProductMessage: SendProductMessageClosure
        var createBid: CreateBidClosure
        var translate: TranslateClosure
        var reportAbuse: ReportAbuseClosure
        
        public init(fetchProduct: @escaping FetchProductClosure,
                    fetchProductBySlug: @escaping FetchProductBySlugClosure,
                    fetchRelatedItems: @escaping FetchRelatedItemsClosure,
                    fetchReviews: @escaping FetchReviewsClosure,
                    sendProductMessage: @escaping SendProductMessageClosure,
                    createBid: @escaping CreateBidClosure,
                    translate: @escaping TranslateClosure,
                    reportAbuse: @escaping ReportAbuseClosure)
        {
            self.fetchProduct = fetchProduct
            self.fetchProductBySlug = fetchProductBySlug
            self.fetchRelatedItems = fetchRelatedItems
            self.fetchReviews = fetchReviews
            self.sendProductMessage = sendProductMessage
            self.createBid = createBid
            self.translate = translate
            self.reportAbuse = reportAbuse
        }
    }
}
