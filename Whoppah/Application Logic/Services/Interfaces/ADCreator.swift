//
//  ADCreator.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

enum AdCreationResult {
    case curation
    case created
    case edited
}

enum AdCreationMode {
    case create(data: GraphQL.CreateProductMutation.Data.CreateProduct?)
    case edit
    case none
}

enum AdDescriptionError {
    case title
    case description
}

enum AdDetailsError {
    case brandOrArtist
    case material
    case quality
    case dimensions
    case colors
}

enum PriceError {
    case asking
    case minBid
}

enum ShippingError {
    case address
    case method
    case shipping
}

enum AdValidationError {
    case none
    case description(reason: AdDescriptionError)
    case photos
    case video
    case details(reason: AdDetailsError)
    case price(reason: PriceError)
    case shipping(reason: ShippingError)
}

enum AdValidationSequenceStep {
    case description
    case photos
    case video
    case details
    case price
    case shipping
    case all
}

protocol ADCreator {
    // MARK: - Properties

    var template: AdTemplate? { get }
    var mediaManager: AdMediaManager! { get }

    var mode: AdCreationMode { get }

    // MARK: -

    func startCreating()
    func startEditing(_ template: AdTemplate)

    func saveDraft() -> Observable<AdCreationResult>
    func finish() -> Observable<AdCreationResult>

    func cancelPendingUploads()
    func cancelCreating()

    func validate(step: AdValidationSequenceStep?) -> AdValidationError
}
