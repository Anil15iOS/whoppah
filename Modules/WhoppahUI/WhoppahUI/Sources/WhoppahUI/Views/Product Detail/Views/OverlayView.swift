//
//  OverlayView.swift
//  
//
//  Created by Marko Stojkovic on 25.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct OverlayView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    
    @Binding private var showActionSheet: Bool
    @Binding private var stickyHeaderEnabled: Bool

    @State private var showAbuseReportSheet: Bool = false
    @State private var abuseReportType: WhoppahModel.AbuseReportType = .product

    @SwiftUI.Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets
    
    private var isIPad: Bool {
        UIScreen.main.traitCollection.userInterfaceIdiom == .pad
    }
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                showActionSheet: Binding<Bool>,
                stickyHeaderEnabled: Binding<Bool>)
    {
        self.store = store
        self._showActionSheet = showActionSheet
        self._stickyHeaderEnabled = stickyHeaderEnabled
    }
        
    var body: some View {
        WithViewStore(store) { viewStore in
            if let product = viewStore.model.product {
                ZStack(alignment: .top) {
                    
                    if self.stickyHeaderEnabled || isIPad {
                        if isIPad && !stickyHeaderEnabled {
                            Color.white.frame(height: WhoppahTheme.Size.OverlayView.height + safeAreaInsets.top)
                                .shadow(color: WhoppahTheme.Color.support8, radius: 2, x: 0, y: 4)
                                .opacity(0.01)
                        } else {
                            Color.white.frame(height: WhoppahTheme.Size.OverlayView.height + safeAreaInsets.top)
                                .shadow(color: WhoppahTheme.Color.support8, radius: 2, x: 0, y: 4)
                        }
                    }

                    if !self.stickyHeaderEnabled && !isIPad {
                        // For some reason this blocks gestures on iPad
                        Image("overlay", bundle: .module)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    HStack(alignment: .center,
                           spacing: WhoppahTheme.Size.Padding.tiny) {
                        Button {} label: {
                            Image("nav_back", bundle: .module)
                                .renderingMode(.template)
                                .foregroundColor(self.stickyHeaderEnabled ? .black : .white)
                        }
                        .frame(width: WhoppahTheme.Size.ShareButton.width,
                               height: WhoppahTheme.Size.ShareButton.height)
                        .simultaneousGesture(TapGesture().onEnded({ _ in
                            viewStore.send(.outboundAction(.didTapGoBack))
                        }))
                        
                        if self.stickyHeaderEnabled {
                            
                            if let firstImage = product.thumbnails.first,
                               let url = URL(string: firstImage.url)
                            {
                                AsyncImage(url: url) {
                                    PlaceholderRectangle()
                                        .scaledToFit()
                                } image: { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .frame(width: WhoppahTheme.Size.ShareButton.width,
                                       height: WhoppahTheme.Size.ShareButton.height)
                                .cornerRadius(WhoppahTheme.Size.Radius.smaller)
                            }
                            
                            Text(product.title)
                                .font(WhoppahTheme.Font.h4)
                                .foregroundColor(Color.black)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .padding(.leading, WhoppahTheme.Size.Padding.medium)
                        }
                        
                        Spacer()
                        
                        Button {
                            self.showActionSheet.toggle()
                        } label: {
                            Image("more_icon", bundle: .module)
                                .renderingMode(.template)
                                .foregroundColor(self.stickyHeaderEnabled ? .black : .white)
                        }
                        .frame(width: WhoppahTheme.Size.ShareButton.width,
                               height: WhoppahTheme.Size.ShareButton.height)
                        .simultaneousGesture(TapGesture().onEnded({ _ in
                            
                        }))
                    }
                    .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                    .padding(.top, safeAreaInsets.top + WhoppahTheme.Size.Padding.medium)
                    .padding(.bottom, WhoppahTheme.Size.Padding.medium)

                    VStack {
                        Spacer()
                        ZStack(alignment: .bottom) {
                            ReportAbuseActionSheet(viewStore: viewStore,
                                                   showAbuseReportSheet: $showAbuseReportSheet,
                                                   abuseReportType: $abuseReportType)
                            {
                                self.showActionSheet = false
                            }
                        }
                        .offset(y: self.showActionSheet && !self.showAbuseReportSheet ? 0 : UIScreen.main.bounds.height)
                    }
                    .background((self.showActionSheet && !self.showAbuseReportSheet ? WhoppahTheme.Color.base1.opacity(0.6) : Color.clear)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showActionSheet = false
                        })
                    .edgesIgnoringSafeArea(.bottom)
                    
                    ReportAbuseInputDialog(viewStore: viewStore,
                                           abuseReportType: $abuseReportType,
                                           product: product)
                    {
                        self.showAbuseReportSheet = false
                        self.showActionSheet = false
                    }
                    .isHidden(!showAbuseReportSheet)
                    .edgesIgnoringSafeArea(.bottom)
                }
                .animation(.default)
                .onChange(of: viewStore.state.reportAbuseState, perform: { state in
                    if state == .finished {
                        showAbuseReportSheet = false
                        showActionSheet = false
                    }
                })
            }
        }
    }
}

struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        OverlayView(store: store,
                    showActionSheet: .constant(false),
                    stickyHeaderEnabled: .constant(false))
    }
}
