//
//  BidRepository.swift
//  WhoppahCore
//
//  Created by Eddie Long on 12/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahDataStore

public protocol BidRepository {
    func get(_ id: UUID) -> Observable<GraphQL.GetBidQuery.Data.Bid>
}
