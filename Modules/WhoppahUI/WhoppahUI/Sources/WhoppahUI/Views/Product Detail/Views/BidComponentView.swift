//
//  BidComponentView.swift
//  
//
//  Created by Marko Stojkovic on 30.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct BidComponentView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    private let product: WhoppahModel.Product
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets
    
    @Binding private var isHidden: Bool
    @Binding private var actionSheetIsPresenting: Bool
    @Binding private var presentPopup: Bool
    @Binding private var popupContent: ModalPopupContent
    @Binding private var showBidConfirmationModal: Bool
    @Binding private var bidValue: WhoppahModel.Price
    @Binding private var componentHeight: Double

    @State private var bidIsInFocus = false
    @State private var bidOffer: String = ""
    @State private var animationDidBegin = false
    @State private var buyNowIsEnabled = false
    @State private var buyNowPrice: Price = .init(amount: 0, currency: .eur)
    @State private var allowBid = false
    @State private var minimumBidPrice: Price = .init(amount: 0, currency: .eur)
    @State private var quickBids = [Price]()
    @State private var isValidBid: Bool = false
    @State private var isAwaitingBidResponse: Bool = false
    @State private var isAwaitingBuyNowResponse: Bool = false
    @State private var keyboardIsOpen: Bool = false
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                product: WhoppahModel.Product,
                bidComponentIsHidden: Binding<Bool>,
                actionSheetIsPresenting: Binding<Bool>,
                popupContent: Binding<ModalPopupContent>,
                showPopup: Binding<Bool>,
                showBidConfirmationModal: Binding<Bool>,
                bidValue: Binding<Price>,
                componentHeight: Binding<Double>) {
        self.store = store
        self.product = product
        self._isHidden = bidComponentIsHidden
        self._actionSheetIsPresenting = actionSheetIsPresenting
        self._popupContent = popupContent
        self._presentPopup = showPopup
        self._showBidConfirmationModal = showBidConfirmationModal
        self._bidValue = bidValue
        self._componentHeight = componentHeight
    }
    
    private func isMerchantsOwnProduct(merchant: WhoppahModel.Merchant,
                                       currentUser: WhoppahModel.Member?) -> Bool
    {
        return currentUser?.merchantId == merchant.id
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            
            let placeBidButton = CallToAction(backgroundColor: WhoppahTheme.Color.alert3,
                                              foregroundColor: Color.white,
                                              iconName: "bid_white_icon",
                                              title: viewStore.model.bidComponent.placeBidButtontitle,
                                              showBorder: false,
                                              buttonFont: WhoppahTheme.Font.h4,
                                              showingProgress: $isAwaitingBidResponse) {
                                     
                                     guard !isAwaitingBuyNowResponse && !isAwaitingBidResponse else { return }
                                     
                                     self.animationDidBegin = true
                                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                         if !self.bidIsInFocus {
                                             self.bidIsInFocus = true
                                         } else {
                                             guard isValidBid, let bidAmount = Double(bidOffer) else { return }
                                             
                                             viewStore.send(
                                                 .placeBid(
                                                     product: product,
                                                     amount: .init(amount: bidAmount,
                                                                   currency: minimumBidPrice.currency)))
                                         }
                                     }
                                 }
                                 .disabled(bidIsInFocus && !isValidBid)
            
            ZStack {
                if !isHidden && !actionSheetIsPresenting {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        VStack(spacing: WhoppahTheme.Size.Padding.medium) {
                            Rectangle()
                                .fill(WhoppahTheme.Color.support7)
                                .frame(height: WhoppahTheme.Size.Rectangle.height)
                            
                            if self.bidIsInFocus,
                               allowBid
                            {
                                HStack(alignment: .center){
                                    Text(viewStore.model.bidComponent.bidFromTitle(minimumBidPrice))
                                        .foregroundColor(WhoppahTheme.Color.base1)
                                        .font(WhoppahTheme.Font.h3)
                                }
                                .padding(.top, WhoppahTheme.Size.Padding.small)
                            }
                            
                            HStack(spacing: WhoppahTheme.Size.Padding.smaller) {
                                if allowBid {
                                    if self.animationDidBegin  {
                                        TextInputWithValidation(
                                            backgroundColor: .clear,
                                            placeholderText: viewStore.model.bidComponent.bidPlaceholderText,
                                            validateOnChange: true,
                                            validators: [
                                                BidValidator(viewStore.model.bidComponent.bidFromTitle(minimumBidPrice),
                                                             minimumBidPrice)
                                            ],
                                            formatters: [ PriceFormatter() ],
                                            isInputValid: $isValidBid,
                                            inputValue: $bidOffer,
                                            contextualLabel: minimumBidPrice.currency.text)
                                            .keyboardType(.numberPad)
                                            .padding(.leading, WhoppahTheme.Size.Padding.tiny)
                                            .padding(.top, WhoppahTheme.Size.Padding.mediumSmall)
                                            .foregroundColor(WhoppahTheme.Color.base2)
                                        
                                        placeBidButton.animation(.default)
                                    }
                                }
                                
                                if !self.animationDidBegin,
                                    buyNowIsEnabled
                                {
                                    if allowBid {
                                        placeBidButton.animation(.default)
                                    }
                                    
                                    CallToAction(backgroundColor: WhoppahTheme.Color.alert2,
                                                 foregroundColor: Color.white,
                                                 iconName: nil,
                                                 title: viewStore.model.bidComponent.buyNowButtonTitle(buyNowPrice.formattedString),
                                                 showBorder: false,
                                                 buttonFont: WhoppahTheme.Font.h4,
                                                 showingProgress: $isAwaitingBuyNowResponse) {
                                        guard !isAwaitingBuyNowResponse && !isAwaitingBidResponse else { return }
                                        
                                        viewStore.send(.buyNow(product: product,
                                                               amount: buyNowPrice))
                                        
                                        let categories = product.categories.map { $0.slug }.joined(separator: ",")
                                        viewStore.send(
                                            .trackingAction(
                                                .trackAdDetailsBuyNow(
                                                    product: product,
                                                    categoryText: categories)))
                                    }
                                    .disabled(isAwaitingBuyNowResponse || isAwaitingBidResponse)
                                }
                            }
                            .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                            
                            if quickBids.count > 0, self.bidIsInFocus {
                                HStack(alignment: .center){
                                    Text(viewStore.model.bidComponent.quickBidTitle)
                                        .foregroundColor(WhoppahTheme.Color.base1)
                                        .font(WhoppahTheme.Font.h3)
                                }
                                
                                HStack(spacing: WhoppahTheme.Size.Padding.small) {
                                    ForEach(quickBids, id:\.amount) { quickBid in
                                        CallToAction(backgroundColor: WhoppahTheme.Color.support4,
                                                     foregroundColor: WhoppahTheme.Color.alert3,
                                                     iconName: nil,
                                                     title: quickBid.formattedString,
                                                     showBorder: true) {
                                            showBidConfirmationModal.toggle()
                                            UIApplication.shared.closeKeyboard()

                                            bidValue = .init(amount: quickBid.amount,
                                                             currency: minimumBidPrice.currency)
                                        }
                                        .disabled(isAwaitingBuyNowResponse || isAwaitingBidResponse)
                                    }
                                }
                                .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                                
                                Button {
                                    withAnimation(.linear(duration: 0.2)) {
                                        popupContent = viewStore.model.bidComponent.biddingInfoPopup
                                        presentPopup.toggle()
                                    }
                                } label: {
                                    Text(viewStore.model.bidComponent.readMoreTitle)
                                        .underline()
                                        .foregroundColor(WhoppahTheme.Color.alert3)
                                        .font(WhoppahTheme.Font.subtitle)
                                }
                                .padding(.bottom, WhoppahTheme.Size.Padding.small)
                            }
                        }
                        .edgesIgnoringSafeArea(.bottom)
                        .background(Color.white)
                        .padding(.bottom, keyboardIsOpen ? 0 : safeAreaInsets.bottom)
                        .overlay(
                            GeometryReader { geo in
                                Color.clear.onAppear {
                                    componentHeight = Double(geo.size.height)
                                }
                            }
                        )
                    }
                    .edgesIgnoringSafeArea(keyboardIsOpen ? .top : .all)
                    .background((self.bidIsInFocus ? WhoppahTheme.Color.base1.opacity(0.6) : Color.clear)
                    .onTapGesture {
                        self.bidOffer = ""
                        self.animationDidBegin = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.bidIsInFocus = false
                        }
                    })
                }
            }
            .animation(.default)
            .onAppear {
                self.handleOnAppear(viewStore: viewStore)
            }
            .onChange(of: viewStore.state.placeBidState, perform: { newValue in
                isAwaitingBidResponse = viewStore.state.placeBidState == .loading
            })
            .onChange(of: viewStore.state.buyNowState, perform: { newValue in
                isAwaitingBuyNowResponse = viewStore.state.buyNowState == .loading
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                 keyboardIsOpen = false
             }
             .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                 keyboardIsOpen = true
             }
        }
    }
    
    private func handleOnAppear(viewStore: ViewStore<ProductDetailView.ViewState, ProductDetailView.Action>) {
        isHidden = isMerchantsOwnProduct(merchant: product.merchant,
                                          currentUser: viewStore.state.user())
        
        if isHidden { return }
        
        quickBids.removeAll()
        
        if let auction = product.auction,
           auction.allowBuyNow,
           let buyNowPrice = auction.buyNowPrice
        {
            self.buyNowIsEnabled = true
            self.buyNowPrice = buyNowPrice
        } else {
            self.buyNowIsEnabled = false
        }
        
        if let auction = product.auction,
           auction.allowBid,
           let minimumBidPrice = auction.minimumBid
        {
            self.allowBid = true
            self.minimumBidPrice = minimumBidPrice
            
            if buyNowIsEnabled {
                let difference = buyNowPrice.amount - minimumBidPrice.amount
                let increment = difference / 3.0
                
                quickBids.append(minimumBidPrice)
                quickBids.append(.init(amount: Double(Int(minimumBidPrice.amount + increment)), currency: minimumBidPrice.currency))
                quickBids.append(.init(amount: Double(Int(minimumBidPrice.amount + increment * 2)), currency: minimumBidPrice.currency))
            }
        } else {
            self.allowBid = false
            self.quickBids.removeAll()
        }
    }
}

struct BidComponentView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        BidComponentView(store: store,
                         product: .random,
                         bidComponentIsHidden: .constant(false),
                         actionSheetIsPresenting: .constant(false),
                         popupContent: .constant(.initial),
                         showPopup: .constant(false),
                         showBidConfirmationModal: .constant(false),
                         bidValue: .constant(.init(amount: 0, currency: .eur)),
                         componentHeight: .constant(0))
    }
}
