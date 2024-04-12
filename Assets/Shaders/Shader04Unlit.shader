Shader "NiksShaders/Shader04Unlit"
{
    Properties
    {
        _ColorA("Color A", Color) = (1,0,0,1)
        _ColorB("Color B", Color) = (0,0,1,1) 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            CBUFFER_START(UnityPerMaterial)
            fixed4 _ColorA;
            fixed4 _ColorB;
            CBUFFER_END

            fixed4 frag (v2f_img i) : SV_Target
            {
                float delta = i.uv.x;
                float3 color = lerp(_ColorA, _ColorB, delta);
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
