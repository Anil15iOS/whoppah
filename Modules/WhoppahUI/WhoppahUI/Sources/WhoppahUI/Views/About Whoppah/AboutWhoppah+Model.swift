//  
//  AboutWhoppah+Model.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import Foundation

public extension AboutWhoppah {
    struct Model: Equatable {
        let title: String
        let welcomeTitle: String
        let paragraph1: String
        let paragraph2: String
        let pressHeadline: String
        let contactTitle: String
        let contactSuggestion: String
        let supportEmail: String
        let contactOfficeHours: String

        public init(title: String,
                    welcomeTitle: String,
                    paragraph1: String,
                    paragraph2: String,
                    pressHeadline: String,
                    contactTitle: String,
                    contactSuggestion: String,
                    supportEmail: String,
                    contactOfficeHours: String) {
            self.title = title
            self.welcomeTitle = welcomeTitle
            self.paragraph1 = paragraph1
            self.paragraph2 = paragraph2
            self.pressHeadline = pressHeadline
            self.contactTitle = contactTitle
            self.contactSuggestion = contactSuggestion
            self.supportEmail = supportEmail
            self.contactOfficeHours = contactOfficeHours
        }
        
        static var initial = Self(title: "",
                                  welcomeTitle: "",
                                  paragraph1: "",
                                  paragraph2: "",
                                  pressHeadline: "",
                                  contactTitle: "",
                                  contactSuggestion: "",
                                  supportEmail: "",
                                  contactOfficeHours: "")
    }
}
