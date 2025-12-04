Shader "Custom/2D_DissolveBurn"
{
    Properties
    {
        [PerRendererData]_MainTex("Sprite Texture", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _DissolveAmount("Dissolve Amount", Range(0,1)) = 0
        _EdgeColor("Edge Color", Color) = (1,0.5,0,1)
        _EdgeWidth("Edge Width", Range(0,0.2)) = 0.05
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
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

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 mainCol = tex2D(_MainTex, i.uv) * i.color;
                float noise = tex2D(_NoiseTex, i.uv).r;

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
