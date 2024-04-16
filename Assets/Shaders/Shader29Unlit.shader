Shader "NiksShaders/Shader29Unlit"
{
    Properties
    {
        _ColorA("Color A", Color) = (1,0,0,1)
        _ColorB("Color B", Color) = (1,1,0,1)
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
                half4 _ColorA;
                half4 _ColorB;
            CBUFFER_END

            float random (float2 pt) {
                const float a = 12.9898;
                const float b = 78.233;
                const float c = 43758.543123;
                return frac(sin(dot(pt, float2(a, b))) * c );
            }

            // 2D Noise based on Morgan McGuire @morgan3d
            // https://www.shadertoy.com/view/4dS3Wd
            float noise (float2 st) {
                float2 i = floor(st);
                float2 f = frac(st);

                // Four corners in 2D of a tile
                float a = random(i);
                float b = random(i + float2(1.0, 0.0));
                float c = random(i + float2(0.0, 1.0));
                float d = random(i + float2(1.0, 1.0));

                // Smooth Interpolation

                // Cubic Hermine Curve.  Same as SmoothStep()
                float2 u = f*f*(3.0-2.0*f);
                // u = smoothstep(0.,1.,f);

                // Mix 4 coorners percentages
                return lerp(a, b, u.x) +
                (c - a)* u.y * (1.0 - u.x) +
                (d - b) * u.x * u.y;
            }

            half4 frag (Varyings i) : SV_Target
            {
                // Add noise layers
                float2 pos = float2(i.uv.x * 0.5 - 0.033, i.uv.y * 2 - _Time.y * 0.12);
                float n = noise(pos * 18);

                pos = float2(i.uv.x * 0.94 + 0.02, i.uv.y - _Time.y * 0.61);
                n =+ noise(pos * 11);

                n+= noise(pos * 9);
                n /= 3;

                half3 color = lerp(_ColorA.rgb, _ColorB.rgb, n);
                
                return half4(color, 1.0);
            }
            ENDHLSL
        }
    }
}
