//
//  PlaceholderRectangle.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 11/03/2022.
//

import SwiftUI

struct PlaceholderRectangle: View {
    private let backgroundColor: Color
    private let minOpacity: Double
    private let maxOpacity: Double
    private let durationSecs: Double
    
    @State private var opacity = 0.0
    
    init(backgroundColor: Color = WhoppahTheme.Color.base1,
         minOpacity: Double = 0.3,
         maxOpacity: Double = 0.5,
         durationSecs: Double = 1.0)
    {
        self.backgroundColor = backgroundColor
        self.minOpacity = minOpacity
        self.maxOpacity = maxOpacity
        self.durationSecs = durationSecs
    }
    
    var body: some View {
        Rectangle()
            .fill(backgroundColor)
            .opacity(opacity)
            .onAppear {
                opacity = minOpacity
                withAnimation(.easeInOut(duration: durationSecs).repeatForever()) {
                    opacity = maxOpacity
                }
            }
    }
}
