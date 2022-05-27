//
//  Rating.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import SwiftUI

struct Rating: View {
    private var rating: Double = 2.5
    
    init(withRating rating: Double) {
        self.rating = rating
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0...4, id: \.self) { value in
                
                let value = Double(value)
                let starValue = rating - value
                
                switch starValue {
                case 0.1..<1:
                    Image("review_star_half", bundle: .module)
                        .colorOverlay(WhoppahTheme.Color.primary3)
                case let x where x < 0:
                    Image("review_star_empty", bundle: .module)
                        .colorOverlay(WhoppahTheme.Color.primary3)
                case let x where x >= 1:
                    Image("review_star_full", bundle: .module)
                        .colorOverlay(WhoppahTheme.Color.primary3)
                default:
                    Image("review_star_empty", bundle: .module)
                        .colorOverlay(WhoppahTheme.Color.primary3)
                }
            }
        }
    }

    func round(_ value: Double) -> Double {
        let n = 2.0
        let numberToRound = value * n
        return numberToRound.rounded() / n
    }
}

struct Rating_Previews: PreviewProvider {
    static var previews: some View {
        Rating(withRating: 4.5)
            .previewLayout(.fixed(width: 200, height: 40))
    }
}
