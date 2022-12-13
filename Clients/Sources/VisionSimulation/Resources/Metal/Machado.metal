#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

extern "C" {

  namespace coreimage {
    half4 rgbMatrix(sample_h color, half3x3 transform) {
      half3 transformed = transform * color.rgb;
      return half4(transformed, color.a);
    }
  }

  namespace coreimage {
    half4 monochrome(sample_h color, half3 transform) {
      half3 transformed = dot(color.rgb, transform);
      return half4(transformed, color.a);
    }
  }
}
