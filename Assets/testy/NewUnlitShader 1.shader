Shader "Custom/OverlayOffsetPattern"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _PatternTex ("Pattern Texture (RGB/A)", 2D) = "white" {}
        _PatternOffset ("Pattern Offset (UV)", Vector) = (0,0,0,0)
    }

    SubShader
    {
        // Changed to "Transparent" to allow for the pattern's alpha blending
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100

        Pass
        {
            // Set up Alpha Blending for the pattern overlay
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off // Don't write to the Z-buffer for transparent objects

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            // --- CBUFFER (Properties) ---
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0; // Main UVs
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // Properties
            sampler2D _PatternTex;
            float4 _PatternTex_ST; // Auto-generated for texture tiling/offset
            float4 _BaseColor;
            float2 _PatternOffset;


            // --- Vertex Shader ---
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // Transform UVs with the texture tiling/offset properties
                o.uv = TRANSFORM_TEX(v.uv, _PatternTex);
                return o;
            }

            // --- Fragment Shader ---
            fixed4 frag (v2f i) : SV_Target
            {
                // 1. Calculate Base Color
                fixed4 finalColor = _BaseColor;

                // 2. Calculate Pattern Texture Color with Offset
                // Apply the user-defined offset to the UVs
                float2 offsetUV = i.uv + _PatternOffset;
                fixed4 patternColor = tex2D(_PatternTex, offsetUV);
                
                // 3. Overlay the pattern on the Base Color
                // We use lerp to blend patternColor.rgb over finalColor.rgb, using patternColor.a as the blending factor.
                finalColor.rgb = lerp(finalColor.rgb, patternColor.rgb, patternColor.a);
                // Note: The resulting alpha of finalColor is still _BaseColor.a. 
                // We keep the Base Color's alpha to control the overall material transparency.
                
                return finalColor;
            }
            ENDCG
        }
    }
}