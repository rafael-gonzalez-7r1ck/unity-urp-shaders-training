Shader "NiksShaders/Shader08Unlit"
{
    Properties
    {
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

            float rect(float2 pt, float2 size, float2 center)
            {
                float2 p = pt - center;
                float2 halfSize = size * 0.5;
                
                float horz = step(-halfSize.x, p.x) - step(halfSize.x, p.x);
                float vert = step(-halfSize.y, p.y) - step(halfSize.y, p.y);

                return horz * vert;
            }

            half4 frag (Varyings IN) : SV_Target
            {
                float2 pos = IN.positionOS.xy;
               
                float2 size1 = 0.3;
                float2 center1 = float2 (-0.25, 0);
                float inRect1 = rect(pos, size1, center1);
                half3 color1 = half3(1,1,0) * inRect1;

                float2 size2 = 0.4;
                float2 center2 = float2 (0.25, 0);
                float inRect2 = rect(pos, size2, center2);
                half3 color2 = half3(0,1,0) * inRect2;

                return half4(color1 + color2, 1.0);
            }
            ENDHLSL
        }
    }
}
