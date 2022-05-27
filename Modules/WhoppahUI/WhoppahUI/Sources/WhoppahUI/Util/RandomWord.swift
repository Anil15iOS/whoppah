//
//  RandomWord.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/03/2022.
//

import Foundation

struct RandomWord {
    static func randomWords(_ wordCount: ClosedRange<Int>,
                            wordLength: ClosedRange<Int> = 3...8) -> String {
        var words = ""
        for i in 0...Int.random(in: wordCount) {
            words += Self.generate(Int.random(in: wordLength))
            if i < wordCount.upperBound - 1 {
                words += " "
            }
        }
        return words
    }
    
    static func generate(_ length: Int) -> String {
        let consonants = "bcdfghjlmnpqrstv"
        let vowels = "aeiou"
        
        var word = ""
        
        for i in 0..<length / 2 {
            let randomConsonantIndex = Int.random(in: 0..<consonants.count)
            let randomConsonant = consonants[randomConsonantIndex]
            let randomVowelIndex = Int.random(in: 0..<vowels.count)
            let randomVowel = vowels[randomVowelIndex]
            word += i == 0 ? randomConsonant.uppercased() : randomConsonant
            word += i * 2 < length - 1 ? randomVowel : ""
        }
        
        return word
    }
}
