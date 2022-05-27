//  
//  AboutWhoppah.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import SwiftUI
import ComposableArchitecture

public struct AboutWhoppah: View, StoreInitializable {
    let store: Store<AboutWhoppah.ViewState, AboutWhoppah.Action>?

    public init(store: Store<AboutWhoppah.ViewState, AboutWhoppah.Action>?) {
        self.store = store
        
        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
        }
    }

    public var body: some View {
        if let store = store {
            GeometryReader { geom in
                WithViewStore(store) { viewStore in
                    VStack {
                        Group {
                            Text(viewStore.state.model.title)
                                .font(WhoppahTheme.Font.h2)
                                .padding(.horizontal, WhoppahTheme.Size.Padding.larger)
                                .multilineTextAlignment(.center)

                            Spacer().frame(height: WhoppahTheme.Size.Padding.medium)
                            
                            Image("about_header", bundle: .module)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geom.size.width - WhoppahTheme.Size.Padding.medium * 2.0)
                            
                            Spacer().frame(height: WhoppahTheme.Size.Padding.larger)

                            Text(viewStore.state.model.welcomeTitle)
                                .font(WhoppahTheme.Font.h3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Group {
                            Spacer().frame(height: WhoppahTheme.Size.Padding.medium)

                            Text(viewStore.state.model.paragraph1)
                                .font(WhoppahTheme.Font.paragraph)
                                .lineSpacing(WhoppahTheme.Size.Paragraph.lineSpacing)
                                .padding(.all, 0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer().frame(height: WhoppahTheme.Size.Padding.medium)
                            
                            Text(viewStore.state.model.paragraph2)
                                .font(WhoppahTheme.Font.paragraph)
                                .lineSpacing(WhoppahTheme.Size.Paragraph.lineSpacing)
                                .padding(.all, 0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer().frame(height: WhoppahTheme.Size.Padding.larger)
                        }

                        Text(viewStore.state.model.pressHeadline)
                            .font(WhoppahTheme.Font.h3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer().frame(height: WhoppahTheme.Size.Padding.larger)

                        Group {
                            VStack(spacing: WhoppahTheme.Size.Padding.larger) {
                                HStack(spacing: WhoppahTheme.Size.Padding.larger) {
                                    Image("logo_vogue", bundle: .module)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 200)
                                    Image("logo_elle", bundle: .module)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 200)
                                }
                                HStack(spacing: WhoppahTheme.Size.Padding.larger) {
                                    Image("logo_cosmopolitan", bundle: .module)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 200)
                                    Image("logo_marieclaire", bundle: .module)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 200)
                                }
                            }
                        }

                        Group {
                            Spacer().frame(height: WhoppahTheme.Size.Padding.larger)
                            
                            VStack {
                                VStack(spacing: WhoppahTheme.Size.Padding.medium) {
                                    Image("spark_green", bundle: .module)
                                        .colorOverlay(WhoppahTheme.Color.primary1)

                                    Text(viewStore.state.model.contactTitle)
                                        .font(WhoppahTheme.Font.h3)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                    VStack(spacing: WhoppahTheme.Size.Paragraph.lineSpacing) {
                                        Text(viewStore.state.model.contactSuggestion)
                                            .font(WhoppahTheme.Font.paragraph)
                                            .lineSpacing(WhoppahTheme.Size.Paragraph.lineSpacing)
                                            .padding(.all, 0)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                        Text(viewStore.state.model.supportEmail)
                                            .font(WhoppahTheme.Font.paragraph)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .onTapGesture {
                                                viewStore.send(.outboundAction(.mailToSupportTapped(viewStore.state.model.supportEmail)))
                                            }
                                    }
                                    
                                    Spacer().frame(height: WhoppahTheme.Size.Padding.medium)
                                    
                                    Text(viewStore.state.model.contactOfficeHours)
                                        .font(WhoppahTheme.Font.paragraph)
                                        .lineSpacing(WhoppahTheme.Size.Paragraph.lineSpacing)
                                        .padding(.all, 0)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                }
                                .padding(.all, WhoppahTheme.Size.Padding.medium)
                                .background(WhoppahTheme.Color.base3)
                            }
                            .padding(.all, WhoppahTheme.Size.Padding.tiny)
                            .background(WhoppahTheme.Color.base3)
                        }
                    }
                    .scrollOnOverflow(.vertical, showsIndicators: true)
                    .padding(.all, WhoppahTheme.Size.Padding.medium)
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct AboutWhoppah_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: AboutWhoppah.Reducer().reducer,
                          environment: .init(localizationClient: AboutWhoppah.mockLocalizationClient,
                                             trackingClient: AboutWhoppah.mockTrackingClient,
                                             outboundActionClient: AboutWhoppah.mockOutboundActionClient,
                                             mainQueue: .main))
        
        AboutWhoppah(store: store)
    }
}
