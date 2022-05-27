//
//  CategoryMenuButton.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import SwiftUI
import WhoppahModel

struct CategoryMenuButton: View {
    private let category: WhoppahModel.Category

    public init(category: WhoppahModel.Category) {
        self.category = category
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(category.localize(\.title))
                    .font(WhoppahTheme.Font.h4)
                    .foregroundColor(WhoppahTheme.Color.base1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, WhoppahTheme.Size.Padding.medium)
                
                if let children = category.children, children.count > 0 {
                    Image(systemName: "chevron.right")
                        .padding(.trailing, WhoppahTheme.Size.Padding.medium)
                        .foregroundColor(WhoppahTheme.Color.base1)
                }
            }
            .frame(height: WhoppahTheme.Size.Menu.itemHeight)
            .contentShape(Rectangle())
        }
    }
}

struct CategoryMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoryMenuButton(
            category: WhoppahModel.Category(id: UUID(), title: "Category", slug: "", images: [], videos: []))
            .previewLayout(.fixed(width: 300, height: WhoppahTheme.Size.Menu.itemHeight))
    }
}
