//
//  Types+GraphQL.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 21/12/2021.
//

import Foundation
import CoreLocation
import WhoppahModel

extension GraphQL.Locale: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Locale {
        switch self {
        case .deAt:         return .deAt
        case .deDe:         return .deDe
        case .enGb:         return .enGb
        case .frBe:         return .frBe
        case .enUs:         return .enUs
        case .frFr:         return .frFr
        case .nlBe:         return .nlBe
        case .nlNl:         return .nlNl
        case .__unknown:    return .unknown
        }
    }
}

extension WhoppahModel.Locale: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.Locale {
        switch self {
        case .deAt:     return .deAt
        case .deDe:     return .deDe
        case .enGb:     return .enGb
        case .frBe:     return .frBe
        case .enUs:     return .enUs
        case .frFr:     return .frFr
        case .nlBe:     return .nlBe
        case .nlNl:     return .nlNl
        case .unknown:  return .__unknown("")
        }
    }
}

extension GraphQL.CalculationMethod: WhoppahModelConvertable {
    var toWhoppahModel: CalculationMethod {
        switch self {
        case .percentage:   return .percentage
        case .fixed:        return .fixed
        case .__unknown:    return .fixed
        }
    }
}

extension GraphQL.MerchantType: WhoppahModelConvertable {
    var toWhoppahModel: MerchantType {
        switch self {
        case .business:     return .business
        case .individual:   return .individual
        case .__unknown:    return .individual
        }
    }
}

extension MerchantType: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.MerchantType {
        switch self {
        case .business:     return .business
        case .individual:   return .individual
        case .unknown:      return .__unknown("")
        }
    }
}

extension GraphQL.Currency: WhoppahModelConvertable {
    var toWhoppahModel: Currency {
        switch(self) {
        case .eur:          return .eur
        case .usd:          return .usd
        case .gbp:          return .gbp
        case .__unknown:    return .eur
        }
    }
}

extension Currency {
  var toGraphQLCurrency: GraphQL.Currency {
    switch(self) {
    case .eur:     return .eur
    case .usd:     return .usd
    case .gbp:     return .gbp
    case .unknown:   return .eur
    }
  }
}

extension LocationInput: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.LocationInput {
        .init(latitude: Double(self.latitude),
              longitude: Double(self.longitude))
    }
}

extension GraphQL.CreateAddressMutation.Data.CreateAddress.Location: WhoppahModelConvertable {
    var toWhoppahModel: Location {
        .init(latitude: self.latitude,
              longitude: self.longitude)
    }
}

extension GraphQL.UpdateAddressMutation.Data.UpdateAddress.Location: WhoppahModelConvertable {
    var toWhoppahModel: CLLocationCoordinate2D {
        .init(latitude: self.latitude,
              longitude: self.longitude)
    }
}

extension GraphQL.GetMeQuery.Data.Me.Merchant.Address.Location {
    init(_ otherLocation: GraphQL.CreateAddressMutation.Data.CreateAddress.Location) {
        self.init(latitude: otherLocation.latitude,
                  longitude: otherLocation.longitude)
    }
}

extension GraphQL.ProductState: WhoppahModelConvertable {
    var toWhoppahModel: ProductState {
        switch self {
        case .archive:      return .archive
        case .accepted:     return .accepted
        case .banned:       return .banned
        case .canceled:     return .canceled
        case .curation:     return .curation
        case .draft:        return .draft
        case .rejected:     return .rejected
        case .updated:      return .updated
        case .__unknown:     return .unknown
        }
    }
}

extension GraphQL.AuctionState: WhoppahModelConvertable {
    var toWhoppahModel: AuctionState {
        switch self {
        case .draft:        return .draft
        case .canceled:     return .canceled
        case .banned:       return .banned
        case .completed:    return .completed
        case .expired:      return .expired
        case .published:    return .published
        case .reserved:     return .reserved
        case .__unknown:    return .unknown
        }
    }
}

extension GraphQL.ImageType: WhoppahModelConvertable {
    var toWhoppahModel: ImageType {
        switch self {
        case .avatar:       return .avatar
        case .cover:        return .cover
        case .default:      return .default
        case .detail:       return .detail
        case .thumbnail:    return .thumbnail
        case .__unknown:    return .unknown
        }
    }
}

extension GraphQL.SearchSort: WhoppahModelConvertable {
    public var toWhoppahModel: WhoppahModel.SearchSort {
        switch self {
        case .created:      return .created
        case .default:      return .default
        case .distance:     return .distance
        case .popularity:   return .popularity
        case .price:        return .price
        case .title:        return .title
        case .__unknown:    return .unknown
        }
    }
}

extension GraphQL.Ordering: WhoppahModelConvertable {
    public var toWhoppahModel: WhoppahModel.Ordering {
        switch self {
        case .asc:          return .asc
        case .desc:         return .desc
        case .rand:         return .rand
        case .__unknown:    return .unknown
        }
    }
}
