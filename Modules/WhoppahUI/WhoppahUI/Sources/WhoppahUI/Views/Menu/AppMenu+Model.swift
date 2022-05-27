//
//  AppMenu+Model.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import Foundation

public extension AppMenu {
    struct Model: Equatable {
        let title: String
        let contact: String
        let myProfile: String
        let chatsBidding: String
        let howWhoppahWorks: String
        let aboutWhoppah: String
        let whoppahReviews: String
        let storeAndSell: String
        
        public init(title: String,
                    contact: String,
                    myProfile: String,
                    chatsBidding: String,
                    howWhoppahWorks: String,
                    aboutWhoppah: String,
                    whoppahReviews: String,
                    storeAndSell: String)
        {
            self.title = title
            self.contact = contact
            self.myProfile = myProfile
            self.chatsBidding = chatsBidding
            self.howWhoppahWorks = howWhoppahWorks
            self.aboutWhoppah = aboutWhoppah
            self.whoppahReviews = whoppahReviews
            self.storeAndSell = storeAndSell
        }
        
        static var initial = Self(title: "Menu",
                                  contact: "Contact",
                                  myProfile: "My Profile",
                                  chatsBidding: "Chats & Bidding",
                                  howWhoppahWorks: "How Whoppah works",
                                  aboutWhoppah: "About Whoppah",
                                  whoppahReviews: "Whoppah reviews",
                                  storeAndSell: "Store and sell")
    }
}
