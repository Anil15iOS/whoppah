//
//  ChatService.swift
//  Whoppah
//
//  Created by Eddie Long on 07/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxCocoa
import RxSwift
import WhoppahDataStore

public enum ThreadFilterKey {
    case thread
    case item
}

public protocol ChatService {
    /// Sends a chat message to a given thread
    ///
    /// - Parameter id The thread identifier
    /// - Parameter text The text of the chat message
    /// - Returns: An observable with the newly created chat message
    func sendChatMessage(id: UUID, text: String) -> Observable<GraphQL.SendMessageMutation.Data.SendMessage>

    /// Sends a message to a merchant about a product
    ///
    /// - Parameter id The product identifier
    /// - Parameter body The text of the message
    /// - Returns: An observable with the newly created chat thread id
    func sendProductMessage(id: UUID, body: String) -> Observable<UUID?>

    /// Gets the thread associated with a given filter key
    ///
    /// - Parameter filter The thread filter
    /// - Parameter id The 'value' or id to use with the filter
    /// - Returns: An observable with the found thread ID
    func getChatThread(filter: ThreadFilterKey, id: UUID) -> Observable<UUID?>

    /// The current unread count of threads + messages
    var unread: Driver<Int> { get }

    /// Fetch the latest thread + message unread count from the server
    func updateUnreadCount()
}
