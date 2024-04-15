Shader "NiksShaders/Shader13Unlit"
{
    Properties
    {
        _Color("Square Color", Color) = (1.0,1.0,0,1.0)
        _Size("Size", Float) = 0.3
        _Anchor("Anchor", Vector) = (0.0, 0.0, 0.5, 0.5)
        _TileCount("Tile Count", Int) = 6
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
                float _Size;
                float4 _Anchor;
                int _TileCount;
                
            CBUFFER_END

            
            float rect(float2 pt, float2 size, float2 center){
                //return 0 if not in rect and 1 if it is
                //step(edge, x) 0.0 is returned if x < edge, and 1.0 is returned otherwise.
                float2 p = pt - center;
                float2 halfsize = size/2.0;
                float horz = step(-halfsize.x, p.x) - step(halfsize.x, p.x);
                float vert = step(-halfsize.y, p.y) - step(halfsize.y, p.y);
                return horz*vert;
            }

            float rect(float2 pt, float2 anchor, float2 size, float2 center){
                //return 0 if not in rect and 1 if it is
                //step(edge, x) 0.0 is returned if x < edge, and 1.0 is returned otherwise.
                float2 p = pt - center;
                float2 halfsize = size/2.0;
                float horz = step(-halfsize.x - anchor.x, p.x) - step(halfsize.x - anchor.x, p.x);
                float vert = step(-halfsize.y - anchor.y, p.y) - step(halfsize.y - anchor.y, p.y);
                return horz*vert;
            }

            float2x2 getRotationMatrix(float theta){
                float s = sin(theta);
                float c = cos(theta);
                return float2x2(c, -s, s, c);
            }

            float2x2 getScaleMatrix(float scale){
                return float2x2(scale,0,0,scale);
            }
            
            half4 frag (Varyings IN) : SV_Target
            {
                float2 center = _Anchor.zw;
                float2 pos = frac(IN.uv * _TileCount);
                float2x2 matr = getRotationMatrix(_Time.y);
                float2x2 mats = getScaleMatrix((sin(_Time.y) + 1)/3 + 0.5);
                float2x2 mat = mul(matr, mats);
                
                float2 pt = mul(mat, pos - center) + center;
                
                float3 color = _Color.xyz * rect(pt, _Anchor.xy, float2(_Size, _Size), center);
                
                return half4(color, 1.0);
            }
            ENDHLSL
        }
    }
}
