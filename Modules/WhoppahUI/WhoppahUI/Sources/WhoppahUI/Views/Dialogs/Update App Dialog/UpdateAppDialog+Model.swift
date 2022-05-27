//
//  UpdateAppDialog+Model.swift
//  
//
//  Created by Dennis Ippel on 16/11/2021.
//

import Foundation

public extension UpdateAppDialog {
    struct Model: Equatable {
        let title: String
        let description: String
        let ctaTitle: String
        
        public static var initial = Self(title: "There is a new update available!",
                                  description: "Make sure to update your app to enjoy the latest functionalities and for a smooth experience.",
                                  ctaTitle: "Update your app now")
        
        public init(title: String,
                    description: String,
                    ctaTitle: String)
        {
            self.title = title
            self.description = description
            self.ctaTitle = ctaTitle
        }
    }
}
