//
//  DimensionsFilterView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/04/2022.
//

import SwiftUI
import WhoppahModel

struct DimensionsFilterView: View {
    @EnvironmentObject var filterSettings: SearchFilterSettings
    
    private let filtersModel: SearchView.Model.Filters

    init(filtersModel: SearchView.Model.Filters) {
        self.filtersModel = filtersModel
    }
    
    var body: some View {
        if let widthFilter: SearchFilter<SearchFilterMinMaxValue> = filterSettings.width,
           let heightFilter: SearchFilter<SearchFilterMinMaxValue> = filterSettings.height,
           let depthFilter: SearchFilter<SearchFilterMinMaxValue> = filterSettings.depth
        {
            VStack {
                
                //
                // 📐 Width
                //
                
                Text(filtersModel.widthTitle)
                    .font(WhoppahTheme.Font.caption)
                    .foregroundColor(WhoppahTheme.Color.base1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: WhoppahTheme.Size.Padding.medium) {
                    SearchFilterTextInput(placeholderText: filtersModel.minPlaceholder,
                                          value: .init(get: { widthFilter.value.min },
                                                       set: { widthFilter.value.min = $0 }))
                    .keyboardType(.numberPad)
                    
                    SearchFilterTextInput(placeholderText: filtersModel.maxPlaceholder,
                                          value: .init(get: { widthFilter.value.max },
                                                       set: { widthFilter.value.max = $0 }))
                    .keyboardType(.numberPad)
                }
                .padding(.bottom, WhoppahTheme.Size.Padding.tiny)
                
                //
                // 📐 Height
                //
                
                Text(filtersModel.heightTitle)
                    .font(WhoppahTheme.Font.caption)
                    .foregroundColor(WhoppahTheme.Color.base1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: WhoppahTheme.Size.Padding.medium) {
                    SearchFilterTextInput(placeholderText: filtersModel.minPlaceholder,
                                          value: .init(get: { heightFilter.value.min },
                                                       set: { heightFilter.value.min = $0 }))
                    .keyboardType(.numberPad)
                    
                    SearchFilterTextInput(placeholderText: filtersModel.maxPlaceholder,
                                          value: .init(get: { heightFilter.value.max },
                                                       set: { heightFilter.value.max = $0 }))
                    .keyboardType(.numberPad)
                }
                .padding(.bottom, WhoppahTheme.Size.Padding.tiny)

                //
                // 📐 Depth
                //
                
                Text(filtersModel.depthTitle)
                    .font(WhoppahTheme.Font.caption)
                    .foregroundColor(WhoppahTheme.Color.base1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: WhoppahTheme.Size.Padding.medium) {
                    SearchFilterTextInput(placeholderText: filtersModel.minPlaceholder,
                                          value: .init(get: { depthFilter.value.min },
                                                       set: { depthFilter.value.min = $0 }))
                    .keyboardType(.numberPad)
                    
                    SearchFilterTextInput(placeholderText: filtersModel.maxPlaceholder,
                                          value: .init(get: { depthFilter.value.max },
                                                       set: { depthFilter.value.max = $0 }))
                    .keyboardType(.numberPad)
                }
                .padding(.bottom, WhoppahTheme.Size.Padding.tiny)
            }
        } else {
            EmptyView()
        }
    }
}

struct DimensionsFilterView_Previews: PreviewProvider {
    static var previews: some View {
        DimensionsFilterView(filtersModel: .initial)
    }
}
