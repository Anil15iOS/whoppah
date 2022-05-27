//
//  MagicLinkCodeInput.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 04/01/2022.
//

import SwiftUI
import Combine
import Focuser

struct MagicLinkCodeInput: View {
    @State private var showErrorMessage: Bool = true
    
    @Binding private var isInputValid: Bool
    @Binding private var inputValue: String
    
    // Ideally we'd have a variable length array here
    // for flexibility. However, there were some issues
    // with @ObservableObject/@Published arrays. No robust
    // solution could be found within the time available.
    // This will do for now but we might have to revisit this
    // in the future.
    @State var character0: String = ""
    @State var character1: String = ""
    @State var character2: String = ""
    @State var character3: String = ""
    @State var character4: String = ""
    @State var character5: String = ""
    
    @FocusStateLegacy var focusedField: Int?
    
    private var backgroundColor: Color
    private var foregroundColor: Color
    private var errorColor: Color
    private let errorMessage: String
    
    init(backgroundColor: Color = WhoppahTheme.Color.base4,
         foregroundColor: Color = WhoppahTheme.Color.base2,
         errorColor: Color = WhoppahTheme.Color.alert1,
         errorMessage: String,
         isInputValid: Binding<Bool>,
         inputValue: Binding<String>)
    {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.errorColor = errorColor
        self.errorMessage = errorMessage
        self._isInputValid = isInputValid
        self._inputValue = inputValue
        self.focusedField = 0
    }
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                MagicLinkCharacterTextField(
                    index: 0,
                    character: $character0,
                    nextCharacter: $character1,
                    focusedField: $focusedField,
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    onChange: validate)
                MagicLinkCharacterTextField(
                    index: 1,
                    character: $character1,
                    nextCharacter: $character2,
                    focusedField: $focusedField,
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    onChange: validate)
                MagicLinkCharacterTextField(
                    index: 2,
                    character: $character2,
                    nextCharacter: $character3,
                    focusedField: $focusedField,
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    onChange: validate)
                MagicLinkCharacterTextField(
                    index: 3,
                    character: $character3,
                    nextCharacter: $character4,
                    focusedField: $focusedField,
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    onChange: validate)
                MagicLinkCharacterTextField(
                    index: 4,
                    character: $character4,
                    nextCharacter: $character5,
                    focusedField: $focusedField,
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    onChange: validate)
                MagicLinkCharacterTextField(
                    index: 5,
                    character: $character5,
                    nextCharacter: nil,
                    focusedField: $focusedField,
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    onChange: validate)
            }
            
            Text(errorMessage)
                .font(WhoppahTheme.Font.helper)
                .foregroundColor(errorColor)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .isHidden(showErrorMessage)
                .transition(.move(edge: .top))
        }
    }
    
    private func validate() {
        let allCharacters = [character0, character1, character2, character3, character4, character5]
        let isValid = !allCharacters.contains { $0.isEmpty }
        
        if showErrorMessage != isValid {
            withAnimation {
                showErrorMessage = isValid
            }
        }
        
        inputValue = allCharacters.joined(separator: "")
        isInputValid = isValid
        
        if isValid {
            UIApplication.shared.closeKeyboard()
        }
    }
}

struct MagicLinkCodeInput_Previews: PreviewProvider {
    static var previews: some View {
        MagicLinkCodeInput(backgroundColor: WhoppahTheme.Color.base4,
                           foregroundColor: WhoppahTheme.Color.base2,
                           errorMessage: "Error",
                           isInputValid: .constant(false),
                           inputValue: .constant(""))
            .previewLayout(.fixed(width: 344, height: 58))
    }
}
