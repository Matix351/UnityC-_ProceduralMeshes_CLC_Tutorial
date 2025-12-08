Shader "Matix351/OverlayDissolve"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _PatternTex ("Pattern Texture (RGB/A)", 2D) = "white" {}
        _PatternOffset ("Pattern Offset (UV)", Vector) = (0,0,0,0)
        _DissolveAmount ("Dissolve (0=Visible, 1=Hidden)", Range(0, 1)) = 0.0
    }

    SubShader
    {
        Tags { "RenderType"="AlphaTest" "Queue"="AlphaTest" } 
        LOD 100

        Pass
        {
            ZWrite On
            
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


            sampler2D _PatternTex;
            float4 _PatternTex_ST; 
            float4 _BaseColor;
            float2 _PatternOffset;
            float _DissolveAmount; 


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _PatternTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 finalColor = _BaseColor;

                float2 offsetUV = i.uv + _PatternOffset;
                fixed4 patternColor = tex2D(_PatternTex, offsetUV);
                
                finalColor.rgb = lerp(finalColor.rgb, patternColor.rgb, patternColor.a);

                float dissolveMask = i.uv.y; 
                
                float discardThreshold = 1.0 - _DissolveAmount;

                clip(dissolveMask - discardThreshold); 
                

                return finalColor;
            }
            ENDCG
        }
    }
    FallBack "Standard"
}