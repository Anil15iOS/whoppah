//
//  MagicLinkCharacterTextField.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/02/2022.
//

import Foundation
import SwiftUI

struct MagicLinkCharacterTextField: View {
    var index: Int
    var character: Binding<String>
    var nextCharacter: Binding<String>?
    var focusedField: Binding<Int?>
    var backgroundColor: Color
    var foregroundColor: Color
    var onChange: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                .fill(backgroundColor)
            RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                .stroke(foregroundColor)
            TextField("", text: character)
                .valueChanged(value: character.wrappedValue, onChange: { newValue in
                    guard index == focusedField.wrappedValue else { return }

                    if character.wrappedValue.length > 1 {
                        let trimmedValue = "\(character.wrappedValue.suffix(1))"
                        character.wrappedValue = trimmedValue
                    }
                    
                    let isLastField = index == 5
                    
                    if character.wrappedValue.length == 1 && !isLastField {
                        let nextField = (focusedField.wrappedValue ?? 0) + 1
                        nextCharacter?.wrappedValue = ""
                        focusedField.wrappedValue = nextField
                    }
                    
                    onChange()
                })
                .onTapGesture {
                    character.wrappedValue = ""
                    focusedField.wrappedValue = index
                }
                .id(index)
                .focusedLegacy(focusedField, equals: index)
                .font(WhoppahTheme.Font.paragraph)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .autocapitalization(.allCharacters)
        }
        .frame(height: WhoppahTheme.Size.TextInput.height)
    }
}
