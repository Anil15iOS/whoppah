//
//  ProductTileLikeButton.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 31/03/2022.
//

import SwiftUI
import WhoppahModel

struct ProductTileLikeButton: View {
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
        Image(isFavorite ? "favorite_selected" : "favorite_unselected", bundle: .module)
            .resizable()
            .frame(width: WhoppahTheme.Size.GridItem.likeButtonSize,
                   height: WhoppahTheme.Size.GridItem.likeButtonSize)
            .foregroundColor(isFavorite ? WhoppahTheme.Color.primary1 : WhoppahTheme.Color.base1)
            .onTapGesture {
                animationTrigger.toggle()
                didTapButton(favorite)
            }
            .rotation3DEffect(animationTrigger ? .degrees(0) : WhoppahTheme.Animation.Like.degrees,
                              axis: WhoppahTheme.Animation.Like.axis,
                              perspective: WhoppahTheme.Animation.Like.perspective)
            .animation(.easeInOut(duration: WhoppahTheme.Animation.Like.duration),
                       value: animationTrigger)
    }
}

struct ProductTileLikeButton_Previews: PreviewProvider {
    static var previews: some View {
        ProductTileLikeButton(favorite: nil) { _ in }
    }
}
