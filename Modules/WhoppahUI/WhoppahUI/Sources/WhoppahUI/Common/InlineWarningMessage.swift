//
//  InlineWarningMessage.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import SwiftUI

struct InlineWarningMessage: View {
    enum Icon: String {
        case alert = "alert_icon"
        case information = "information_icon"
    }
    
    private let icon: Icon
    private let backgroundColor: Color
    private let foregroundColor: Color
    
    private let message: String
    private let ctaText: String?
    
    private let didTapCTA: (() -> Void)?
    
    init(icon: Icon,
         message: String,
         ctaText: String? = nil,
         backgroundColor: Color = WhoppahTheme.Color.support1,
         foregroundColor: Color = WhoppahTheme.Color.alert1,
         didTapCTA: (() -> Void)? = nil)
    {
        self.icon = icon
        self.message = message
        self.ctaText = ctaText
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.didTapCTA = didTapCTA
    }
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                Image(icon.rawValue, bundle: .module)
                
                if let ctaText = ctaText, let didTapCTA = didTapCTA {
                    VStack(alignment: .leading) {
                        Text(message)
                            .font(WhoppahTheme.Font.body)
                            .foregroundColor(WhoppahTheme.Color.base1)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button(ctaText, action: didTapCTA)
                            .font(WhoppahTheme.Font.body)
                            .foregroundColor(foregroundColor)
                    }
                } else {
                    Text(message)
                        .font(WhoppahTheme.Font.body)
                        .foregroundColor(foregroundColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.all, WhoppahTheme.Size.Padding.medium)
            .background(RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                                        .fill(backgroundColor))
        }
    }
}

struct InlineWarningMessage_Previews: PreviewProvider {
    static var previews: some View {
        InlineWarningMessage(icon: .alert, message: "Warning!")
    }
}
