//  
//  WelcomeToWhoppahDialog+Model.swift
//  
//
//  Created by Dennis Ippel on 15/02/2022.
//

import Foundation
import SwiftUI

public protocol WelcomeToWhoppahDialogModel {
    var title: String { get set }
    var description: String { get set }
    var createAdButtonTitle: String { get set }
    var discoverDesignButtonTitle: String { get set }
}

func == (lhs: WelcomeToWhoppahDialogModel, rhs: WelcomeToWhoppahDialogModel) -> Bool {
    return type(of: lhs) == type(of: rhs)
}

public extension WelcomeToWhoppahDialog {
    struct NewUserModel: WelcomeToWhoppahDialogModel {
        public var title: String
        public var description: String
        public var createAdButtonTitle: String
        public var discoverDesignButtonTitle: String

        public init(title: String,
                    description: String,
                    createAdButtonTitle: String,
                    discoverDesignButtonTitle: String)
        {
            self.title = title
            self.description = description
            self.createAdButtonTitle = createAdButtonTitle
            self.discoverDesignButtonTitle = discoverDesignButtonTitle
        }
        
        static var initial = Self(title: "",
                                  description: "",
                                  createAdButtonTitle: "",
                                  discoverDesignButtonTitle: "")
    }
    
    struct ExistingSocialUserModel: WelcomeToWhoppahDialogModel {
        public var title: String
        public var description: String = ""
        public var createAdButtonTitle: String
        public var discoverDesignButtonTitle: String
        
        public let descriptionWithEmail: (String) -> String

        public init(title: String,
                    descriptionWithEmail: @escaping (String) -> String,
                    createAdButtonTitle: String,
                    discoverDesignButtonTitle: String)
        {
            self.title = title
            self.descriptionWithEmail = descriptionWithEmail
            self.createAdButtonTitle = createAdButtonTitle
            self.discoverDesignButtonTitle = discoverDesignButtonTitle
        }
        
        static var initial = Self(title: "",
                                  descriptionWithEmail: { _ in return "" },
                                  createAdButtonTitle: "",
                                  discoverDesignButtonTitle: "")
    }
}
