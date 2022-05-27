//
//  Checkbox.swift
//  
//
//  Created by Dennis Ippel on 18/01/2022.
//

import SwiftUI

struct Checkbox<Content>: View where Content: View {
    @Binding private var isSelected: Bool
    
    private var content: Content
    
    public init(isSelected: Binding<Bool>,
                @ViewBuilder content: () -> Content) {
        self.content = content()
        self._isSelected = isSelected
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: WhoppahTheme.Size.Checkbox.size,
                       height: WhoppahTheme.Size.Checkbox.size)
                .foregroundColor(WhoppahTheme.Color.alert3)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: WhoppahTheme.Size.Padding.tiny, trailing: WhoppahTheme.Size.Padding.small))
            content
            Spacer()
        }
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox(isSelected: .constant(false)) {}
    }
}
