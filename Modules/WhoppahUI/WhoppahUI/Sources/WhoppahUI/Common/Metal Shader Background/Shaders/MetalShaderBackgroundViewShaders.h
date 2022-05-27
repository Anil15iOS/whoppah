//
//  MetalShaderBackgroundViewShaders.h
//  WhoppahUI
//
//  Created by Dennis Ippel on 13/05/2022.
//

#ifndef Header_h
#define Header_h

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position;
};

struct VertexOut {
    float4 position [[ position ]];
};

vertex VertexOut background_shader_vertex_function(const device VertexIn *vertices [[ buffer(0) ]],
                                                   uint vertexID [[ vertex_id ]]);

#endif
