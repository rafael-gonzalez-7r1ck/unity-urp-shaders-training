Shader "NiksShaders/Shader16Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,1.0,1.0)
        _LineWidth("Line Width", Float) = 0.01
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
                float4 screenPos    : TEXCOORD2;
                float2 uv           : TEXCOORD0;
            };

            Varyings vert (Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.positionOS = IN.positionOS;
                OUT.screenPos = ComputeScreenPos(OUT.positionHCS);
                OUT.uv = IN.texcoord;
                return OUT;
            }

            CBUFFER_START(UnityPerMaterial)

                half4 _Color;
                float _LineWidth;

            CBUFFER_END
            
            float getDelta( float x ){
                return (sin(x) + 1.0)/2.0;
            }

            float onLine(float a, float b, float line_width, float edge_thickness)
            {
                float half_line_width = line_width / 2;
                float lineStart = smoothstep(a - half_line_width - edge_thickness, a - half_line_width, b);
                float lineEnd = smoothstep(a + half_line_width, a + half_line_width + edge_thickness, b);
                return lineStart - lineEnd;
            }
            
            half4 frag (Varyings i) : SV_Target
            {
                float2 uv = i.uv;
                half3 color = _Color * onLine(uv.y, lerp(0.1, 0.9, getDelta(uv.x * PI * 2)), 0.05, 0.002);
                
                return half4(color, 1.0);
            }
            ENDHLSL
        }
    }
}
