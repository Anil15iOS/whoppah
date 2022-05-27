//
//  ShippingMethodsRepository.swift
//  WhoppahRepository
//
//  Created by Dennis Ippel on 01/05/2022.
//

import Foundation
import WhoppahModel
import Combine

public protocol ShippingMethodsRepository {
    func shippingMethods(from originCountry: WhoppahModel.Country?, to destinationCountry: WhoppahModel.Country?) -> AnyPublisher<[ShippingMethod], Error>
}
