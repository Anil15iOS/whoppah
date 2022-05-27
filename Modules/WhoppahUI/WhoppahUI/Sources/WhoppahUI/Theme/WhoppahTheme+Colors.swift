//
//  WhoppahTheme+Colors.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/11/2021.
//

import SwiftUI

public extension WhoppahTheme {
    struct Color: Equatable {
        static public let primary1 = SwiftUI.Color("Primary1", bundle: .module)
        static public let primary2 = SwiftUI.Color("Primary2", bundle: .module)
        static public let primary3 = SwiftUI.Color("Primary3", bundle: .module)
        static public let primary4 = SwiftUI.Color("Primary4", bundle: .module)

        static public let secondary1 = SwiftUI.Color("Secondary1", bundle: .module)
        static public let secondary2 = SwiftUI.Color("Secondary2", bundle: .module)
        static public let secondary3 = SwiftUI.Color("Secondary3", bundle: .module)

        static public let support1 = SwiftUI.Color("Support1", bundle: .module)
        static public let support2 = SwiftUI.Color("Support2", bundle: .module)
        static public let support3 = SwiftUI.Color("Support3", bundle: .module)
        static public let support4 = SwiftUI.Color("Support4", bundle: .module)
        static public let support5 = SwiftUI.Color("Support5", bundle: .module)
        static public let support6 = SwiftUI.Color("Support6", bundle: .module)
        static public let support7 = SwiftUI.Color("Support7", bundle: .module)
        static public let support8 = SwiftUI.Color("Support8", bundle: .module)
        
        static public let alert1 = SwiftUI.Color("Alert1", bundle: .module)
        static public let alert2 = SwiftUI.Color("Alert2", bundle: .module)
        static public let alert3 = SwiftUI.Color("Alert3", bundle: .module)
        
        static public let base1 = SwiftUI.Color("Base1", bundle: .module)
        static public let base2 = SwiftUI.Color("Base2", bundle: .module)
        static public let base3 = SwiftUI.Color("Base3", bundle: .module)
        static public let base4 = SwiftUI.Color("Base4", bundle: .module)
        static public let base5 = SwiftUI.Color("Base5", bundle: .module)
        static public let base6 = SwiftUI.Color("Base6", bundle: .module)
        static public let base7 = SwiftUI.Color("Base7", bundle: .module)
        static public let base8 = SwiftUI.Color("Base8", bundle: .module)
        static public let base9 = SwiftUI.Color("Base9", bundle: .module)
        static public let base10 = SwiftUI.Color("Base10", bundle: .module)
        static public let base11 = SwiftUI.Color("Base11", bundle: .module)
        static public let base12 = SwiftUI.Color("Base12", bundle: .module)
        
        static public let border1 = SwiftUI.Color("Border1", bundle: .module)

        static public let dropShadow = SwiftUI.Color.black.opacity(0.15)
        
        struct BuyerProtection {
            static public let border = SwiftUI.Color("BuyerProtectionBorder", bundle: .module)
            static public let background = SwiftUI.Color("BuyerProtectionBackground", bundle: .module)
            static public let foreground = SwiftUI.Color("BuyerProtectionForeground", bundle: .module)
            static public let buttonBackground = SwiftUI.Color("Alert2", bundle: .module)
            static public let buttonForeground = SwiftUI.Color("Base4", bundle: .module)
            
            struct Enabled {
                static public let background = SwiftUI.Color("BuyerProtectionEnabledBackground", bundle: .module)
                static public let wave1 = SwiftUI.Color("BuyerProtectionEnabledWave1", bundle: .module)
                static public let wave2 = SwiftUI.Color("BuyerProtectionEnabledWave2", bundle: .module)
            }
            
            struct Disabled {
                static public let background = SwiftUI.Color("BuyerProtectionDisabledBackground", bundle: .module)
                static public let wave1 = SwiftUI.Color("BuyerProtectionDisabledWave1", bundle: .module)
                static public let wave2 = SwiftUI.Color("BuyerProtectionDisabledWave2", bundle: .module)
            }
        }
    }
}
