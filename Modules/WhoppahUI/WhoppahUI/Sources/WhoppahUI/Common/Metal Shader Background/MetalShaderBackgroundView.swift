//
//  MetalShaderBackgroundView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/05/2022.
//

import Foundation
import MetalKit
import SwiftUI

public protocol ShaderUniformsProvider {
    func update(buffer: inout MTLBuffer)
    mutating func makeBuffer(usingDevice device: MTLDevice) -> MTLBuffer?
}

public struct MetalShaderBackgroundView: UIViewRepresentable {
    private let shaderFragmentFunction: String
    private let uniforms: ShaderUniformsProvider
    
    public init(shaderFragmentFunction: String,
                uniforms: ShaderUniformsProvider) {
        self.shaderFragmentFunction = shaderFragmentFunction
        self.uniforms = uniforms
    }
    
    public func makeUIView(context: Context) -> MetalShaderView {
        .init(shaderFragmentFunction: shaderFragmentFunction,
              uniforms: uniforms)
    }
    
    public func updateUIView(_ uiView: MetalShaderView, context: Context) {
        
    }
}

public class MetalShaderView: MTKView {
    private let shaderFragmentFunction: String
    private var renderer: Renderer?
    private let uniforms: ShaderUniformsProvider
    
    init(shaderFragmentFunction: String,
         uniforms: ShaderUniformsProvider)
    {
        self.shaderFragmentFunction = shaderFragmentFunction
        self.uniforms = uniforms
        
        super.init(frame: .zero, device: MTLCreateSystemDefaultDevice())
        
        colorPixelFormat = .bgra8Unorm
        clearColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        preferredFramesPerSecond = 60
        enableSetNeedsDisplay = false
        isPaused = false
        createRenderer()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createRenderer() {
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        renderer = Renderer(withDevice: device,
                            shaderFragmentFunction: shaderFragmentFunction,
                            uniforms: uniforms)
        delegate = renderer
    }
}

fileprivate class Renderer: NSObject {
    private struct Vertex {
        var position: SIMD3<Float>
    }
    
    private let vertices: [Vertex] = [
        .init(position: [-1,  1, 0]),
        .init(position: [ 1,  1, 0]),
        .init(position: [ 1, -1, 0]),
        
        .init(position: [-1,  1, 0]),
        .init(position: [ 1, -1, 0]),
        .init(position: [-1, -1, 0])
    ]
    
    private var commandQueue: MTLCommandQueue?
    private var commandBuffer: MTLCommandBuffer?
    private var renderPipelineState: MTLRenderPipelineState?
    private var vertexBuffer: MTLBuffer?
    
    private let device: MTLDevice
    private let shaderFragmentFunction: String
    private let vertexFragmentFunction = "background_shader_vertex_function"
    
    fileprivate var uniforms: ShaderUniformsProvider
    fileprivate var uniformsBuffer: MTLBuffer?
    
    init(withDevice device: MTLDevice,
         shaderFragmentFunction: String,
         uniforms: ShaderUniformsProvider)
    {
        self.device = device
        self.shaderFragmentFunction = shaderFragmentFunction
        self.uniforms = uniforms
        
        super.init()
        
        self.createCommandQueue()
        self.createPipelineState()
        self.createBuffers()
    }
    
    private func createCommandQueue() {
        self.commandQueue = device.makeCommandQueue()
    }
    
    private func createPipelineState() {
        let library = try? device.makeDefaultLibrary(bundle: .module)
        let vertexFunction = library?.makeFunction(name: vertexFragmentFunction)
        let fragmentFunction = library?.makeFunction(name: shaderFragmentFunction)
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        renderPipelineState = try? device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
    }
    
    private func createBuffers() {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: MemoryLayout<Vertex>.stride * vertices.count,
                                         options: [])
        uniformsBuffer = uniforms.makeBuffer(usingDevice: device)
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let renderPipelineState = renderPipelineState,
              var uniformsBuffer = uniformsBuffer
        else { return }
        
        uniforms.update(buffer: &uniformsBuffer)
        
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer,
                                        offset: 0,
                                        index: 0)
        commandEncoder?.setFragmentBuffer(uniformsBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle,
                                       vertexStart: 0,
                                       vertexCount: vertices.count)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
