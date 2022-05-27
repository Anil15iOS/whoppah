//
//  PinchToZoomModifier.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 19/04/2022.
//

import SwiftUI

struct PinchToZoomModifier: ViewModifier {
    @GestureState private var imageScale: CGFloat = 1.0
    
    private var magnification: some Gesture {
        MagnificationGesture()
            .updating($imageScale) { currentState, gestureState, transaction in
                gestureState = currentState
            }
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(imageScale)
            .gesture(magnification)
    }
}
