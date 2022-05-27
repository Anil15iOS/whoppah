//
//  WhoppahTheme+Fonts.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/11/2021.
//

import SwiftUI

public extension WhoppahTheme {
    struct Font {
        enum Name: String {
            case poppinsRegular = "Poppins-Regular"
            case poppinsSemiBold = "Poppins-SemiBold"
            case robotoRegular = "Roboto-Regular"
            case robotoBold = "Roboto-Bold"
            case robotoRegularItalic = "Roboto-Italic"
            case robotoMedium = "Roboto-Medium"
        }

        static public let h1 = SwiftUI.Font.custom(Name.poppinsSemiBold.rawValue, size: 36)
        static public let h2 = SwiftUI.Font.custom(Name.poppinsSemiBold.rawValue, size: 24)
        static public let h3 = SwiftUI.Font.custom(Name.poppinsSemiBold.rawValue, size: 16)
        static public let h4 = SwiftUI.Font.custom(Name.poppinsSemiBold.rawValue, size: 14)
        static public let h5 = SwiftUI.Font.custom(Name.poppinsSemiBold.rawValue, size: 12)
        static public let button = SwiftUI.Font.custom(Name.poppinsSemiBold.rawValue, size: 16)
        static public let preformatted = SwiftUI.Font.custom(Name.poppinsSemiBold.rawValue, size: 17)
        static public let paragraph = SwiftUI.Font.custom(Name.robotoRegular.rawValue, size: 17)
        static public let paragraphItalic = SwiftUI.Font.custom(Name.robotoRegularItalic.rawValue, size: 17)
        static public let paragraphBold = SwiftUI.Font.custom(Name.robotoBold.rawValue, size: 18)
        static public let subtitle = SwiftUI.Font.custom(Name.robotoRegular.rawValue, size: 16)
        static public let body = SwiftUI.Font.custom(Name.robotoRegular.rawValue, size: 14)
        static public let bodyBold = SwiftUI.Font.custom(Name.robotoBold.rawValue, size: 16)
        static public let caption = SwiftUI.Font.custom(Name.robotoRegular.rawValue, size: 12)
        static public let helper = SwiftUI.Font.custom(Name.robotoRegular.rawValue, size: 10)
        static public let bodyMedium = SwiftUI.Font.custom(Name.robotoMedium.rawValue, size: 16)
    }
}
