//
//  TextInputWithValidation.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import Combine
import SwiftUI

class ValidationTrigger: ObservableObject {
    @Published var trigger: Bool = false
}

struct TextInputWithValidation: View {
    @ObservedObject private var validationTrigger = ValidationTrigger()
    
    @State private var text = ""
    @State private var errorMessage: String = ""
    @State private var showErrorMessage: Bool = false
    
    @Binding private var isInputValid: Bool
    @Binding private var inputValue: String
    
    private var isSecureField: Bool
    private var disableAutoCorrection: Bool
    private var disableAutoCapitalization: Bool
    private var validateOnChange: Bool
    private var backgroundColor: Color
    private var foregroundColor: Color
    private var errorColor: Color
    private var placeholderText: String
    private var validators = [TextInputValidatable]()
    private var formatters = [TextInputFormattable]()
    private var contextualLabel: String?
    
    init(backgroundColor: Color = WhoppahTheme.Color.base4,
         foregroundColor: Color = WhoppahTheme.Color.base2,
         errorColor: Color = WhoppahTheme.Color.alert1,
         placeholderText: String = "",
         isSecureField: Bool = false,
         disableAutoCorrection: Bool = false,
         disableAutoCapitalization: Bool = false,
         validateOnChange: Bool = false,
         validators: [TextInputValidatable] = [],
         formatters: [TextInputFormattable] = [],
         isInputValid: Binding<Bool>,
         inputValue: Binding<String>,
         contextualLabel: String? = nil)
    {
        self.placeholderText = placeholderText
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.errorColor = errorColor
        self.isSecureField = isSecureField
        self.disableAutoCorrection = disableAutoCorrection
        self.disableAutoCapitalization = disableAutoCapitalization
        self.validateOnChange = validateOnChange
        self.validators = validators
        self.formatters = formatters
        self._isInputValid = isInputValid
        self._inputValue = inputValue
        self.contextualLabel = contextualLabel
    }
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                    .fill(backgroundColor)
                RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                    .stroke(foregroundColor)
                HStack {
                    if let contextualLabel = contextualLabel {
                        Text(contextualLabel)
                            .font(WhoppahTheme.Font.paragraph)
                            .foregroundColor(WhoppahTheme.Color.base1)
                    }
                    if isSecureField {
                        SecureField(placeholderText, text: $text) {
                            guard !validateOnChange else { return }
                            validate(text)
                            inputValue = text
                        }
                        .font(WhoppahTheme.Font.paragraph)
                        .valueChanged(value: text) { newValue in
                            guard validateOnChange else { return }
                            validate(newValue)
                            inputValue = newValue
                        }
                    } else {
                        TextField(placeholderText, text: $text) { beganEditing in
                            guard !beganEditing else { return }
                            validate(text)
                            format(text)
                            inputValue = text
                        }
                        .disableAutoCapitalization(disableAutoCapitalization)
                        .font(WhoppahTheme.Font.paragraph)
                        .valueChanged(value: text) { newValue in
                            guard validateOnChange else { return }
                            validate(newValue)
                            format(newValue)
                            inputValue = newValue
                        }
                        .disableAutocorrection(disableAutoCorrection)
                    }
                }
                .foregroundColor(.gray)
                .padding(.leading, WhoppahTheme.Size.Padding.medium)
            }
            .frame(height: WhoppahTheme.Size.TextInput.height)
            
            Text(errorMessage)
                .font(WhoppahTheme.Font.helper)
                .foregroundColor(errorColor)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .isHidden(!showErrorMessage)
                .transition(.move(edge: .top))
        }
        .onReceive(validationTrigger.objectWillChange) { _ in
            validate(text)
        }
    }
    
    func validate() {
        validationTrigger.trigger.toggle()
    }
    
    private func validate(_ value: String) {
        var isValid = true
        
        inputValue = value

        validators.forEach { validator in
            if !validator.isValid(value) {
                errorMessage = validator.failedMessage
                isValid = false
                return
            }
        }
        
        if isValid {
            errorMessage = ""
        }
        
        withAnimation {
            showErrorMessage = !isValid
        }

        isInputValid = isValid
    }
    
    private func format(_ value: String) {
        var formattedValue = value
        
        formatters.forEach { formatter in
            formattedValue = formatter.format(formattedValue)
        }
        
        if formattedValue != value {
            text = formattedValue
        }
    }
}

struct TextInputWithValidation_Previews: PreviewProvider {
    static var previews: some View {
        TextInputWithValidation(backgroundColor: WhoppahTheme.Color.base4,
                                foregroundColor: WhoppahTheme.Color.base2,
                                placeholderText: "We are here to help :)",
                                isSecureField: false,
                                isInputValid: .constant(false),
                                inputValue: .constant(""))
                                .previewLayout(.fixed(width: 344, height: 58))
    }
}
