//
//  ApolloAttributeRepository.swift
//  
//
//  Created by Dennis Ippel on 23/03/2022.
//

import Foundation
import WhoppahRepository
import WhoppahModel
import Resolver
import Combine
import Apollo

struct ApolloAttributeRepository: AttributeRepository {
    @Injected private var apollo: ApolloService
    
    func fetchSearchAttribute(_ attributeType: AttributeType) -> AnyPublisher<AbstractAttribute, Error> {
        let query = GraphQL.GetAttributeQuery(key: .type, value: attributeType.rawValue.uppercased())
        return apollo
            .fetch(query: query, cache: .returnCacheDataAndFetch)
            .tryMap { result in
                guard let attributeByKey = result.data?.attributeByKey else {
                    throw WhoppahRepository.Error.noData
                }
                return try convertAttribute(attributeByKey: attributeByKey, type: attributeType)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSearchAttributes(_ attributeType: AttributeType) -> AnyPublisher<[AbstractAttribute], Error> {
        let query = GraphQL.GetAttributesQuery(key: .type, value: attributeType.rawValue.uppercased())
        return apollo
            .fetch(query: query, cache: .returnCacheDataAndFetch)
            .tryMap { result -> [AbstractAttribute] in
                guard let attributesByKey = result.data?.attributesByKey else {
                    throw WhoppahRepository.Error.noData
                }
                return try attributesByKey.map { try self.convertAttribute(attributesByKey: $0, type: attributeType) }
            }
            .eraseToAnyPublisher()
    }
    
    private func convertAttribute(attributesByKey: GraphQL.GetAttributesQuery.Data.AttributesByKey? = nil,
                                  attributeByKey: GraphQL.GetAttributeQuery.Data.AttributeByKey? = nil,
                                  type: AttributeType) throws -> AbstractAttribute
    {
        switch type {
        case .material:
            guard let material =
                    attributesByKey?.asMaterial?.toWhoppahModel ??
                    attributeByKey?.asMaterial?.toWhoppahModel
            else { throw WhoppahRepositoryError.conversionError }
            return material
        case .artist:
            guard let artist =
                    attributesByKey?.asArtist?.toWhoppahModel ??
                    attributeByKey?.asArtist?.toWhoppahModel
            else { throw WhoppahRepositoryError.conversionError }
            return artist
        case .brand:
            guard let brand =
                    attributesByKey?.asBrand?.toWhoppahModel ??
                    attributeByKey?.asBrand?.toWhoppahModel
            else { throw WhoppahRepositoryError.conversionError }
            return brand
        case .color:
            guard let color =
                    attributesByKey?.asColor?.toWhoppahModel ??
                    attributeByKey?.asColor?.toWhoppahModel
            else { throw WhoppahRepositoryError.conversionError }
            return color
        case .designer:
            guard let designer =
                    attributesByKey?.asDesigner?.toWhoppahModel ??
                    attributeByKey?.asDesigner?.toWhoppahModel
            else { throw WhoppahRepositoryError.conversionError }
            return designer
        case .label:
            guard let label =
                    attributesByKey?.asLabel?.toWhoppahModel ??
                    attributeByKey?.asLabel?.toWhoppahModel
            else { throw WhoppahRepositoryError.conversionError }
            return label
        case .style:
            guard let style =
                    attributesByKey?.asStyle?.toWhoppahModel ??
                    attributeByKey?.asStyle?.toWhoppahModel
            else { throw WhoppahRepositoryError.conversionError }
            return style
        case .additionalInfo:
            throw WhoppahRepositoryError.conversionError
        case .subject:
            throw WhoppahRepositoryError.conversionError
        case .usageSign:
            throw WhoppahRepositoryError.conversionError
        case .unknown:
            throw WhoppahRepositoryError.conversionError
            // We should handle all cases and never handle default because we
            // want a compile time error if any new attributes are added to the backend.
        }
    }
}
