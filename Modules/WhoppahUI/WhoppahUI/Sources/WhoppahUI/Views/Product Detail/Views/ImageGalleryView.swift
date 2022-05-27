//
//  ImageGalleryView.swift
//  
//
//  Created by Marko Stojkovic on 29.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct ImageGalleryView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    @Binding private var show: Bool
    @Binding private var selectedPage: Int
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                showGallery: Binding<Bool>,
                selectedPage: Binding<Int>) {
        self.store = store
        self._show = showGallery
        self._selectedPage = selectedPage
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = WhoppahTheme.Color.base1.uiColor
        UIPageControl.appearance().pageIndicatorTintColor = WhoppahTheme.Color.base11.uiColor
    }
        
    var body: some View {
        WithViewStore(store) { viewStore in
            if let product = viewStore.model.product {
                ZStack {
                    if show {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                        if product.fullImages.count > 0 {
                            VStack(alignment: .center) {
                                TabView(selection: $selectedPage) {
                                    ForEach(0..<product.fullImages.count,
                                            id: \.self) { index in
                                        if let url = URL(string: product.fullImages[index].url) {
                                            Group {
                                                AsyncImage(url: url) {
                                                    PlaceholderRectangle()
                                                        .scaledToFit()
                                                } image: { loadedImage in
                                                    loadedImage
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(maxWidth: .infinity)
                                                        .modifier(PinchToZoomModifier())
                                                }
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .clipped()
                                            .edgesIgnoringSafeArea(.all)
                                            .tag(index)
                                        }
                                    }
                                }
                                .tabViewStyle(.page)
                                .onAppear {
                                    self.setupAppearance()
                                }
                            }
                            .edgesIgnoringSafeArea(.all)
                        }
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                Spacer()
                                Button {
                                    self.show = false
                                } label: {
                                    Image("cross_big", bundle: .module)
                                }
                                .frame(width: WhoppahTheme.Size.ShareButton.width,
                                       height: WhoppahTheme.Size.ShareButton.height)
                                .padding(.trailing, WhoppahTheme.Size.Padding.medium)
                                .padding(.top, WhoppahTheme.Size.Padding.medium + safeAreaInsets.top)
                            }
                            Spacer()
                        }
                    }
                }
                .animation(.default)
                .edgesIgnoringSafeArea(.all)
            } else {
                EmptyView()
            }
        }
    }
}

struct ImageGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        ImageGalleryView(store: store,
                         showGallery: .constant(true),
                         selectedPage: .constant(0))
    }
}
