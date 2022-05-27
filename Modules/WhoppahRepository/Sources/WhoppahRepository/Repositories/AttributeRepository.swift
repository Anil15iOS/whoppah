//
//  AttributeRepository.swift
//  WhoppahRepository
//
//  Created by Dennis Ippel on 23/03/2022.
//

import Foundation
import Combine
import WhoppahModel

public protocol AttributeRepository {
    func fetchSearchAttribute(_ attributeType: AttributeType) -> AnyPublisher<AbstractAttribute, Error>
    func fetchSearchAttributes(_ attributeType: AttributeType) -> AnyPublisher<[AbstractAttribute], Error>
}
