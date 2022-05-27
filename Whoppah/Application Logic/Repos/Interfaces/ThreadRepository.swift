//
//  ThreadRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 01/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol ThreadRepository {
    var thread: Observable<GraphQL.GetThreadQuery.Data.Thread?> { get }
    func fetchThread(id: UUID)
}
