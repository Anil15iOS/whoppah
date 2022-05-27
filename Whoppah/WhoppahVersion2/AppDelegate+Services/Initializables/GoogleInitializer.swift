//
//  GoogleInitializer.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleSignIn

struct GoogleInitializer: AppInitializable {
    func didFinishLaunchingApplication() {
        // Google SDK
        GIDSignIn.sharedInstance().clientID = "893420819731-qkc36j46ui5e1si5d51b1iut2ln8fmru.apps.googleusercontent.com"

        // Google Maps
        GMSPlacesClient.provideAPIKey("AIzaSyAqdAWQNgptAZ1xN87Uab-oCzZgQHOtXJI")
    }
}
