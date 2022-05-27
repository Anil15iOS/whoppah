//
//  SearchFilterDismissableButton.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import SwiftUI

struct SearchFilterDismissableButton: View {
    private let label: String
    private let action: () -> Void
    private let foregroundColor = WhoppahTheme.Color.base1
    
    init(label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button { } label: {
            HStack {
                Text(label)
                    .font(WhoppahTheme.Font.h4)
                    .foregroundColor(foregroundColor)
                Image(systemName: "xmark.circle.fill")
                    .colorOverlay(foregroundColor)
                    .frame(width: WhoppahTheme.Size.SearchFilter.plusIconSize,
                           height: WhoppahTheme.Size.SearchFilter.plusIconSize)
            }
            .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
            .padding(.vertical, WhoppahTheme.Size.Padding.small)
            .background(RoundedRectangle(cornerRadius: WhoppahTheme.Size.SearchFilter.buttonCornerRadius)
                .fill(WhoppahTheme.Color.base3))
            .padding(.trailing, WhoppahTheme.Size.Padding.small)
            .padding(.bottom, WhoppahTheme.Size.Padding.small)
        }
        .simultaneousGesture(TapGesture().onEnded({ _ in
            withAnimation {
                action()
            }
        }))
    }
}

struct SearchFilterDismissableButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilterDismissableButton(label: "") {
            
        }
    }
}
