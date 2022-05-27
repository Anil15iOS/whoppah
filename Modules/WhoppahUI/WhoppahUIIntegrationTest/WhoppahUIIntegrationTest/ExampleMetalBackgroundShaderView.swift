//
//  ExampleMetalBackgroundShaderView.swift
//  WhoppahUIIntegrationTest
//
//  Created by Dennis Ippel on 13/05/2022.
//

import SwiftUI
import WhoppahUI
import Tweener

struct ExampleMetalBackgroundShaderView: View {
    private let viewSize: CGSize
    @State private var toggleIsOn: Bool = true
    
    init(viewSize: CGSize) {
        self.viewSize = viewSize
    }
    
    var body: some View {
        ZStack {
            WavesBackgroundView(viewSize: .constant(viewSize),
                                backgroundColor1: .orange,
                                backgroundColor2: .red,
                                wave1Color1: .yellow,
                                wave1Color2: .green,
                                wave2Color1: .white,
                                wave2Color2: .blue,
            transitionToggle: $toggleIsOn)
            
            VStack {
                Toggle("", isOn: $toggleIsOn.animation(.easeInOut(duration: 2.0)).animation())
                    .labelsHidden()
                MarkdownView(markdown: "This is **bold text**, __italic text__ and this is a [link](myAction). Hello __italic__. Hello hello.", didEmitAction: { _ in })
            }
            .frame(alignment: .center)
        }
    }
}
