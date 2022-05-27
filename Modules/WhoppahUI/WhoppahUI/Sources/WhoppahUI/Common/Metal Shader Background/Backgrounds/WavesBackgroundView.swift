//
//  WavesBackgroundView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 13/05/2022.
//

import SwiftUI
import Tweener

public struct WavesBackgroundView: View {
    private class FragmentUniforms: ShaderUniformsProvider {
        struct Uniforms {
            var time: Float
            var speed: Float
            var transition: Float
            var viewSize: SIMD2<Float>
            var backgroundColor1: SIMD4<Float>
            var backgroundColor2: SIMD4<Float>
            var wave1Color1: SIMD4<Float>
            var wave1Color2: SIMD4<Float>
            var wave2Color1: SIMD4<Float>
            var wave2Color2: SIMD4<Float>
        }

        init(uniforms: Uniforms, startTime: CFTimeInterval) {
            self.uniforms = uniforms
            self.startTime = startTime
        }
        
        var uniforms: Uniforms
        var startTime: CFTimeInterval
        
        func update(buffer: inout MTLBuffer) {
            let ptr = buffer.contents().bindMemory(to: Uniforms.self, capacity: 1)
            ptr.pointee.time = Float(CACurrentMediaTime() - startTime)
            ptr.pointee.transition = uniforms.transition
            ptr.pointee.viewSize = uniforms.viewSize
        }
        
        func makeBuffer(usingDevice device: MTLDevice) -> MTLBuffer? {
            device.makeBuffer(bytes: &uniforms,
                              length: MemoryLayout<Uniforms>.stride,
                              options: [])
        }
    }
    
    private let transitionDuration: Float
    
    @State private var uniformsProvider: FragmentUniforms
    @Binding private var transitionToggle: Bool
    @Binding private var viewSize: CGSize
    
    public init(
        viewSize: Binding<CGSize>,
        speed: Float = 0.4,
        transitionDuration: Float = 1.0,
        backgroundColor1: Color,
        backgroundColor2: Color,
        wave1Color1: Color,
        wave1Color2: Color,
        wave2Color1: Color,
        wave2Color2: Color,
        transitionToggle: Binding<Bool>)
    {
        self._viewSize = viewSize
        self.transitionDuration = transitionDuration
        self._transitionToggle = transitionToggle
        self.uniformsProvider = .init(
            uniforms: .init(
                time: 0,
                speed: speed,
                transition: 1.0,
                viewSize: viewSize.wrappedValue.toSIMD,
                backgroundColor1: backgroundColor1.toSIMD,
                backgroundColor2: backgroundColor2.toSIMD,
                wave1Color1: wave1Color1.toSIMD,
                wave1Color2: wave1Color2.toSIMD,
                wave2Color1: wave2Color1.toSIMD,
                wave2Color2: wave2Color2.toSIMD),
            startTime: CACurrentMediaTime())
    }
    
    public var body: some View {
        MetalShaderBackgroundView(shaderFragmentFunction: "background_wave_fragment",
                                  uniforms: uniformsProvider)
            .onChange(of: transitionToggle) { newValue in
                Tween(uniformsProvider)
                    .duration(1.0)
                    .ease(.inOutCubic)
                    .to(.key(\.uniforms.transition, newValue ? 1.0 : 0.0))
                    .play()
                }
            .onChange(of: viewSize) { newValue in
                uniformsProvider.uniforms.viewSize = newValue.toSIMD
            }
    }
}
