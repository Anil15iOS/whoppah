//
//  ThreadMessageRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 25/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol ThreadMessageRepository {
    init(threadId: UUID)

    var paginator: PagedView { get }
    func load(fetchLatest: Bool) -> Observable<Result<[GraphQL.GetMessagesQuery.Data.Message.Item], Error>>
    func touch() -> Observable<Void>
}
