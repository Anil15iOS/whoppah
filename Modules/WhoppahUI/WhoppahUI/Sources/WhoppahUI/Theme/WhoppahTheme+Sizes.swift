//
//  File.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import Foundation
import CoreGraphics

public extension WhoppahTheme {
    struct Size {
        struct Padding {
            static let tiniest: CGFloat = 2
            static let tiny: CGFloat = 4
            static let small: CGFloat = 8
            static let smaller: CGFloat = 10
            static let mediumSmall: CGFloat = 12
            static let medium: CGFloat = 16
            static let regularMedium: CGFloat = 20
            static let extraMedium: CGFloat = 24
            static let superMedium: CGFloat = 26
            static let large: CGFloat = 32
            static let extraLarge: CGFloat = 36
            static let larger: CGFloat = 40
            static let superLarge: CGFloat = 55
            static let huge: CGFloat = 90
        }
        
        struct Radius {
            static let smaller: CGFloat = 4
            static let small: CGFloat = 6
            static let medium: CGFloat = 10
            static let regularMedium: CGFloat = 12
            static let extraMedium: CGFloat = 16
            static let large: CGFloat = 25
            static let superLarge: CGFloat = 48
        }
        
        struct Paragraph {
            static let lineSpacing: CGFloat = 5
        }
        
        struct Menu {
            static let itemHeight: CGFloat = 48
            static let leftSideSpacing: CGFloat = 64
            static let maxWidth: CGFloat = 400
        }
        
        struct TextInput {
            static let height: CGFloat = 58
            static let cornerRadius: CGFloat = 3.5
        }
        
        struct Form {
            static let maxWidth: CGFloat = 600
        }
        
        struct ColorView {
            static let width: CGFloat = 24
            static let height: CGFloat = 24
        }
        
        struct Rectangle {
            static let height: CGFloat = 1
            static let paddingSmall: CGFloat = 6
            static let padding: CGFloat = 26
        }
        
        struct CTA {
            static let height: CGFloat = 60
            static let width: CGFloat = 60
            static let smallerHeight: CGFloat = 34
            static let cornerRadius: CGFloat = 6
        }
        
        struct Image {
            static let height: CGFloat = 44
            static let width: CGFloat = 44
        }
        
        struct RoundButton {
            static let height: CGFloat = 32
            static let width: CGFloat = 32
        }
        
        struct ShareButton {
            static let height: CGFloat = 40
            static let width: CGFloat = 40
        }
        
        struct Checkbox {
            static let size: CGFloat = 20
        }
        
        struct ActionSheetButton {
            static let height: CGFloat = 56
        }
        
        struct OverlayView {
            static let height: CGFloat = 72
        }
        
        struct HeroImage {
            static let height: CGFloat = 375
        }
        
        struct NewProductItem {
            static let height: CGFloat = 234
            static let width: CGFloat = 160
        }
        
        struct NewProductItemImage {
            static let height: CGFloat = 150
            static let width: CGFloat = 160
        }
        
        struct NavBar {
            static let height: CGFloat = 100
            static let backButtonSize: CGFloat = 12
        }
        
        struct GridItem {
            static let minimumSize: CGFloat = 150
            static let maximumSize: CGFloat = 300
            static let minimumSizeIPad: CGFloat = 200
            static let maximumSizeIPad: CGFloat = 400
            static let aspectRatio: CGFloat = 0.7
            static let labelIconSize: CGFloat = 15
            static let labelCornerRadius: CGFloat = 16
            static let likeButtonSize: CGFloat = 24
        }
        
        struct SearchFilter {
            static let buttonCornerRadius: CGFloat = 20
            static let plusIconSize: CGFloat = 10
            static let maxWidth: CGFloat = 450
        }
        
        struct Search {
            static let noResultsIconSize: CGFloat = 30
            static let categoryThumbnailSize: CGFloat = 120
            static let categoryViewHeight: CGFloat = 160
        }
        
        struct SelectableColor {
            static let circleSize: CGFloat = 42
            static let checkmarkSize: CGFloat = 14
        }
        
        struct NumericStepper {
            static let width: CGFloat = 160
            static let height: CGFloat = 54
            static let cornerRadius: CGFloat = 5
        }
    }
}
