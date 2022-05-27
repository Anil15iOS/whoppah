//
//  ShippingCostSpecification.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import SwiftUI

struct ShippingCostSpecification: View {
    let iconName: String
    let title: String
    let subTitle: String
    let foregroundColor: Color
    let subTitleColor: Color
    let backgroundColor: Color
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ZStack {
                    foregroundColor.frame(width: 78, alignment: .leading)
                    Image(iconName, bundle: .module).colorOverlay(backgroundColor)
                }
                ZStack {
                    backgroundColor.frame(maxWidth: .infinity, alignment: .trailing)
                    VStack {
                        Text(title)
                            .font(WhoppahTheme.Font.button)
                            .foregroundColor(foregroundColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(subTitle)
                            .font(WhoppahTheme.Font.caption)
                            .foregroundColor(subTitleColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.all, 16)
                }
            }
            .mask(RoundedRectangle(cornerRadius: 4))
            RoundedRectangle(cornerRadius: 4)
                .stroke(foregroundColor)                
        }
        .frame(height: 72)
    }
}

struct ShippingCostSpecification_Previews: PreviewProvider {
    static var previews: some View {
        ShippingCostSpecification(
            iconName: "shipping_nofill_icon",
            title: "Up to 2 meters",
            subTitle: "€ 79",
            foregroundColor: WhoppahTheme.Color.alert3,
            subTitleColor: WhoppahTheme.Color.base1,
            backgroundColor: WhoppahTheme.Color.base4)
            .previewLayout(.fixed(width: 312, height: 72))
    }
}
