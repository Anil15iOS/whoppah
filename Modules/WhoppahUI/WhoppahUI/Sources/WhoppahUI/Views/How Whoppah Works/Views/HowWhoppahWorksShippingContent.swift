//
//  HowWhoppahWorksShippingContent.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import SwiftUI

struct HowWhoppahWorksShippingContent: View {
    let content: HowWhoppahWorks.Model.CourierAdditionalContent
    
    @Binding var navigationRequest: HowWhoppahWorksDetail.NavigationRequest
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(content.courierOptions, id: \.self) { courierOption in
                ShippingCostSpecification(
                    iconName: courierOption.iconName,
                    title: courierOption.title,
                    subTitle: courierOption.cost,
                    foregroundColor: content.foregroundColor,
                    subTitleColor: content.costLabelColor,
                    backgroundColor: content.backgroundColor)
            }
            if let cta = content.callToAction {
                Spacer().frame(height: 0)
                CallToAction(backgroundColor: cta.backgroundColor,
                             foregroundColor: cta.foregroundColor,
                             iconName: cta.iconName,
                             title: cta.title,
                             showBorder: false)
                {
                    navigationRequest = .bookCourier
                }
            }
        }
    }
}

struct HowWhoppahWorksShippingContent_Previews: PreviewProvider {
    static var previews: some View {
        HowWhoppahWorksShippingContent(
            content: HowWhoppahWorks.Model.CourierAdditionalContent(
                foregroundColor: WhoppahTheme.Color.alert3,
                backgroundColor: WhoppahTheme.Color.base4,
                costLabelColor: WhoppahTheme.Color.base1,
                courierOptions: [
                    HowWhoppahWorks.Model.CourierAdditionalContent.CourierOption(iconName: "shipping_nofill_icon", title: "Up to 2 meters", cost: "€ 79"),
                    HowWhoppahWorks.Model.CourierAdditionalContent.CourierOption(iconName: "shipping_nofill_icon", title: "From 2 meters", cost: "€ 99"),
                    HowWhoppahWorks.Model.CourierAdditionalContent.CourierOption(iconName: "shipping_nofill_icon", title: "Netherlands - Belgium", cost: "€ 129")
                ],
                callToAction: HowWhoppahWorks.Model.CourierAdditionalContent.CallToAction(
                    iconName: "spark_white",
                    backgroundColor: WhoppahTheme.Color.alert3,
                    foregroundColor: WhoppahTheme.Color.base4,
                    title: "Book the courier")
            ),
            navigationRequest: .constant(.none)
            )
    }
}
