import Foundation
import CoreGraphics
import CoreText
import SwiftUI

public class WhoppahUI {
    public private(set) var text = "Hello, World!"

    public init() {
        Self.registerFonts()
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider)
        else {
            fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
                
        var error: Unmanaged<CFError>?

        CTFontManagerRegisterGraphicsFont(font, &error)
    }
    
    public static func registerFonts() {
        registerFont(bundle: .module, fontName: WhoppahTheme.Font.Name.poppinsRegular.rawValue, fontExtension: "ttf")
        registerFont(bundle: .module, fontName: WhoppahTheme.Font.Name.poppinsSemiBold.rawValue, fontExtension: "ttf")
        registerFont(bundle: .module, fontName: WhoppahTheme.Font.Name.robotoRegular.rawValue, fontExtension: "ttf")
        registerFont(bundle: .module, fontName: WhoppahTheme.Font.Name.robotoRegularItalic.rawValue, fontExtension: "ttf")
        registerFont(bundle: .module, fontName: WhoppahTheme.Font.Name.robotoBold.rawValue, fontExtension: "ttf")
        registerFont(bundle: .module, fontName: WhoppahTheme.Font.Name.robotoMedium.rawValue, fontExtension: "ttf")
    }
}
