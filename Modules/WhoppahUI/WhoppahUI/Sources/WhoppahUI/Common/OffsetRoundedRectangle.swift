//
//  OffsetRoundedRectangle.swift
//  
//
//  Created by Dennis Ippel on 13/12/2021.
//

import SwiftUI

public struct OffsetRoundedRectangle: View {
    public let offset: Double
    public let cornerRadius: Double
    
    public let shadowColor: Color
    public let fillColor: Color
    public let shadowRadius: Double
        
    public var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: offset)
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(fillColor)
                .shadow(color: shadowColor,
                        radius: shadowRadius,
                            x: 0, y: 0)
        }
    }
}
