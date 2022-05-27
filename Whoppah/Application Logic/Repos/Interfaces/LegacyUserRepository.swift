//
//  LegacyUserRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 02/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

protocol LegacyUserRepository {
    var current: Observable<LegacyMember?> { get }
    func loadCurrentUser()

    func userLoggedOut()
}
