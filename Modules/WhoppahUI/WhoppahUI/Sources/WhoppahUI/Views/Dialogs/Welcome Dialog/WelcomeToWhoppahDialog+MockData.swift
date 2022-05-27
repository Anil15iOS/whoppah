//  
//  WelcomeToWhoppahDialog+MockData.swift
//  
//
//  Created by Dennis Ippel on 15/02/2022.
//

import Foundation

public extension WelcomeToWhoppahDialogModel {
    static var mock: WelcomeToWhoppahDialog.NewUserModel {
        return WelcomeToWhoppahDialog.NewUserModel(title: "Welcome to Whoppah!",
                                                   description: "Start now with selling and buying the most beautiful design, lamps and art.",
                                                   createAdButtonTitle: "Create your first ad",
                                                   discoverDesignButtonTitle: "Discover the latest design")
    }
}
