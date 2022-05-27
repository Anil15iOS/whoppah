//
//  WhoppahUIApp.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/11/2021.
//

import SwiftUI
import UIKit
import WhoppahUI

@main
struct WhoppahUIIntegrationTestApp: App {
    init() {
        WhoppahUI.registerFonts()
        WhoppahUI.registerMockLocalizers()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
