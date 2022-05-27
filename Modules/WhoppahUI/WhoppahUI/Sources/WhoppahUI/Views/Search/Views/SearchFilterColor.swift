//
//  SearchFilterColor.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 24/03/2022.
//

import SwiftUI
import WhoppahModel

struct SearchFilterColor: View {
    private let color: WhoppahModel.Color
    private let isSelected: Bool
    private let action: (WhoppahModel.Color) -> Void
    private let checkMarkColor: SwiftUI.Color
    
    init(color: WhoppahModel.Color,
         isSelected: Bool,
         action: @escaping (WhoppahModel.Color) -> Void) {
        self.color = color
        self.isSelected = isSelected
        self.action = action
        self.checkMarkColor = SwiftUI.Color(hex: color.hex).luminance > 0.8 ?
            WhoppahTheme.Color.base1 :
            WhoppahTheme.Color.base4
    }
    
    var body: some View {
        Button {
            
        } label: {
            ZStack {
                if color.slug == "multi-color" {
                    Image("color_select_multi_color", bundle: .module)
                        .resizable()
                        .scaledToFill()
                } else {
                    Circle()
                        .fill(Color(hex: color.hex))
                    Circle()
                        .stroke(WhoppahTheme.Color.base3)
                }
                
                if isSelected {
                    checkMarkColor.mask(
                        Image("color_selection_checkmark", bundle: .module)
                            .resizable()
                            .frame(width: WhoppahTheme.Size.SelectableColor.checkmarkSize,
                                   height: WhoppahTheme.Size.SelectableColor.checkmarkSize)
                    )
                    .frame(width: WhoppahTheme.Size.SelectableColor.checkmarkSize,
                           height: WhoppahTheme.Size.SelectableColor.checkmarkSize)
                }
            }
            .frame(width: WhoppahTheme.Size.SelectableColor.circleSize,
                   height: WhoppahTheme.Size.SelectableColor.circleSize)
            .padding(.all, WhoppahTheme.Size.Padding.tiniest)
        }
        .simultaneousGesture(TapGesture().onEnded({ _ in
            action(color)
        }))
    }
}

struct SearchFilterColor_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilterColor(color: .init(id: UUID(),
                                       title: "",
                                       slug: "",
                                       hex: "#990000"),
                          isSelected: false) { _ in }
    }
}
