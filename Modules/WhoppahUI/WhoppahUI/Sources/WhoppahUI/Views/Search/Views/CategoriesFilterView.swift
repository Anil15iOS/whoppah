//
//  CategoriesFilterView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 30/03/2022.
//

import SwiftUI
import WhoppahModel

struct CategoriesFilterView: View {
    typealias SearchResult = SearchView.Model.SearchFacetsSet.SearchResult
    
    @EnvironmentObject var filterSettings: SearchFilterSettings
    
    private let title: String
    private var categories = [SearchResult<WhoppahModel.Category>]()
    
    var categoryOptions: SearchFilterMultiSelectable? {
        filterSettings.category
    }
    
    init(title: String,
         categories: [SearchResult<WhoppahModel.Category>])
    {
        self.title = title
        self.categories = categories
    }
    
    var body: some View {
        VStack {
            if categories.count > 0 {
                CollapsableFilter(title: title) {
                    FlowLayout(mode: .scrollable,
                               binding: .constant(true),
                               items: categories) { category, _ in
                        SearchFilterButton("\(category.value.localize(\.title)) (\(category.count))",
                                           value: category.value,
                                           isSelected: categoryOptions?.contains(category.value) == true,
                                           style: .removable) { selectedCategory in
                            guard let categoryOptions = categoryOptions else { return }

                            if categoryOptions.contains(selectedCategory) {
                                removeCategoryFromSelection(selectedCategory,
                                                            selectedCategories: categoryOptions)
                            } else {
                                categoryOptions.append(selectedCategory)
                            }
                        }
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
    
    private func removeCategoryFromSelection(_ category: WhoppahModel.Category,
                                             selectedCategories: SearchFilterMultiSelectable)
    {
        guard let index = selectedCategories.firstIndex(of: category) else { return }

        let categoryCount = selectedCategories.count
        let numItemsToRemove = categoryCount - index
        selectedCategories.removeLast(numItemsToRemove)
    }
}

struct CategoriesFilterView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesFilterView(title: "Categories",
                             categories: [])
    }
}
