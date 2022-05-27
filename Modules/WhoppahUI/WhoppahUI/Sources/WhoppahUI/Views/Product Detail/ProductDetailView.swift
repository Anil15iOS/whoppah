//  
//  ProductDetailView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/03/2022.
//

import SwiftUI
import ComposableArchitecture
import WhoppahModel

public struct ProductDetailView: View, StoreInitializable {
    let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>?
    
    @State var showPopup: Bool = false
    @State var showReviews: Bool = false
    @State var popupContent: ModalPopupContent = .initial
    @State var showImageGallery: Bool = false
    @State var selectedPage: Int = 0
    @State var bidComponentIsHidden: Bool = false
    @State var showActionSheet: Bool = false
    @State var textEditorFocused: Bool = false
    @State var stickyHeaderEnabled: Bool = false
    @State var scrollToView: Bool = false
    @State var showBidConfirmationModal: Bool = false
    @State var showReportAbuseResponseModal: Bool = false
    @State var bidValue: WhoppahModel.Price = .init(amount: 0, currency: .eur)
    @State var isAwaitingBidResponse: Bool = false
    @State var bidComponentHeight: Double = 0
    
    private let sellerComponentViewId: UUID = UUID()
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>?) {
        self.store = store
    }

    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                ZStack {
                    if viewStore.state.loadingState == .finished {
                        ZStack(alignment: .top) {
                            ScrollViewOffset(scrollToViewEnabled: $scrollToView,
                                             uniqueViewId: self.sellerComponentViewId,
                                             content: {
                                
                                if let product = viewStore.model.product {
                                    
                                    Group {
                                        // 📙 Hero Image view
                                        //
                                        HeroImageView(store: store,
                                                      showImageGallery: $showImageGallery,
                                                      selectedPage: $selectedPage)
                                        
                                        //
                                        // 📙 Sold view
                                        //
                                        SoldView(store: store)
                                        
                                        //
                                        // 📙 Reserved view
                                        //
                                        ReservedView(store: store)
                                        
                                        //
                                        // 📙 Product title view
                                        //
                                        ProductTitleView(store: store, product: product)
                                        
                                        //
                                        // 📙 Seller Component view
                                        //
                                        SellerComponentView(store: store,
                                                            product: product,
                                                            showReviews: $showReviews) {
                                            textEditorFocused = true
                                            withAnimation {
                                                self.scrollToView.toggle()
                                            }
                                        }
                                        .id(self.sellerComponentViewId)
                                        
                                        //
                                        // 📙 Seller's boost view
                                        // Note: not in this release
                                        /*
                                        SellerBoostView(store: store)
                                         */
                                        
                                        //
                                        // 📙 AR button
                                        //
                                        
                                        if let arObject = viewStore.model.product?.arobject,
                                           let url = URL(string: arObject.url.replacingOccurrences(of: " ", with: "%20")) // This will be fixed server-side by Akshit
                                        {
                                            ProductDetailARButton(arObject: arObject,
                                                                  product: product,
                                                                  viewStore: viewStore,
                                                                  url: url)
                                        }
                                        
                                        //
                                        // 📙 Product details view
                                        //
                                        ProductDetailsView(store: store,
                                                           product: product)
                                    }
                                    
                                    Group {
                                        //
                                        // 📙 Product Condition view
                                        //
                                        ProductConditionView(store: store, product: product)
                                        
                                        //
                                        // 🚛 Delivery & Shipping view
                                        //
                                        ShippingView(store: store, product: product)
                                        
                                        //
                                        // 🛡 Buyer protection view
                                        //
                                        ProductDetailBuyerProtectionView(
                                            viewStore: viewStore,
                                            popupContent: $popupContent,
                                            showPopup: $showPopup)
                                        
                                        //
                                        // 📙 Benefits view
                                        //
                                        BenefitsView(store: store,
                                                     popupContent: $popupContent,
                                                     showPopup: $showPopup)
                                        
                                        //
                                        // 📙 Related Products view
                                        //
                                        RelatedProductsView(store: store)
                                        
                                        //
                                        // 📙 Contact info
                                        //
                                        ContactView(store: store)
                                    }
                                    .padding(.bottom, WhoppahTheme.Size.Padding.medium)
                                }
                            }, onOffsetChange: { offset in
                                if offset > WhoppahTheme.Size.HeroImage.height, !self.stickyHeaderEnabled {
                                    self.stickyHeaderEnabled = true
                                } else if offset <= WhoppahTheme.Size.HeroImage.height, self.stickyHeaderEnabled {
                                    self.stickyHeaderEnabled = false
                                }
                            })
                            .padding(.bottom, bidComponentHeight)
                            .clipped()
                            .simultaneousGesture(TapGesture().onEnded({ _ in
                                UIApplication.shared.closeKeyboard()
                                textEditorFocused = false
                            }))
                            
                            //
                            // 📙 Overlay with opacity view
                            //
                            OverlayView(store: store,
                                        showActionSheet: $showActionSheet,
                                        stickyHeaderEnabled: $stickyHeaderEnabled)
                            .simultaneousGesture(TapGesture().onEnded({ _ in
                                UIApplication.shared.closeKeyboard()
                                textEditorFocused = false
                            }))
                            
                            if let product = viewStore.model.product {
                                
                                //
                                // 📙 Bid & Bay view
                                //
                                BidComponentView(store: store,
                                                 product: product,
                                                 bidComponentIsHidden: $bidComponentIsHidden,
                                                 actionSheetIsPresenting: $showActionSheet,
                                                 popupContent: $popupContent,
                                                 showPopup: $showPopup,
                                                 showBidConfirmationModal: $showBidConfirmationModal,
                                                 bidValue: $bidValue,
                                                 componentHeight: $bidComponentHeight)
                            }
                            
                            //
                            // 📙 Popup payment details view
                            //
                            ModalPopUpView(content: $popupContent,
                                           showPopup: $showPopup)
                            
                            //
                            // 📙 Reviews view
                            //
                            ReviewsView(store: store,
                                        showReviews: $showReviews)
                            
                            //
                            // 📙 Bid confirmation modal
                            //
                            if showBidConfirmationModal, let product = viewStore.model.product {
                                ModalDialog(title: viewStore.model.bidComponent.bidConfirmationDialog.title,
                                            description: viewStore.model.bidComponent.bidConfirmationDialog.description(bidValue.formattedString, product.title),
                                            iconName: "information_icon") {
                                    showBidConfirmationModal.toggle()
                                } content: {
                                    VStack {

                                        CallToAction(backgroundColor: WhoppahTheme.Color.alert3,
                                                     foregroundColor: WhoppahTheme.Color.base4,
                                                     title: viewStore.model.bidComponent.bidConfirmationDialog.confirmButtonTitle,
                                                     showBorder: false,
                                                     showingProgress: $isAwaitingBidResponse) {
                                            guard !isAwaitingBidResponse else { return }
                                            
                                            viewStore.send(.placeBid(product: product,
                                                                     amount: bidValue))
                                            
                                            let categories = product.categories.map { $0.slug }.joined(separator: ",")
                                            
                                            viewStore.send(
                                                .trackingAction(
                                                    .trackAdDetailsBid(
                                                        product: product,
                                                        categoryText: categories,
                                                        maxBid: bidValue)))
                                        }
                                        .disabled(isAwaitingBidResponse)

                                        CallToAction(backgroundColor: WhoppahTheme.Color.base4,
                                                     foregroundColor: WhoppahTheme.Color.alert3,
                                                     title: viewStore.model.bidComponent.bidConfirmationDialog.cancelButtonTitle,
                                                     showBorder: true) {
                                            showBidConfirmationModal.toggle()
                                        }
                                    }
                                }
                            }
                            
                            //
                            // ⚠️ Report abuse response modal
                            //
                            
                            if showReportAbuseResponseModal {
                                ModalDialog(title: viewStore.model.heroImageComponent.reportSubmissionSuccess) {
                                    showReportAbuseResponseModal = false
                                } content: {
                                    CallToAction(backgroundColor: WhoppahTheme.Color.alert3,
                                                 foregroundColor: WhoppahTheme.Color.base4,
                                                 iconName: nil,
                                                 title: viewStore.model.heroImageComponent.doneButtonTitle,
                                                 showBorder: false)
                                    {
                                        showReportAbuseResponseModal = false
                                    }
                                }
                            }

                            //
                            // 📙 Image preview
                            //
                            ImageGalleryView(store: store,
                                             showGallery: $showImageGallery,
                                             selectedPage: $selectedPage)
                        }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        .edgesIgnoringSafeArea(.top)
                        .ignoresSafeArea($textEditorFocused.wrappedValue ? .keyboard : .container,
                                         edges: $textEditorFocused.wrappedValue ? .bottom : .horizontal)
                        .onChange(of: viewStore.state.placeBidState, perform: { newValue in
                            isAwaitingBidResponse = viewStore.state.placeBidState == .loading
                        })
                        .onChange(of: viewStore.state.reportAbuseState, perform: { newState in
                            if newState == .finished {
                                showReportAbuseResponseModal = true
                            }
                        })
                    } else {
                        ActivityIndicator(isAnimating: .constant(true),
                                          style: .large,
                                          color: WhoppahTheme.Color.base1)
                            .onAppear {
                                if viewStore.loadingState == .uninitialized {
                                    viewStore.send(.loadContent)
                                }
                            }
                    }
                }
                .onAppear {
                    guard let product = viewStore.state.model.product else { return }
                    viewStore.send(.trackingAction(.trackAdViewed(product: product)))
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
            let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .init(localizationClient: ProductDetailView.mockLocalizationClient,
                                             trackingClient: ProductDetailView.mockTrackingClient,
                                             outboundActionClient: ProductDetailView.mockOutboundActionClient,
                                             productDetailsClient: .mockClient,
                                             favoritesClient: WhoppahUI.FavoritesClient.mockFavoritesClient,
                                             mainQueue: .main))
        
        ProductDetailView(store: store)
    }
}
