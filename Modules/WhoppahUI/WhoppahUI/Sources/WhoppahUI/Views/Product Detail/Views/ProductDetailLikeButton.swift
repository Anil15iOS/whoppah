//
//  ProductDetailLikeButton.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 30/04/2022.
//

import SwiftUI
import WhoppahModel

struct ProductDetailLikeButton: View {
    @State private var animationTrigger: Bool = false
    
    var favorite: Favorite?
    var didTapButton: (Favorite?) -> Void
    
    var isFavorite: Bool {
        favorite != nil
    }
    
    init(favorite: Favorite?,
         didTapButton: @escaping (Favorite?) -> Void) {
        self.favorite = favorite
        self.didTapButton = didTapButton
    }

    var body: some View {
        HStack(spacing: WhoppahTheme.Size.Padding.smaller) {
            Button {
                animationTrigger.toggle()
                didTapButton(favorite)
            } label: {
                Image(isFavorite ? "heart_liked" : "heart_gray_filled", bundle: .module)
                    .frame(width: WhoppahTheme.Size.RoundButton.width,
                           height: WhoppahTheme.Size.RoundButton.height)
                    .contentShape(Rectangle())
                    .background(Color.white)
                    .cornerRadius(WhoppahTheme.Size.Radius.extraMedium)
            }
            .frame(width: WhoppahTheme.Size.CTA.width,
                   height: WhoppahTheme.Size.CTA.height)
            .background(Color.clear)
            .rotation3DEffect(animationTrigger ? .degrees(0) : WhoppahTheme.Animation.Like.degrees,
                              axis: WhoppahTheme.Animation.Like.axis,
                              perspective: WhoppahTheme.Animation.Like.perspective)
            .animation(.easeInOut(duration: WhoppahTheme.Animation.Like.duration),
                       value: animationTrigger)
        }
    }
}

struct ProductDetailLikeButton_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailLikeButton(favorite: nil) { _ in }
    }
}
