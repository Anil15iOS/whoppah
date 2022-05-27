//
//  MetalShaderBackgroundViewShaders.metal
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/05/2022.
//

#include <metal_stdlib>
using namespace metal;
#include "MetalShaderBackgroundViewShaders.h"

vertex VertexOut background_shader_vertex_function(const device VertexIn *vertices [[ buffer(0) ]],
                                                   uint vertexID [[ vertex_id ]])
{
    VertexOut vOut;
    vOut.position = float4(vertices[vertexID].position, 1);
    return vOut;
}
