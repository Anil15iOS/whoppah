//
//  MenuButton.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import SwiftUI

struct MenuButton: View {
    private var title: String
    private let action: () -> Void
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                action()
            } label: {
                Text(title)
                    .font(WhoppahTheme.Font.h4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, WhoppahTheme.Size.Padding.medium)
                    .foregroundColor(WhoppahTheme.Color.base1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: WhoppahTheme.Size.Menu.itemHeight)
        .frame(maxWidth: .infinity)
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(title: "Menu Button") {}
    }
}
