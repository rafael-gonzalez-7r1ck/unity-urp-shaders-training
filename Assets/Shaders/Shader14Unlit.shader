Shader "NiksShaders/Shader14Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,0,1.0)
        _Radius("Radius", Float) = 0.3
        _Outline("Outline", Float) = 0.01
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
            
            CBUFFER_START(UnityPerMaterial)

                half4 _Color;
                float _Radius;
                float _Outline;
                
            CBUFFER_END

            float circle(float2 pt, float2 center, float radius, bool soften)
            {
                float2 p = pt - center;
                float edge = soften ? 0.02 : 0;
                return 1 - smoothstep(radius - edge, radius + edge, length(p));
            }

            float circle(float2 pt, float2 center, float radius, float outline)
            {
                float2 p = pt - center;
                float len = length(p);
                float halfOutline = outline / 2;

                return smoothstep(radius - halfOutline, radius, len) - smoothstep(radius, radius + halfOutline, len);
            }
            
            half4 frag (Varyings IN) : SV_Target
            {
                float2 pos = IN.positionOS.xy * 2;
                half3 color = _Color.xyz * circle(pos, float2(0,0), _Radius, _Outline);
                
                return half4(color, 1.0);
            }
            ENDHLSL
        }
    }
}
