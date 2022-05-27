//
//  LooksRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 25/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

protocol LooksRepository {
    var lookSections: Observable<[LookSection]> { get }
    func loadLooks()
}
