//
//  Picker+Extensions.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 15/02/2022.
//

import SwiftUI

extension Picker {
    @ViewBuilder func reduceSizeIfApplicable() -> some View {
        if #available(iOS 15.0, *) {
            self.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, WhoppahTheme.Size.Padding.medium)
        } else {
            self.frame(height: WhoppahTheme.Size.TextInput.height)
                .mask(RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
