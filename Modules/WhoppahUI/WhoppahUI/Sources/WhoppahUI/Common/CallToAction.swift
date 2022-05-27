//
//  CallToAction.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import SwiftUI

struct CallToAction: View {
    let backgroundColor: Color
    let foregroundColor: Color
    let iconName: String?
    let title: String
    let showBorder: Bool
    let showChevron: Bool
    let buttonFont: Font
    let height: Double
    @Binding var showingProgress: Bool
    let action: () -> Void
    
    init(backgroundColor: Color,
         foregroundColor: Color,
         iconName: String? = nil,
         title: String,
         showBorder: Bool,
         showChevron: Bool = false,
         buttonFont: Font? = nil,
         height: Double = WhoppahTheme.Size.CTA.height,
         showingProgress: Binding<Bool> = .constant(false),
         action: @escaping () -> Void) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.iconName = iconName
        self.title = title
        self.showBorder = showBorder
        self.showChevron = showChevron
        self.buttonFont = buttonFont ?? WhoppahTheme.Font.button
        self._showingProgress = showingProgress
        self.action = action
        self.height = height
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: WhoppahTheme.Size.CTA.cornerRadius)
                    .fill(backgroundColor)
                if showBorder {
                    RoundedRectangle(cornerRadius: WhoppahTheme.Size.CTA.cornerRadius)
                        .stroke(foregroundColor)
                }
                if showingProgress {
                    ActivityIndicator(isAnimating: .constant(true),
                                      style: .medium,
                                      color: foregroundColor)
                } else {
                    HStack(spacing: 10) {
                        if let iconName = iconName {
                            Image(iconName,
                                  bundle: .module)
                            .frame(alignment: .center)
                        }
                        Text(title)
                            .foregroundColor(foregroundColor)
                            .font(self.buttonFont)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(alignment: .center)
                            .multilineTextAlignment(.center)
                        
                        if showChevron {
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .frame(alignment: .center)
                        }
                    }
                    .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                }
            }
            .frame(height: height)
        }
    }
}

struct CallToAction_Previews: PreviewProvider {
    static var previews: some View {
        CallToAction(backgroundColor: WhoppahTheme.Color.primary1,
                     foregroundColor: WhoppahTheme.Color.base4,
                     iconName: "camera_icon",
                     title: "Call to action",
                     showBorder: true,
                     showingProgress: .constant(false)) {}
            .previewLayout(.fixed(width: 340, height: 60))
    }
}
