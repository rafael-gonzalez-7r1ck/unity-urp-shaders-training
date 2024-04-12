Shader "NiksShaders/Shader06Unlit"
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
                Varyings o;
                o.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                o.positionOS = IN.positionOS;
                o.uv = IN.texcoord;
                return o;
            }

            half4 frag (Varyings IN) : SV_Target
            {
                half3 color = (IN.positionOS * 2).xyz;
                color.r = smoothstep(0, 0.1, color.r);
                color.g = smoothstep(0, 0.1, color.g);
                return half4(color, 1.0);
            }
            ENDHLSL
        }
    }
}
