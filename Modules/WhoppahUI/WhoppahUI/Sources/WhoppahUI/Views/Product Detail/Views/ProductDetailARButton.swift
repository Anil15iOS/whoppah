//
//  ProductDetailARButton.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 26/04/2022.
//

import SwiftUI
import WhoppahModel
import ComposableArchitecture

struct ProductDetailARButton: View {
    @State private var showARQuickLook = false
    @State private var isShowingProgress = false
    @State private var launchARStartTime = DispatchTime.now()
    @StateObject private var loader: FileLoader
    
    private let arObject: ARObject
    private let product: WhoppahModel.Product
    private let viewStore: ViewStore<ProductDetailView.ViewState, ProductDetailView.Action>
    
    init(arObject: ARObject,
         product: WhoppahModel.Product,
         viewStore: ViewStore<ProductDetailView.ViewState, ProductDetailView.Action>,
         url: URL)
    {
        self.arObject = arObject
        self.product = product
        self.viewStore = viewStore
        
        _loader = StateObject(wrappedValue: FileLoader(
            url: url,
            cache: Environment(\.fileCache).wrappedValue))
    }
    
    var body: some View {
        CallToAction(backgroundColor: WhoppahTheme.Color.base12,
                     foregroundColor: WhoppahTheme.Color.base4,
                     iconName: "camera_icon",
                     title: viewStore.model.viewInAugmentedReality,
                     showBorder: false,
                     showChevron: false,
                     showingProgress: $isShowingProgress)
        {
            if loader.url != nil {
                showARQuickLook = true
                launchARStartTime = DispatchTime.now()
                viewStore.send(.trackingAction(.trackLaunchedARView(product: product)))
            } else {
                isShowingProgress = true
                loader.load()
            }
        }
        .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
        .fullScreenCover(isPresented: $showARQuickLook, onDismiss: {
            isShowingProgress = false
            let nanoTime = DispatchTime.now().uptimeNanoseconds - launchARStartTime.uptimeNanoseconds
            let timeIntervalSeconds = Double(nanoTime) / 1_000_000_000
            viewStore.send(.trackingAction(.trackDismissedARView(product: product,
                                                                 timeSpentSecs: timeIntervalSeconds)))
        }, content: {
            if let url = loader.url {
                ARQuickLookView(url: url, showARQuickLook: $showARQuickLook)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .background(TransparentBackgroundView())
            }
        })
        .onChange(of: loader.url, perform: { newValue in
            if let _ = newValue, isShowingProgress {
                showARQuickLook = true
                launchARStartTime = DispatchTime.now()
                viewStore.send(.trackingAction(.trackLaunchedARView(product: product)))
            }
        })
    }
}

fileprivate struct TransparentBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
