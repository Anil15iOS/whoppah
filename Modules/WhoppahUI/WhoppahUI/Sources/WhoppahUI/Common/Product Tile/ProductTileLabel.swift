//
//  ProductTileLabel.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/03/2022.
//

import SwiftUI
import WhoppahModel

struct ProductTileLabel: View {
    let label: WhoppahModel.Label
    
    private func labelColor(_ hex: String) -> SwiftUI.Color {
        SwiftUI.Color(hex: hex).luminance > 0.8 ?
                        WhoppahTheme.Color.base1 :
                        WhoppahTheme.Color.base4
    }

    var body: some View {
        HStack {
            Spacer()
            
            HStack {
                if let _ = UIImage(named: label.slug, in: .module, with: nil) {
                    labelColor(label.localize(\.hex!)).mask(
                        Image(label.slug, bundle: .module)
                        )
                    .frame(width: WhoppahTheme.Size.GridItem.labelIconSize,
                           height: WhoppahTheme.Size.GridItem.labelIconSize)
                }
                Text(label.localize(\.title).uppercased())
                    .font(WhoppahTheme.Font.h5)
                    .foregroundColor(labelColor(label.localize(\.hex!)))
            }
            .padding(.horizontal, WhoppahTheme.Size.Padding.small)
            .padding(.vertical, WhoppahTheme.Size.Padding.tiny)
            .background(RoundedRectangle(cornerRadius: WhoppahTheme.Size.GridItem.labelCornerRadius)
                .fill(Color(hex: label.localize(\.hex!))))
        }
    }
}

struct ProductTileLabel_Previews: PreviewProvider {
    static var previews: some View {
        ProductTileLabel(label: .init(id: UUID(),
                                           title: "Label",
                                           description: "",
                                           slug: "slug",
                                           hex: "#990000"))
    }
}
