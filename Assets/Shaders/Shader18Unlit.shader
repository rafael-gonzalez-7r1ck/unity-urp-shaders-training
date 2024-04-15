Shader "NiksShaders/Shader18Unlit"
{
    Properties
    {
        _AxisColor("Axis Color", Color) = (0.8, 0.8, 0.8, 1)
        _SweepColor("Sweep Color", Color) = (0.1, 0.3, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" }
        LOD 100

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float2 texcoord     : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                float4 positionOS   : TEXCOORD1;
                float2 uv           : TEXCOORD0;
            };

            Varyings vert (Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.positionOS = IN.positionOS;
                OUT.uv = IN.texcoord;
                return OUT;
            }
            
            float getDelta(float x){
                return (sin(x)+1.0)/2.0;
            }

            float sweep(float2 pt, float2 center, float radius, float line_width, float edge_thickness){
                float2 d = pt - center;
                float theta = _Time.z;
                float2 p = float2(cos(theta), -sin(theta))*radius;
                float h = clamp( dot(d,p)/dot(p,p), 0.0, 1.0 );
                float l = length(d - p*h);

                float gradient = 0;
                const float GRADIENT_ANGLE = PI * 0.5;

                if (length(d) < radius)
                {
                    float angle = fmod(theta + atan2(d.y, d.x), TWO_PI);
                    gradient = clamp(GRADIENT_ANGLE - angle, 0, GRADIENT_ANGLE)/ GRADIENT_ANGLE * 0.5;
                }

                return gradient + 1.0 - smoothstep(line_width, line_width+edge_thickness, l);
            }

            float circle(float2 pt, float2 center, float radius, float line_width, float edge_thickness){
                pt -= center;
                float len = length(pt);
                float result = smoothstep(radius-line_width/2.0-edge_thickness, radius-line_width/2.0, len) - smoothstep(radius + line_width/2.0, radius + line_width/2.0 + edge_thickness, len);

                return result;
            }

            float onLine(float x, float y, float line_width, float edge_width){
                return smoothstep(x-line_width/2.0-edge_width, x-line_width/2.0, y) - smoothstep(x+line_width/2.0, x+line_width/2.0+edge_width, y);
            }
            
            CBUFFER_START(UnityPerMaterial)

            half4 _AxisColor;
            half4 _SweepColor;

            CBUFFER_END

            half4 frag (Varyings IN) : SV_Target
            {
                half3 color = onLine(IN.uv.y, 0.5, 0.002, 0.001) * _AxisColor.rgb;//xAxis
                color += onLine(IN.uv.x, 0.5, 0.002, 0.001) * _AxisColor.rgb;//yAxis

                float2 center = 0.5;
                color += circle(IN.uv, center, 0.3, 0.002, 0.001);
                color += circle(IN.uv, center, 0.2, 0.002, 0.001);
                color += circle(IN.uv, center, 0.1, 0.002, 0.001);

                color += sweep(IN.uv, center, 0.3, 0.002, 0.001) * _SweepColor.rgb;
                
                return half4(color, 1.0);
            }
            ENDHLSL
        }
    }
}
