//
//  HowWhoppahWorksSection.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import SwiftUI

struct HowWhoppahWorksSection: View {
    let section: HowWhoppahWorks.Model.Section
    let backgroundColor: Color
    let foregroundColor: Color
    
    @Binding var navigationRequest: HowWhoppahWorksDetail.NavigationRequest
    
    var body: some View {
        ZStack {
            VStack {
                if let headerIconName = section.headerIconName {
                    Image(headerIconName, bundle: .module)
                        .overlay(foregroundColor.blendMode(.lighten))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if let sectionTitle = section.title {
                    Text(sectionTitle)
                        .font(WhoppahTheme.Font.h2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 25)
                } else {
                    Spacer().frame(height: 16)
                }
                if let description = section.description {
                    Text(description)
                        .font(WhoppahTheme.Font.paragraph)
                        .lineSpacing(WhoppahTheme.Size.Paragraph.lineSpacing)
                        .padding(.all, 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                    
                switch section.additionalContent {
                case let content as HowWhoppahWorks.Model.PaymentAdditionalContent:
                    HowWhoppahWorksPaymentContent(content: content)
                case let content as HowWhoppahWorks.Model.PhotoQualityAdditionalContent:
                    HowWhoppahWorksPhotoQualityContent(content: content)
                case let content as HowWhoppahWorks.Model.CourierAdditionalContent:
                    Spacer().frame(height: 32)
                    HowWhoppahWorksShippingContent(content: content, navigationRequest: $navigationRequest)
                case let content as HowWhoppahWorks.Model.FAQAdditionalContent:
                    HowWhoppahWorksFAQContent(content: content)
                default:
                    EmptyView()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 44)
        }
        .background(backgroundColor)
    }
}

struct HowWhoppahWorksSection_Previews: PreviewProvider {
    static var previews: some View {
        let page = HowWhoppahWorks.Model.mock.pages[2]
            HowWhoppahWorksSection(section: page.sections[1],
                                   backgroundColor: page.sectionBackgroundColor,
                                   foregroundColor: page.sectionForegroundColor,
                                   navigationRequest: .constant(.none))
    }
}
