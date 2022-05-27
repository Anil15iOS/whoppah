//
//  CheckoutBuyerProtection.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 11/05/2022.
//

import SwiftUI

public struct CheckoutBuyerProtection: View {
    // Temporary because this view integrates with an old
    // storyboard view.
    public struct Model {
        let title: String
        let description: String
        let listItems: [String]
        let switchEnabledTitle: String
        let switchDisabledTitle: String
        
        public init(title: String,
                    description: String,
                    listItems: [String],
                    switchEnabledTitle: String,
                    switchDisabledTitle: String)
        {
            self.title = title
            self.description = description
            self.listItems = listItems
            self.switchEnabledTitle = switchEnabledTitle
            self.switchDisabledTitle = switchDisabledTitle
        }
        
        public static var mock: Self = .init(
            title: "Buyer protection",
            description: "Not happy with the purchase or different than advertised? We got you covered with the buyer protection for just **3% of order amount**, [read more](readmore). This includes:",
            listItems: [
                "Money back guarantee",
                "Whoppah mediation help",
                "Returns to Whoppah possible"
            ],
            switchEnabledTitle: "Buyer protection is added",
            switchDisabledTitle: "Click to activate buyer protection")
    }
    
    @State private var protectionIsEnabled = true
    @State private var descriptionHeight: CGFloat = .zero
    @State private var viewSize: CGSize = .zero
    
    private let model: Model
    private let didTapMoreInfo: () -> Void
    private let didChangeSelection: (Bool) -> Void
    private let displayScaling: CGFloat
    
    public init(model: Model,
                didTapMoreInfo: @escaping () -> Void,
                didChangeSelection: @escaping (Bool) -> Void)
    {
        self.model = model
        self.didTapMoreInfo = didTapMoreInfo
        self.didChangeSelection = didChangeSelection
        self.displayScaling = UIScreen.main.scale
    }
    
    public var body: some View {
        VStack {
            GeometryReader { geomProxy in
                ZStack(alignment: .topLeading) {
                    WavesBackgroundView(
                        viewSize: $viewSize,
                        speed: 0.2,
                        transitionDuration: 1.0,
                        backgroundColor1: WhoppahTheme.Color.BuyerProtection.Disabled.background,
                        backgroundColor2: WhoppahTheme.Color.BuyerProtection.Enabled.background,
                        wave1Color1: WhoppahTheme.Color.BuyerProtection.Disabled.wave1,
                        wave1Color2: WhoppahTheme.Color.BuyerProtection.Enabled.wave1,
                        wave2Color1: WhoppahTheme.Color.BuyerProtection.Disabled.wave2,
                        wave2Color2: WhoppahTheme.Color.BuyerProtection.Enabled.wave2,
                        transitionToggle: $protectionIsEnabled)

                    VStack {
                        HStack {
                            Image("buyer_protection_spark", bundle: .module)
                            Text(model.title)
                                .font(WhoppahTheme.Font.h3)
                                .foregroundColor(WhoppahTheme.Color.BuyerProtection.foreground)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, WhoppahTheme.Size.Padding.small)
                        }
                        
                        MarkdownView(markdown: model.description,
                                     textColor: WhoppahTheme.Color.BuyerProtection.foreground,
                                     linkColor: WhoppahTheme.Color.alert2,
                                     font: WhoppahTheme.Font.subtitle) { action in
                            switch action {
                            case let .didTapLink(url) where url == "buyerprotection":
                                didTapMoreInfo()
                            default: break
                            }
                        }
                        .padding(.top, WhoppahTheme.Size.Padding.small)
                        .padding(.bottom, WhoppahTheme.Size.Padding.medium)

                        ForEach(model.listItems) { listItem in
                            HStack(alignment: .top) {
                                Image(protectionIsEnabled ? "green_check_icon" : "grey_check_icon", bundle: .module)
                                    .padding(.top, WhoppahTheme.Size.Padding.tiny)
                                Text(listItem)
                                    .font(WhoppahTheme.Font.subtitle)
                                    .foregroundColor(WhoppahTheme.Color.BuyerProtection.foreground)
                                    .padding(.vertical, WhoppahTheme.Size.Padding.tiny)
                                    .frame(maxWidth: .infinity,
                                           alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        HStack {
                            Toggle("", isOn: $protectionIsEnabled.animation())
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: WhoppahTheme.Color.alert2))
                                .onChange(of: protectionIsEnabled) { newValue in
                                    didChangeSelection(newValue)
                                }
                            Text(protectionIsEnabled ? model.switchEnabledTitle : model.switchDisabledTitle)
                                .foregroundColor(WhoppahTheme.Color.BuyerProtection.foreground)
                                .font(WhoppahTheme.Font.subtitle)
                                .frame(maxWidth: .infinity,
                                       alignment: .leading)
                        }
                        .padding(.top, WhoppahTheme.Size.Padding.medium)
                    }
                    .padding(.all, WhoppahTheme.Size.Padding.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .mask(RoundedRectangle(cornerRadius: WhoppahTheme.Size.Radius.small))
                .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                .onAppear {
                    self.viewSize = (geomProxy.size * displayScaling)
                }
            }
            .aspectRatio(contentMode: .fit)
        }
    }
}

struct CheckoutBuyerProtection_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutBuyerProtection(model: .mock,
                                didTapMoreInfo: {},
                                didChangeSelection: { _ in })
    }
}
