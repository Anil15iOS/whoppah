//
//  AbuseReportInput+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 04/05/2022.
//

import Foundation
import WhoppahModel

extension WhoppahModel.AbuseReportType: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.AbuseReportType {
        switch self {
        case .product:  return .product
        case .user:     return .user
        case .unknown:  return .__unknown("")
        }
    }
}

extension WhoppahModel.AbuseReportReason: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.AbuseReportReason {
        switch self {
        case .poorPhotoQuality:     return .poorPhotoQuality
        case .violatingContent:     return .violatingContent
        case .spam:                 return .spam
        case .wrongCategory:        return .wrongCategory
        case .unknown:              return .__unknown("")
        }
    }
}

extension WhoppahModel.AbuseReportInput: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.AbuseReportInput {
        .init(id: self.id,
              type: self.type.toGraphQLModel,
              reason: self.reason.toGraphQLModel,
              description: self.description)
    }
}
