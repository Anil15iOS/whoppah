//
//  TextField+Extensions.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 26/01/2022.
//

import Foundation
import SwiftUI

/// Workaround for an Xcode/iOS bug. See
/// https://whoppah.atlassian.net/browse/WT-459
@available(iOS 15.0, *)
struct TextInputAutoCapitalizationModifier: ViewModifier {
    let disable: Bool
    
    func body(content: Content) -> some View {
        content.textInputAutocapitalization(disable ? .never : .sentences)
    }
}

extension TextField {
    @ViewBuilder func disableAutoCapitalization(_ disable: Bool) -> some View {
        if #available(iOS 15.0, *) {
            self.modifier(TextInputAutoCapitalizationModifier(disable: disable))
        } else {
            self.autocapitalization(disable ? .none : .sentences)
        }
    }
}
