//
//  BackgroundWaveShader.metal
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/05/2022.
//

#include <metal_stdlib>
#include "MetalShaderBackgroundViewShaders.h"
using namespace metal;

struct WaveFragmentUniforms {
    float time;
    float speed;
    float transition;
    float2 viewSize;
    float4 backgroundColor1;
    float4 backgroundColor2;
    float4 wave1Color1;
    float4 wave1Color2;
    float4 wave2Color1;
    float4 wave2Color2;
};

fragment float4 background_wave_fragment(VertexOut vIn [[ stage_in ]],
                                         constant WaveFragmentUniforms &uniforms [[ buffer(0) ]]) {
    float4 baseColor = mix(uniforms.backgroundColor1, uniforms.backgroundColor2, uniforms.transition);
    float2 normalizedPosition = vIn.position.xy / uniforms.viewSize;
    
    float adjustedTime = uniforms.time * uniforms.speed;
    float wave1 = sin(adjustedTime + normalizedPosition.x * 3.0) * sin(adjustedTime + normalizedPosition.y * 2.0);
    wave1 = ((1.0 + wave1) / 8.0) + 0.2;
    
    float withinWave1 = (1.0 - smoothstep(normalizedPosition.y - 0.001, normalizedPosition.y + 0.001, wave1));
    if(withinWave1 > 0.0) {
        baseColor = mix(uniforms.wave1Color1, uniforms.wave1Color2, uniforms.transition);
    }
    
    float wave2 = cos(adjustedTime + 0.5 + normalizedPosition.y * 0.5) * sin(adjustedTime + 1.5 + normalizedPosition.x * 2.0);
    wave2 = ((1.0 + wave2) / 4.0) + 0.3;
    
    float withinWave2 = (1.0 - smoothstep(normalizedPosition.y - 0.001, normalizedPosition.y + 0.001, wave2));
    if(withinWave2 > 0.0) {
        baseColor = mix(uniforms.wave2Color1, uniforms.wave2Color2, uniforms.transition);
    }
    
    return baseColor;
}
