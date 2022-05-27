//  
//  AboutWhoppah+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import Foundation

public extension AboutWhoppah.Model {
    static var mock: Self {
        Self(title: "About Whoppah",
             welcomeTitle: "Welcome to the world of Whoppah",
             paragraph1: Lipsum.randomParagraph,
             paragraph2: Lipsum.randomParagraph,
             pressHeadline: "Read more about Whoppah in the media",
             contactTitle: "Contact with Whoppah Support team",
             contactSuggestion: Lipsum.randomParagraph,
             supportEmail: "support@whoppah.com",
             contactOfficeHours: Lipsum.randomParagraph)
    }
}
