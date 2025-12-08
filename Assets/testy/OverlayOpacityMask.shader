Shader "Matix351/OverlayOpacityMask"

{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _PatternTex ("Pattern Texture (RGB/A)", 2D) = "black" {} 
        _PatternOffset ("Pattern Offset (UV)", Vector) = (0,0,0,0)
        _AlphaMask ("Alpha Mask (White=Transparent, Black=Opaque)", 2D) = "white" {} // New Mask Property
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off 

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
            sampler2D _AlphaMask;
            float4 _AlphaMask_ST; 
            float4 _BaseColor;
            float2 _PatternOffset;


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
                
                float2 offsetUV = i.uv + (_Time.x*_PatternOffset);
                // float2 offsetUV = i.uv + _PatternOffset;

                fixed4 patternColor = tex2D(_PatternTex, offsetUV);
                finalColor.rgb = lerp(finalColor.rgb, patternColor.rgb, patternColor.a);
                finalColor.a = _BaseColor.a;
                
                fixed4 maskColor = tex2D(_AlphaMask, i.uv);
                float invertedMaskValue = 1.0 - maskColor.r; 
                finalColor.a *= invertedMaskValue;
                
                return finalColor;
            }
            ENDCG
        }
    }
}