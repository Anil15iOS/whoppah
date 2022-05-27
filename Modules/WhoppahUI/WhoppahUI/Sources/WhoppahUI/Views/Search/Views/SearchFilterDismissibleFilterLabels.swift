//
//  SearchFilterDismissibleFilterLabels.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 06/04/2022.
//

import SwiftUI

struct SearchFilterDismissibleFilterLabels: View {
    @EnvironmentObject private var filterSettings: SearchFilterSettings
    
    private let filtersModel: SearchView.Model.Filters
    
    init(filtersModel: SearchView.Model.Filters) {
        self.filtersModel = filtersModel
    }
    
    var body: some View {
        if filterSettings.hasActiveFilters {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(filterSettings.searchFilterSelection.searchFilters, id: \.filterId) { filterable in
                        if var singleSelectable = filterable as? SearchFiltering & SearchFilterSingleSelectable,
                            singleSelectable.isActiveFilter
                        {
                            SearchFilterDismissableButton(label: singleSelectable.filterLabel) {
                                singleSelectable.reset()
                            }
                        } else if let multiSelectable = filterable as? SearchFiltering & SearchFilterMultiSelectable,
                                  multiSelectable.isActiveFilter
                        {
                            ForEach(multiSelectable.items, id: \.filterId) { searchFilter in
                                SearchFilterDismissableButton(label: searchFilter.filterLabel) {
                                    multiSelectable.remove(searchFilter)
                                }
                            }
                        }
                    }
                }
                .padding(.all, 0)
            }
            .padding(.all, 0)
        }
    }
}

struct SearchFilterDismissibleFilterLabels_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilterDismissibleFilterLabels(filtersModel: .initial)
    }
}
