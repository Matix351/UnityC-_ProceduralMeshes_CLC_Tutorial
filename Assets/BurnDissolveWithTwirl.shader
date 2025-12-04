Shader "Custom/2D_DissolveTwirl"
{
    Properties
    {
        [PerRendererData]_MainTex("Sprite Texture", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _DissolveAmount("Dissolve Amount", Range(0,1)) = 0
        _EdgeColor("Edge Color", Color) = (0.2,0.6,1,1)
        _EdgeWidth("Edge Width", Range(0,0.2)) = 0.05
        _TwirlStrength("Twirl Strength", Range(0,10)) = 3
        _TwirlCenter("Twirl Center", Vector) = (0.5,0.5,0,0)
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off Lighting Off ZWrite Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float4 _MainTex_ST;
            float _DissolveAmount;
            float _EdgeWidth;
            float4 _EdgeColor;
            float _TwirlStrength;
            float2 _TwirlCenter;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            float2 TwirlUV(float2 uv, float2 center, float strength)
            {
                float2 delta = uv - center;
                float dist = length(delta);
                float angle = strength * dist;
                float s = sin(angle);
                float c = cos(angle);
                float2 rotated = float2(c * delta.x - s * delta.y, s * delta.x + c * delta.y);
                return rotated + center;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 twirledUV = TwirlUV(i.uv, _TwirlCenter, _TwirlStrength * (1 - _DissolveAmount));
                fixed4 mainCol = tex2D(_MainTex, twirledUV) * i.color;
                float noise = tex2D(_NoiseTex, twirledUV).r;

                float edge = smoothstep(_DissolveAmount - _EdgeWidth, _DissolveAmount, noise);
                float alpha = edge;
                float edgeMask = step(noise, _DissolveAmount) * step(_DissolveAmount - _EdgeWidth, noise);
                fixed4 edgeCol = _EdgeColor * edgeMask;

                return (mainCol * alpha) + edgeCol;
            }
            ENDCG
        }
    }
}
