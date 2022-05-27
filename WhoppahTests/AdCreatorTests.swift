//
//  AdCreatorTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 07/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import Resolver

struct MockImage: WhoppahCore.Image {
    var id = UUID()
    var url = "https://google.com"
}

@testable import Testing_Debug
@testable import WhoppahCore

private struct MockCategoryAttribute: WhoppahCore.Category {
    var id = UUID()
    var title = ""
    let slug: String
    var ancestor: WhoppahCore.Category?
    var children = [WhoppahCore.Category]()
    var image = [Image]()
    var detailImages = [Image]()
    var description: String? = nil
}

private struct MockBrandAttribute: BrandAttribute {
    var id = UUID()
    var title = ""
    let slug: String
    var description: String? = nil
}

private struct MockArtistAttribute: Artist {
    var id = UUID()
    var title = ""
    let slug: String
    var description: String? = nil
}

private struct MockMaterialAttribute: Material {
    var id = UUID()
    var title = ""
    let slug: String
    var description: String? = nil
}

private struct MockColor: Color {
    var id = UUID()
    var title = "color"
    var hex = "#FF0000"
    let slug: String
    var description: String? = nil
}

private struct MockShippingMethod: ShippingMethod {
    var id = UUID()
    var slug = "slug"
    var pricing: WhoppahCore.Price = PriceInput(currency: .eur, amount: 10)
}

class AdCreatorTests: XCTestCase {
    override class func setUp() {
        MockServiceInjector.register()
    }
    
    func testDefaults() {
        let creator: ADCreator = ADCreatorImpl()
        Resolver.register { creator }
        guard case .none = creator.mode else { XCTFail(); return }
    }

    func testAdCreation() {
        let creator = ADCreatorImpl()
        creator.startCreating()
        XCTAssertNotNil(creator.template)

        guard case .create(let data) = creator.mode else { XCTFail(); return }
        XCTAssertNil(data)

        creator.cancelCreating()
        guard case .none = creator.mode else { XCTFail(); return }
    }

    func testAdEditing() {
        let creator: ADCreator = ADCreatorImpl()
        Resolver.register { creator }
        let template = AdTemplate()
        creator.startEditing(template)
        XCTAssertNotNil(creator.template)

        guard case .edit = creator.mode else { XCTFail(); return }

        creator.cancelCreating()
        guard case .none = creator.mode else { XCTFail(); return }
    }

    func testAdValidationDescriptionStep() {
        let creator: ADCreator = ADCreatorImpl()
        // given
        Resolver.register { creator }
        creator.startCreating()

        // when
        var descrStep = creator.validate(step: .all)
        // then - expect missing title validation
        if case .description(let reason) = descrStep {
            XCTAssertEqual(reason, .title)
        } else {
            XCTFail()
            return
        }

        // when
        descrStep = creator.validate(step: .description)
        // then - expect missing title validation
        if case .description(let reason) = descrStep {
            XCTAssertEqual(reason, .title)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.title = "Test"

        // when
        descrStep = creator.validate(step: .description)
        // then - expect missing description validation
        if case .description(let reason) = descrStep {
            XCTAssertEqual(reason, .description)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.description = "My Descr"

        // when
        descrStep = creator.validate(step: .description)
        // then - expect no issue with description
        guard case .none = descrStep else { XCTFail(); return }

        // when
        descrStep = creator.validate(step: .all)
        // then - expect issue with photos (next step)
        guard case .photos = descrStep else { XCTFail(); return }
    }

    func testAdValidationPhotosStep() throws {
        let creator: ADCreator = ADCreatorImpl()
        // given
        Resolver.register { creator }
        creator.startCreating()
        creator.template?.title = "Test"
        creator.template?.description = "My Descr"

        // when
        var photoStep = creator.validate(step: .all)
        // then - expect missing title validation
        guard case .photos = photoStep else { XCTFail(); return }

        // given
        creator.template?.images = [MockImage].init(repeating: MockImage(), count: ProductConfig.minNumberImages)

        // then - expect no issue with photos
        photoStep = creator.validate(step: .photos)
        guard case .none = photoStep else { XCTFail(); return }

        photoStep = creator.validate(step: .all)
        guard case .details = photoStep else { XCTFail(); return }

        // given
        creator.template?.images = []
        for _ in 0..<ProductConfig.minNumberImages {
            creator.mediaManager.addPhoto(AdPhoto.new(data: UIImage(color: .red)!))
        }

        // then - expect no issue with photos
        photoStep = creator.validate(step: .photos)
        guard case .none = photoStep else { XCTFail(); return }

        creator.mediaManager.clearAllMedia()
        photoStep = creator.validate(step: .photos)
        guard case .photos = photoStep else { XCTFail(); return }

        let mediaCacheService: MediaCacheService = Resolver.resolve()
        let mediaCache = try XCTUnwrap(mediaCacheService as? MockMediaCacheService)
        
        let redImage = UIImage(color: .red)!
        mediaCache.fetchImage = redImage
        mediaCache.cacheKey = "something-draft"
        for _ in 0..<ProductConfig.minNumberImages {
            creator.mediaManager.addPhoto(AdPhoto.new(data: redImage))
        }

        photoStep = creator.validate(step: .photos)
        guard case .none = photoStep else { XCTFail(); return }
    }

    func testAdValidationDetailsBrandStep() {
        let creator: ADCreator = ADCreatorImpl()
        // given
        Resolver.register { creator }
        creator.startCreating()
        creator.template?.title = "Test"
        creator.template?.description = "My Descr"
        creator.template?.images = [MockImage].init(repeating: MockImage(), count: ProductConfig.minNumberImages)

        // when
        var detailsStep = creator.validate(step: .all)
        // then - expect missing title validation
        if case .details(let reason) = detailsStep {
            XCTAssertEqual(reason, .quality)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.brand = nil
        creator.template?.artists = [MockArtistAttribute(slug: "artist1")]

        // when
        detailsStep = creator.validate(step: .details)

        // then expect missing material
        if case .details(let reason) = detailsStep {
            XCTAssertEqual(reason, .quality)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.brand = MockBrandAttribute(slug: "brand1")

        // when
        detailsStep = creator.validate(step: .details)

        // then expect missing material
        if case .details(let reason) = detailsStep {
            XCTAssertEqual(reason, .quality)
        } else {
            XCTFail()
            return
        }
    }

    func testAdValidationDetailsMaterialQualityDimensionColorStep() {
        let creator: ADCreator = ADCreatorImpl()
        // given
        Resolver.register { creator }
        creator.startCreating()
        creator.template?.title = "Test"
        creator.template?.description = "My Descr"
        creator.template?.images = [MockImage].init(repeating: MockImage(), count: ProductConfig.minNumberImages)
        creator.template?.categories = [MockCategoryAttribute(slug: "home")]
        creator.template?.brand = MockBrandAttribute(slug: "brand1")

        // when
        var detailsStep = creator.validate(step: .details)

        // then expect missing material
        if case .details(let reason) = detailsStep {
            XCTAssertEqual(reason, .quality)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.quality = .good

        // when
        detailsStep = creator.validate(step: .details)

        // then expect missing dimensions
        if case .details(let reason) = detailsStep {
            XCTAssertEqual(reason, .dimensions)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.width = 100

        // when
        detailsStep = creator.validate(step: .details)

        // then expect missing dimensions
        if case .details(let reason) = detailsStep {
            XCTAssertEqual(reason, .colors)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.width = nil
        creator.template?.height = 100

        // when
        detailsStep = creator.validate(step: .details)

        // then expect missing dimensions
        if case .details(let reason) = detailsStep {
            XCTAssertEqual(reason, .colors)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.height = nil
        creator.template?.depth = 100

        // when
        detailsStep = creator.validate(step: .details)

        // then expect missing dimensions
        if case .details(let reason) = detailsStep {
            XCTAssertEqual(reason, .colors)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.colors = [MockColor(slug: "red")]

        // when
        detailsStep = creator.validate(step: .details)

        guard case .none = detailsStep else { XCTFail(); return }
    }

    func testAdValidationPriceStep() {
        let creator: ADCreator = ADCreatorImpl()
        // given
        Resolver.register { creator }
        creator.startCreating()
        creator.template?.title = "Test"
        creator.template?.description = "My Descr"
        creator.template?.images = [MockImage].init(repeating: MockImage(), count: ProductConfig.minNumberImages)
        creator.template?.categories = [MockCategoryAttribute(slug: "home")]
        creator.template?.brand = MockBrandAttribute(slug: "brand1")
        creator.template?.materials = [MockMaterialAttribute(slug: "lovely-mat")]
        creator.template?.quality = .good
        creator.template?.depth = 100
        creator.template?.colors = [MockColor(slug: "red")]

        // when
        var priceStep = creator.validate(step: .price)

        // then expect bad asking price
        if case .price(let reason) = priceStep {
            XCTAssertEqual(reason, .asking)
        } else {
            XCTFail()
            return
        }

        // given - too low
        creator.template?.price = PriceInput(currency: .eur, amount: ProductConfig.minimumPrice - 1.0)

        // when
        priceStep = creator.validate(step: .price)

        // then expect bad asking price
        if case .price(let reason) = priceStep {
            XCTAssertEqual(reason, .asking)
        } else {
            XCTFail()
            return
        }

        // given - valid price
        creator.template?.price = PriceInput(currency: .eur, amount: ProductConfig.minimumPrice * 100)

        // when
        priceStep = creator.validate(step: .price)

        // then expect bad asking price
        if case .price(let reason) = priceStep {
            XCTAssertEqual(reason, .minBid)
        } else {
            XCTFail()
            return
        }

        // given - bidding enabled without min bid (allowed)
        creator.template?.settings = ProductSettingsInput(allowBidding: true, allowBuyNow: true)

        // when
        priceStep = creator.validate(step: .price)

        // then expect bad asking price as no min bid is set
        if case .price(let reason) = priceStep {
            XCTAssertEqual(reason, .minBid)
        } else {
            XCTFail()
            return
        }

        // given - too low min bid value
        let price = creator.template!.price!.amount
        creator.template?.settings = ProductSettingsInput(allowBidding: true, allowBuyNow: true, minBid: PriceInput(currency: .eur, amount: price * ProductConfig.minimumBidLowestPercentage - 1))

        // when
        priceStep = creator.validate(step: .price)

        // then expect bad asking price
        if case .price(let reason) = priceStep {
            XCTAssertEqual(reason, .minBid)
        } else {
            XCTFail()
            return
        }

        // given - too high min bid value
        creator.template?.settings = ProductSettingsInput(allowBidding: true, allowBuyNow: true, minBid: PriceInput(currency: .eur, amount: ProductConfig.minimumPrice * 200))

        // then expect bad asking price
        if case .price(let reason) = priceStep {
            XCTAssertEqual(reason, .minBid)
        } else {
            XCTFail()
            return
        }

        // given - too high min bid value
        creator.template?.settings = ProductSettingsInput(allowBidding: true, allowBuyNow: true, minBid: PriceInput(currency: .eur, amount: ProductConfig.minimumPrice * 20))

        // when
        priceStep = creator.validate(step: .price)

        // then all good
        guard case .none = priceStep else { XCTFail(); return }
    }

    func testAdValidationShippingStep() {
        let creator: ADCreator = ADCreatorImpl()
        // given
        Resolver.register { creator }
        creator.startCreating()
        creator.template?.title = "Test"
        creator.template?.description = "My Descr"
        creator.template?.images = [MockImage].init(repeating: MockImage(), count: ProductConfig.minNumberImages)
        creator.template?.categories = [MockCategoryAttribute(slug: "home")]
        creator.template?.brand = MockBrandAttribute(slug: "brand1")
        creator.template?.materials = [MockMaterialAttribute(slug: "lovely-mat")]
        creator.template?.quality = .good
        creator.template?.depth = 100
        creator.template?.colors = [MockColor(slug: "red")]
        creator.template?.price = PriceInput(currency: .eur, amount: ProductConfig.minimumPrice * 100)
        creator.template?.settings = ProductSettingsInput(allowBidding: true, allowBuyNow: true, minBid: PriceInput(currency: .eur, amount: ProductConfig.minimumPrice * 20))

        // when
        var shippingStep = creator.validate(step: .all)

        // then expect missing address
        if case .shipping(let reason) = shippingStep {
            XCTAssertEqual(reason, .method)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.delivery = .delivery

        // when
        shippingStep = creator.validate(step: .shipping)

        // then expect missing address
        if case .shipping(let reason) = shippingStep {
            XCTAssertEqual(reason, .address)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.delivery = .delivery
        creator.template?.location = mockAddress

        // when
        shippingStep = creator.validate(step: .shipping)

        // then expect missing shipping method
        if case .shipping(let reason) = shippingStep {
            XCTAssertEqual(reason, .shipping)
        } else {
            XCTFail()
            return
        }

        // given
        creator.template?.location = mockAddress
        creator.template?.delivery = .pickup

        // when
        shippingStep = creator.validate(step: .shipping)

        // then expect no issue - no need for shipping
        guard case .none = shippingStep else {
            XCTFail()
            return
        }

        // given
        creator.template?.shippingMethod = ShippingMethodInput(method: MockShippingMethod(), price: nil)
        creator.template?.location = mockAddress
        creator.template?.delivery = .pickupDelivery

        // when
        shippingStep = creator.validate(step: .shipping)

        // then expect missing address
        guard case .none = shippingStep else {
            XCTFail()
            return
        }

        // when
        let finalAdCheck = creator.validate(step: .all)

        // then expect missing address
        guard case .none = finalAdCheck else {
            XCTFail()
            return
        }
    }
}
