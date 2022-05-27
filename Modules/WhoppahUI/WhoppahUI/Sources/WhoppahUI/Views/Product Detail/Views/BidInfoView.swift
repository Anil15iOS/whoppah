//
//  BidInfoView..swift
//  
//
//  Created by Marko Stojkovic on 15.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct BidInfoView: View {
    
    private let product: WhoppahModel.Product
    private let bidInfoTitle: (Int) -> String
    
    public init(product: WhoppahModel.Product, bidInfoTitle: @escaping (Int) -> String) {
        self.product = product
        self.bidInfoTitle = bidInfoTitle
    }
    
    var body: some View {
        if let bidCount = product.auction?.bidCount, bidCount > 0 {
            HStack(spacing: WhoppahTheme.Size.Padding.medium) {
                Image("bubble-circle", bundle: .module)
                    .renderingMode(.template)
                    .foregroundColor(WhoppahTheme.Color.alert2)
                Text("\(bidInfoTitle(bidCount))")
                    .font(WhoppahTheme.Font.h4)
                    .foregroundColor(WhoppahTheme.Color.alert2)
                Spacer()
            }
            .padding(.all, WhoppahTheme.Size.Padding.medium)
            .background(WhoppahTheme.Color.support2)
            .cornerRadius(WhoppahTheme.Size.Radius.small)
            .padding(.top, WhoppahTheme.Size.Padding.small)
        } else {
            EmptyView()
        }
    }
}

struct BidInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BidInfoView(product: .random, bidInfoTitle: { _ in .empty })
    }
}
