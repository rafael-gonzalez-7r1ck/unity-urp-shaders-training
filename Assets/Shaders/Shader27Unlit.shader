Shader "NiksShaders/Shader27Unlit"
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

            float random (float2 pt, float seed) {
                const float a = 12.9898;
                const float b = 78.233;
                const float c = 43758.543123;
                return frac(sin(dot(pt, float2(a, b)) + seed) * c );
            }

            half4 frag (Varyings IN) : SV_Target
            {
                half3 color = random(IN.uv, _Time.y) * half3(1,1,1);
                
                return half4(color, 1.0);
            }
            ENDHLSL
        }
    }
}
