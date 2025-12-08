Shader "NiksShaders/Shader14Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,0,1.0)
        _Radius("Radius", Float) = 0.3
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
                float4 position : TEXCOORD1;
                float2 uv: TEXCOORD0;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = v.vertex;
                o.uv = v.texcoord;
                return o;
            }

            float circle(float2 pt, float2 center, float radius)
            {
                float2 p = pt - center;
                return 1.0 - step(radius,length(p));

            }

            float circle(float2 pt, float2 center, float radius, bool soften)
            {
                float2 p = pt - center;
                float2 edge = (soften) ? radius * 0.005 : 0.0;
                // return 1.0 - step(radius,length(p));
                return 1.0 - smoothstep(radius-edge, radius+edge, length(p) );

            }

            
            float circle(float2 pt, float2 center, float radius, float line_width)
            {
                float2 p = pt - center;
                float len = length(p);
                float half_line_width = line_width/2.0;

                return step(radius - half_line_width, len) - step(radius + half_line_width, len);

            }
           
            fixed4 _Color;
            float _Radius;
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 pos = i.position * 2;
                // fixed3 color = _Color * circle(pos, float2(0,0), _Radius);
                // fixed3 color = _Color * circle(pos, float2(0,0), _Radius, true);
                fixed3 color = _Color * circle(pos, float2(0,0), _Radius, _Radius* 0.1);
                
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
