//
//  SearchCategoryScrollView.swift
//  
//
//  Created by Dennis Ippel on 31/03/2022.
//

import SwiftUI
import WhoppahModel

struct SearchCategoryScrollView: View {
    private let categories: [WhoppahModel.Category]
    private let didSelectCategory: (WhoppahModel.Category) -> Void
    
    init(categories: [WhoppahModel.Category],
         didSelectCategory: @escaping (WhoppahModel.Category) -> Void) {
        self.categories = categories
        self.didSelectCategory = didSelectCategory
    }
    
    var body: some View {
        if !categories.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(categories) { subCategory in
                        if let urlString = subCategory.image?.url,
                           let url = URL(string: urlString) {
                            VStack {
                                AsyncImage(url: url) {
                                    PlaceholderRectangle()
                                        .scaledToFit()
                                } image: { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: WhoppahTheme.Size.Search.categoryThumbnailSize,
                                       height: WhoppahTheme.Size.Search.categoryThumbnailSize)
                                
                                Text(subCategory.localize(\.title))
                                    .font(WhoppahTheme.Font.h4)
                                    .fontWeight(.semibold)
                                    .foregroundColor(WhoppahTheme.Color.base1)
                                    .frame(maxWidth: WhoppahTheme.Size.Search.categoryThumbnailSize)
                            }
                            .onTapGesture {
                                didSelectCategory(subCategory)
                            }
                        }
                    }
                }
                .frame(height: WhoppahTheme.Size.Search.categoryViewHeight)
                .padding(.all, 0)
            }
            .padding(.all, 0)
        }
    }
}

struct SearchCategoryScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCategoryScrollView(categories: [.init(id: UUID(),
                                                 title: "Title",
                                                 slug: "category-test",
                                                 images: [],
                                                 videos: [])]) { _ in }
    }
}
