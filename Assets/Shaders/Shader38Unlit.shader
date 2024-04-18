Shader "NiksShaders/Shader38Unlit"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _Duration("Duration", float) = 6.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv:TEXCOORD0;
                float4 position: TEXCOORD1;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.position = v.vertex;
                return o;
            }
            
            CBUFFER_START(UnityPerMaterial)
            sampler2D _MainTex;
            float _Duration;
            CBUFFER_END

            float2 rotate(float2 pt, float theta, float aspect)
            {
                float c = cos(theta);
                float s = sin(theta);
                float2x2 mat = float2x2(c,s,-s,c);
                pt.y /= aspect;
                pt = mul(pt, mat);
                pt.y *= aspect;
                return pt;
            }

            float4 frag (v2f i) : COLOR
            {
                // Rotating texture
                // float2 center = 0.5;
                // float2 uv = rotate(i.uv - center, _Time.y, 2.0/1.5) + center;
                // fixed3 color;

                // if(uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1)
                // {
                    //     color = fixed3(0,0,0);
                // }
                // else
                // {
                    //     color = tex2D(_MainTex, uv).rgb;
                // }

                //Ripple texture
                float2 pos = i.position.xy * 2;
                float len = length(pos);
                float2 ripple = i.uv + pos/len * 0.3 * cos(len * 12 - _Time.y * 4);
                float theta = fmod(_Time.y, _Duration) * (UNITY_TWO_PI / _Duration);
                float delta = (sin(theta) + 1) / 2;
                float2 uv = lerp(ripple, i.uv, delta);
                fixed3 color= tex2D(_MainTex, uv).rgb;

                return fixed4( color, 1.0 );
            }
            ENDCG
        }
    }
}

