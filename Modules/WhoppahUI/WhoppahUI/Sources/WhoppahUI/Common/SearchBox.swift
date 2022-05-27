//
//  SearchBox.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import SwiftUI

struct SearchBox: View {
    @Binding var searchText: String
    
    let backgroundColor: Color
    let foregroundColor: Color
    let placeholderText: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                .fill(backgroundColor)
            RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                .stroke(foregroundColor)
            HStack {
                Image(systemName: "magnifyingglass")
                    .colorOverlay(foregroundColor)
                TextField(placeholderText, text: $searchText.animation())
            }
            .foregroundColor(.gray)
            .padding(.leading, WhoppahTheme.Size.Padding.medium)
        }
        .frame(height: WhoppahTheme.Size.TextInput.height)
    }
}

struct SearchBox_Previews: PreviewProvider {
    static var previews: some View {
        SearchBox(searchText: .constant(""),
                  backgroundColor: WhoppahTheme.Color.base4,
                  foregroundColor: WhoppahTheme.Color.base2,
                  placeholderText: "We are here to help :)")
                  .previewLayout(.fixed(width: 344, height: 58))
    }
}

