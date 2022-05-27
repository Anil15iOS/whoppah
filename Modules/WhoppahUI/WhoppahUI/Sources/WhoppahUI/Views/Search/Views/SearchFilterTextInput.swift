//
//  SearchFilterTextInput.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 24/03/2022.
//

import SwiftUI

struct SearchFilterTextInput: View {
    private let placeholderText: String
    @Binding private var value: String
    
    init(placeholderText: String,
         value: Binding<String>)
    {
        self.placeholderText = placeholderText
        self._value = value
    }
    
    var body: some View {
        EmptyView()
        ZStack {
            RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                .fill(WhoppahTheme.Color.base4)
            RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                .stroke(WhoppahTheme.Color.base2)
            TextField(placeholderText,
                      text: $value)
            .frame(maxWidth: .infinity)
            .padding(.leading, WhoppahTheme.Size.Padding.medium)
        }
        .frame(height: WhoppahTheme.Size.TextInput.height)
    }
}

struct SearchFilterTextInput_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilterTextInput(placeholderText: "Placeholder",
                              value: .constant(""))
    }
}
