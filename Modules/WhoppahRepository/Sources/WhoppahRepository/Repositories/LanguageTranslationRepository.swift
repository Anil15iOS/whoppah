//
//  LanguageTranslationRepository.swift
//  
//
//  Created by Marko Stojkovic on 21.4.22..
//

import Foundation
import Combine
import WhoppahModel

public protocol LanguageTranslationRepository {
    func translate(strings: [String],
                   language: Lang) -> AnyPublisher<TranslationResponse?, Error>
}
