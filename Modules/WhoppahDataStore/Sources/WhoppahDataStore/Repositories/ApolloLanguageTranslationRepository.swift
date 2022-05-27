//
//  ApolloLanguageTranslationRepository.swift
//  
//
//  Created by Marko Stojkovic on 21.4.22..
//

import Foundation
import Apollo
import Combine
import Resolver
import WhoppahRepository
import WhoppahModel

class ApolloLanguageTranslationRepository: LanguageTranslationRepository {
    @Injected private var apollo: ApolloService
    
    func translate(strings: [String],
                   language: Lang) -> AnyPublisher<TranslationResponse?, Error> {

        let query = GraphQL.TranslateQuery(strings: strings,
                                           lang: language.toGraphQLLang)
        
        return apollo.fetch(query: query,
                            cache: .returnCacheDataAndFetch)
        .tryMap { result -> TranslationResponse in
            guard let translates = result.data?.translate else {
                throw WhoppahRepository.Error.noData
            }
            var translatedTexts: [String] = []
            translates.forEach { translate in
                translatedTexts.append(translate.translatedText)
            }
            
            return WhoppahModel.TranslationResponse(translatedTexts: translatedTexts,
                                                    translationLanguage: language)
        }
        .eraseToAnyPublisher()
    }
}
