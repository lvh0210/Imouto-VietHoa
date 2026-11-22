Shader "Naninovel/TransitionalTexture" {
    Properties {
        _MainTex ("Main Texture", 2D) = "black" {}
        _TransitionTex ("Transition Texture", 2D) = "black" {}
        _CloudsTex ("Clouds Texture", 2D) = "black" {}
        _DissolveTex ("Dissolve Texture", 2D) = "black" {}
        _TransitionProgress ("Transition Progress", Range(0, 1)) = 0
        _TransitionParams ("Transition Parameters", Vector) = (1,1,1,1)
        _TintColor ("Tint Color", Color) = (1,1,1,1)
    }
    SubShader {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
        Cull Off
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            Tags { "LightMode"="UniversalForward" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            sampler2D _MainTex;
            sampler2D _TransitionTex;
            sampler2D _DissolveTex;
            float4 _MainTex_ST;
            float _TransitionProgress;
            fixed4 _TintColor;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color * _TintColor;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                fixed4 colA = tex2D(_MainTex, i.uv);
                fixed4 colB = tex2D(_TransitionTex, i.uv);
                fixed4 result = lerp(colA, colB, saturate(_TransitionProgress));
                return result * i.color;
            }
            ENDCG
        }
        Pass {
            Tags { "LightMode"="SRPDefaultUnlit" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            sampler2D _MainTex;
            sampler2D _TransitionTex;
            float4 _MainTex_ST;
            float _TransitionProgress;
            fixed4 _TintColor;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color * _TintColor;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                fixed4 colA = tex2D(_MainTex, i.uv);
                fixed4 colB = tex2D(_TransitionTex, i.uv);
                fixed4 result = lerp(colA, colB, saturate(_TransitionProgress));
                return result * i.color;
            }
            ENDCG
        }
    }
}
