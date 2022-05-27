//
//  SearchFilterButton.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/03/2022.
//

import SwiftUI

struct SearchFilterButton<T>: View {
    enum Style {
        case plain
        case multiSelect
        case removable
        case alwaysSelected
    }
    
    private let title: String
    private let action: (T) -> Void
    private let value: T
    private let isSelected: Bool
    private let style: Style
    private let foregroundColor: Color
    
    init(_ title: String,
         value: T,
         isSelected: Bool,
         style: Style = .plain,
         action: @escaping (T) -> Void) {
        self.title = title
        self.value = value
        self.action = action
        self.style = style
        self.isSelected = isSelected || style == .alwaysSelected
        self.foregroundColor = isSelected ? WhoppahTheme.Color.base4 : WhoppahTheme.Color.base1
    }
    
    var body: some View {

        Button { } label: {
            HStack {
                Text(title)
                    .font(WhoppahTheme.Font.h4)
                    .foregroundColor(foregroundColor)
                if style == .multiSelect {
                    foregroundColor
                        .mask(Image(isSelected ? "search_filter_minus_icon" : "search_filter_plus_icon",
                                    bundle: .module))
                        .frame(width: WhoppahTheme.Size.SearchFilter.plusIconSize,
                               height: WhoppahTheme.Size.SearchFilter.plusIconSize)
                } else if style == .removable && isSelected {
                    foregroundColor
                        .mask(Image(systemName: "xmark"))
                        .frame(width: WhoppahTheme.Size.SearchFilter.plusIconSize,
                               height: WhoppahTheme.Size.SearchFilter.plusIconSize)
                }
            }
            .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
            .padding(.vertical, WhoppahTheme.Size.Padding.small)
            .background(RoundedRectangle(cornerRadius: WhoppahTheme.Size.SearchFilter.buttonCornerRadius)
                .fill(isSelected ? WhoppahTheme.Color.base1 : WhoppahTheme.Color.base3))
            .padding(.trailing, WhoppahTheme.Size.Padding.small)
            .padding(.bottom, WhoppahTheme.Size.Padding.small)
        }
        .simultaneousGesture(TapGesture().onEnded({ _ in
            guard style != .alwaysSelected else { return }
            withAnimation {
                action(value)
            }
        }))
    }
}

struct SearchFilterButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilterButton("Title", value: "", isSelected: false) { value in
            
        }
    }
}
