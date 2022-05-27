//
//  TranslationResponse.swift
//  
//
//  Created by Marko Stojkovic on 21.4.22..
//

import Foundation

public struct TranslationResponse: Equatable {
    public let translatedTexts: [String]
    public let translationLanguage: Lang
    
    public init(translatedTexts: [String],
                translationLanguage: Lang)
    {
        self.translatedTexts = translatedTexts
        self.translationLanguage = translationLanguage
    }
}
