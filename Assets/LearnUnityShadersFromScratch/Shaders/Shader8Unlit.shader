Shader "NiksShaders/Shader8Unlit"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members position)
// #pragma exclude_renderers d3d11
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 position: TEXCOORD1;
                float2 uv : TEXCOORD0;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = v.vertex;
                o.uv = v.texcoord;
                return o;
            }

            float rect(float2 pt, float2 size, float2 center)
            {
                float2 p = pt- center;
                float2 halfsize = size * 0.5;
                // float horz = (p.x>-halfsize.x && p.x<halfsize.x) ? 1 : 0;
                float horz = step(-halfsize.x, p.x) - step(halfsize.x, p.x);
                float vert = step(-halfsize.y, p.y) - step(halfsize.y, p.y);
                return horz * vert;

                // return 1;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 pos = i.position.xy;
                float2 sizeY = (0.3);
                float2 sizeG = (0.4);
                float2 center = float2(0,0);
                float inRectYell = rect(pos, sizeY, center + 0.15);
                float inRectGreen = rect(pos, sizeG, center - 0.2);
                fixed3 color = (fixed3(1,1,0) * inRectYell) + (fixed3(0,1,0) * inRectGreen) ;
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
