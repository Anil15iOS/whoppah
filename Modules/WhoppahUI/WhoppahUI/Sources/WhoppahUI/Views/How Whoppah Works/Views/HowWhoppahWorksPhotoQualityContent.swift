//
//  HowWhoppahWorksPhotoQualityContent.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import SwiftUI

struct HowWhoppahWorksPhotoQualityContent: View {
    let content: HowWhoppahWorks.Model.PhotoQualityAdditionalContent
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 24)
            CallToAction(backgroundColor: content.ctaBackgroundColor,
                         foregroundColor: content.ctaForegroundColor,
                         iconName: content.ctaIconName,
                         title: content.ctaTitle,
                         showBorder: false) {
                print("CTA clicked")
            }
        }
    }
}

struct HowWhoppahWorksPhotoQualityFooter_Previews: PreviewProvider {
    static var previews: some View {
        HowWhoppahWorksPhotoQualityContent(
            content: HowWhoppahWorks.Model.PhotoQualityAdditionalContent(
                ctaIconName: "camera_icon",
                ctaBackgroundColor: WhoppahTheme.Color.primary1,
                ctaForegroundColor: WhoppahTheme.Color.base4,
                ctaTitle: "Read our photo guide"))
            .previewLayout(.fixed(width: 340, height: 84))
    }
}
