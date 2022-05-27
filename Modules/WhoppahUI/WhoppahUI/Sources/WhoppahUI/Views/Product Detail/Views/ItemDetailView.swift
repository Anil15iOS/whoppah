//
//  ItemDetailView.swift
//  
//
//  Created by Marko Stojkovic on 16.3.22..
//

import SwiftUI

struct ItemDetailView: View {
    let item: String
    let itemValues: String
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 0) {
            Rectangle()
                .fill(WhoppahTheme.Color.support7)
                .frame(height: WhoppahTheme.Size.Rectangle.height)
                .padding(.bottom, WhoppahTheme.Size.Rectangle.paddingSmall)
            HStack {
                Text(item)
                    .font(WhoppahTheme.Font.subtitle)
                    .foregroundColor(WhoppahTheme.Color.base1)
                Spacer()
                Text(itemValues)
                    .font(WhoppahTheme.Font.subtitle)
                    .foregroundColor(WhoppahTheme.Color.base1)
            }
            .padding(.bottom, WhoppahTheme.Size.Rectangle.paddingSmall)
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: "Style", itemValues: "Vintage")
    }
}
