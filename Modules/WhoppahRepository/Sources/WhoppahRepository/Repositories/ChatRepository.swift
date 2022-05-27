//
//  ChatRepository.swift
//  
//
//  Created by Marko Stojkovic on 21.4.22..
//

import Foundation
import Combine
import WhoppahModel

public protocol ChatRepository {
    
    /// Sends a message to a merchant about a product
    ///
    /// - Parameter id The product identifier
    /// - Parameter body The text of the message
    /// - Returns: A publisher with the newly created chat thread id
    func sendProductMessage(id: UUID, body: String) -> AnyPublisher<UUID?, Error>

    /// Gets the thread associated with a given filter key
    ///
    /// - Parameter filter The thread filter
    /// - Parameter id The 'value' or id to use with the filter
    /// - Returns: A publisher with the found thread ID
    func getChatThread(filter: ThreadFilterKey, id: UUID) -> AnyPublisher<UUID?, Error>
}
