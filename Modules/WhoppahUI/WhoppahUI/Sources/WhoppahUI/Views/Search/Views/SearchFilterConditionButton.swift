//
//  SearchFilterConditionButton.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 24/03/2022.
//

import SwiftUI

struct SearchFilterConditionButton: View {
    private let option: SearchView.Model.Filters.ConditionOption
    private let isSelected: Bool
    private let action: (SearchView.Model.Filters.ConditionOption) -> Void
    private let imageName: String
    
    init(option: SearchView.Model.Filters.ConditionOption,
         isSelected: Bool,
         action: @escaping (SearchView.Model.Filters.ConditionOption) -> Void)
    {
        self.option = option
        self.isSelected = isSelected
        self.action = action
        
        switch option.quality {
        case .good:
            imageName = isSelected ? "condition_good_selected" : "condition_good"
        case .great:
            imageName = isSelected ? "condition_great_selected" : "condition_great"
        case .perfect:
            imageName = isSelected ? "condition_excellent_selected" : "condition_excellent"
        case .unknown:
            imageName = isSelected ? "condition_good_selected" : "condition_good"
        }
    }
    
    var body: some View {
        Button { } label: {
            ZStack {
                RoundedRectangle(cornerRadius: WhoppahTheme.Size.CTA.cornerRadius)
                    .fill(isSelected ? WhoppahTheme.Color.alert3 : WhoppahTheme.Color.base4)
                RoundedRectangle(cornerRadius: WhoppahTheme.Size.CTA.cornerRadius)
                    .stroke(isSelected ? WhoppahTheme.Color.alert3 : WhoppahTheme.Color.base2)
                VStack {
                    Image(imageName, bundle: .module)
                    Text(option.title)
                        .font(WhoppahTheme.Font.body)
                        .foregroundColor(isSelected ? WhoppahTheme.Color.base4 : WhoppahTheme.Color.base2)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .simultaneousGesture(TapGesture().onEnded({ _ in
            action(option)
        }))
    }
}

struct SearchFilterConditionButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilterConditionButton(option: SearchView.Model.Filters.ConditionOption(title: "",
                                                  quality: .great),
                                    isSelected: true) { _ in }
    }
}
