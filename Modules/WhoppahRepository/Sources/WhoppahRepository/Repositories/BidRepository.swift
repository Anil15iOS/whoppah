//
//  BidRepository.swift
//  
//
//  Created by Marko Stojkovic on 12.4.22..
//

import Foundation
import Combine
import WhoppahModel

public protocol BidRepository {
    func get(withId id: UUID) -> AnyPublisher<Bid, Error>
}
