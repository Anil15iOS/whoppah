//
//  LanguageTranslationServiceImp.swift
//  Whoppah
//
//  Created by Levon Hovsepyan on 23.06.21.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import Apollo
import RxSwift
import Resolver
import WhoppahDataStore

enum SupportedLanguages: String {
    
    case nl = "NL"
    case en = "EN"
    case fr = "FR"
    case de = "DE"
    case es = "ES"
    
    var displayName: String {
        switch self {
        case .nl:
            return "Dutch"
        case .en:
            return "English"
        case .fr:
            return "French"
        case .de:
            return "German"
        case .es:
            return "Spanish"
        }
    }
    
    static var all: [SupportedLanguages] {
        return [.en, .nl, .fr, .de, .es]
    }
}

struct LegacyTranslationResponse {
    var translatedTexts: [String]
    var translationLanguage: GraphQL.Lang
}

class LanguageTranslationServiceImp: LanguageTranslationService {
    
    @Injected private var apollo: ApolloService

    func translate(strings: [String], language: GraphQL.Lang) -> Observable<LegacyTranslationResponse?> {

        let query = GraphQL.TranslateQuery(strings: strings, lang: language)
        return apollo.fetch(query: query).map({ item in
            
            var translatedTexts: [String] = []
            item.data!.translate.forEach { translation in
                translatedTexts.append(translation.translatedText)
            }
            return LegacyTranslationResponse(translatedTexts: translatedTexts, translationLanguage: language)
        })
    }
    
}
