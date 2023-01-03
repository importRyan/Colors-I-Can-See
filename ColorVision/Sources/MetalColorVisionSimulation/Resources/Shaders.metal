// Copyright 2022 by Ryan Ferrell. @importRyan

#include <metal_stdlib>
using namespace metal;

// Convenience for compute

kernel void computeTransform(constant float3x3 & transform [[buffer(0)]],
                             texture2d<float, access::read> inTexture [[ texture (0) ]],
                             texture2d<float, access::read_write> outTexture [[ texture (1) ]],
                             uint2 gid [[ thread_position_in_grid ]]) {
  float4 color = inTexture.read(gid).rgba;
  float3 transformed = transform * float3(color.rgb);
  outTexture.write(float4(transformed, color.a), gid);
}

// Convenience for Core Video

typedef struct {
  float4 renderedCoordinate [[position]];
  float2 textureCoordinate;
} TextureMappingVertex;

vertex TextureMappingVertex orientPixels(unsigned int vertex_id [[ vertex_id ]]) {
  float4x4 renderedCoordinates = float4x4(float4( -1.0, -1.0, 0.0, 1.0 ),
                                          float4(  1.0, -1.0, 0.0, 1.0 ),
                                          float4( -1.0,  1.0, 0.0, 1.0 ),
                                          float4(  1.0,  1.0, 0.0, 1.0 ));
  float4x2 textureCoordinates = float4x2(float2( 0.0, 1.0 ),
                                         float2( 1.0, 1.0 ),
                                         float2( 0.0, 0.0 ),
                                         float2( 1.0, 0.0 ));
  TextureMappingVertex outVertex;
  outVertex.renderedCoordinate = renderedCoordinates[vertex_id];
  outVertex.textureCoordinate = textureCoordinates[vertex_id];
  return outVertex;
}

fragment float4 renderTransform(constant float3x3 & transform [[buffer(0)]],
                               TextureMappingVertex mappingVertex [[ stage_in ]],
                               texture2d<float, access::sample> texture [[ texture(0) ]]) {
  constexpr sampler s(address::clamp_to_edge, filter::linear);
  vector_float4 color = texture.sample(s, mappingVertex.textureCoordinate);
  float3 transformedColor = transform * float3(color.rgb);
  return float4(transformedColor, color.a);
}

