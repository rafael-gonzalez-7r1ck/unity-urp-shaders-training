Shader "NiksShaders/Shader34Unlit"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderPipeline" = "UniversalPipeline"}
        LOD 100

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
                sampler2D _MainTex;
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

            half4 frag (Varyings i) : SV_Target
            {
                float2 uv;
                float2 noise = float2(0,0);

                // Generate noisy y value
                uv = float2(i.uv.x*0.7 - 0.01, frac(i.uv.y - _Time.y*0.27));
                noise.y = (tex2D(_MainTex, uv).a-0.5)*2.0;
                uv = float2(i.uv.x*0.45 + 0.033, frac(i.uv.y*1.9 - _Time.y*0.61));
                noise.y += (tex2D(_MainTex, uv).a-0.5)*2.0;
                uv = float2(i.uv.x*0.8 - 0.02, frac(i.uv.y*2.5 - _Time.y*0.51));
                noise.y += (tex2D(_MainTex, uv).a-0.5)*2.0;

                noise = clamp(noise, -1.0, 1.0);

                float perturb = (1.0 - i.uv.y) * 0.35 + 0.02;
                noise = (noise * perturb) + i.uv - 0.02;

                half4 color = tex2D(_MainTex, noise);
                color = half4(color.r*2.0, color.g*0.9, (color.g/color.r)*0.2, 1.0);
                noise = clamp(noise, 0.05, 1.0);
                color.a = tex2D(_MainTex, noise).b*2.0;
                color.a = color.a*tex2D(_MainTex, i.uv).b;

                return color;
            }
            ENDHLSL
        }
    }
}

