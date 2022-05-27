//
//  HowWhoppahWorksPaymentContent.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import SwiftUI

struct HowWhoppahWorksPaymentContent: View {
    let content: HowWhoppahWorks.Model.PaymentAdditionalContent
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 32)
            Image(content.heroLogoName,
                  bundle: .module)
                .resizable()
                .colorOverlay(Color(hex: "#5D5FEF"))
                .scaledToFit()
                .frame(height: 27, alignment: .leading)
            Spacer().frame(height: 16)
            HStack {
                ForEach(content.paymentLogoNames, id: \.self) { logoName in
                    Image(logoName, bundle: .module)
                    if logoName != content.paymentLogoNames.last {
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct HowWhoppahWorksPaymentFooter_Previews: PreviewProvider {
    static var previews: some View {
        HowWhoppahWorksPaymentContent(
            content: HowWhoppahWorks.Model.PaymentAdditionalContent(
                heroLogoName: "stripe_logo",
                paymentLogoNames: [
                    "ideal_logo",
                    "bancontact_logo",
                    "visa_logo",
                    "mastercard_logo",
                    "maestro_logo",
                    "american_express_logo",
                    "apple_pay_logo"
                ]
            ))
    }
}
