//
//  ReviewItem.swift
//  
//
//  Created by Dennis Ippel on 13/12/2021.
//

import SwiftUI

struct ReviewItem: View {
    let review: WhoppahReviews.Model.Review
    
    var body: some View {
        ZStack(alignment: .top) {
            let offset: CGFloat = review.avatar == nil ? 0 : 70

            VStack(alignment: .leading) {
                if let avatar = review.avatar {
                    VStack(alignment: .center) {
                        Image(avatar, bundle: .module)
                    }.frame(maxWidth: .infinity)
                    Spacer().frame(height: WhoppahTheme.Size.Padding.medium)
                } else {
                    Spacer().frame(height: WhoppahTheme.Size.Padding.large)
                }

                Text(review.reviewText)
                    .font(WhoppahTheme.Font.paragraph)
                    .lineSpacing(WhoppahTheme.Size.Paragraph.lineSpacing)
                    .padding(.horizontal, WhoppahTheme.Size.Padding.larger)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: WhoppahTheme.Size.Padding.large)
                
                if let image = review.image {
                    VStack(spacing: 0) {
                        Image(image, bundle: .module)
                            .resizable()
                            .scaledToFit()
                        Spacer().frame(height: WhoppahTheme.Size.Padding.large)
                    }
                    .padding(.horizontal, WhoppahTheme.Size.Padding.larger)
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(review.reviewerName)
                        .font(WhoppahTheme.Font.h3)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    
                    Rating(withRating: review.rating)
                    
                    Text(review.memberSince)
                        .italic()
                        .font(WhoppahTheme.Font.paragraph)
                        .foregroundColor(WhoppahTheme.Color.base2)
                }
                .padding(.horizontal, WhoppahTheme.Size.Padding.larger)
                
                Spacer().frame(height: WhoppahTheme.Size.Padding.larger)
            }
            .background(OffsetRoundedRectangle(offset: offset,
                                               cornerRadius: 10,
                                               shadowColor: WhoppahTheme.Color.dropShadow,
                                               fillColor: WhoppahTheme.Color.base4,
                                               shadowRadius: 10))
            .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
            .padding(.vertical, WhoppahTheme.Size.Padding.tiny)
            
            Image("quotes_icon", bundle: .module)
                .resizable()
                .colorOverlay(WhoppahTheme.Color.primary1)
                .scaledToFit()
                .frame(height: 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: WhoppahTheme.Size.Padding.large, y: offset + 20)
        }
    }
}

struct ReviewItem_Previews: PreviewProvider {
    static var previews: some View {
        ReviewItem(review: WhoppahReviews.Model.mock.reviews.first!)
    }
}
