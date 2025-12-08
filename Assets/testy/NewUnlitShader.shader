Shader "Custom/MovingFadeTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Base Color", Color) = (1,1,1,1)
        _Offset ("Texture Offset", Vector) = (0,0,0,0)
        _Fade ("Fade Amount", Range(0,1)) = 0
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float2 _Offset;
            float _Fade;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // Apply texture offset
                o.uv = v.uv + _Offset;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Sample texture
                fixed4 texCol = tex2D(_MainTex, i.uv);
                
                // Multiply with base color
                fixed4 col = texCol * _Color;

                // Fade from top to bottom
                // i.vertex.y in clip space is -1 (bottom) to +1 (top)
                float fade = saturate((i.vertex.y * 0.5 + 0.5 - _Fade) / (1.0 - _Fade));
                col.a *= fade;

                return col;
            }
            ENDCG
        }
    }
}
