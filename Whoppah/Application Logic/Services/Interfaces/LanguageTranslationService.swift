//
//  LanguageTranslationService.swift
//  Whoppah
//
//  Created by Levon Hovsepyan on 23.06.21.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import Apollo
import RxSwift
import WhoppahDataStore

protocol LanguageTranslationService {
    func translate(strings: [String], language: GraphQL.Lang) -> Observable<LegacyTranslationResponse?>
}
