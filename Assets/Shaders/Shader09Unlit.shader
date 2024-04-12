Shader "NiksShaders/Shader09Unlit"
{
    Properties
    {
        _Mouse("Mouse", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"  "RenderPipeline" = "UniversalPipeline" }
        LOD 100

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
            Vector _Mouse;
            CBUFFER_END

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

            float rect(float2 pt, float2 size, float2 center){
                float2 p = pt - center;
                float2 halfsize = size * 0.5;

                float horz = step(-halfsize.x, p.x) - step(halfsize.x, p.x);
                float vert = step(-halfsize.y, p.y) - step(halfsize.y, p.y);

                return horz * vert;
            }

            half4 frag (Varyings IN) : SV_Target
            {
                float2 pos = IN.uv;
                float square = rect(pos, float2(0.1,0.1), _Mouse.xy);
                half3 color = half3(1, 1, 0) * square; 
                return half4(color, 1);
            }

            ENDHLSL
        }
    }
}
