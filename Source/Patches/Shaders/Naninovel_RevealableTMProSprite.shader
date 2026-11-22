Shader "Naninovel/RevealableTMProSprite" {
    Properties {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        _ClipRect ("Clip Rect", Vector) = (-32767,-32767,32767,32767)
        _LineClipRect ("Lines Clip Rect", Vector) = (0,0,0,0)
        _CharClipRect ("Characters Clip Rect", Vector) = (0,0,0,0)
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
            #include "UnityUI.cginc"

            struct appdata {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 uv : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float4 _ClipRect;
            float4 _LineClipRect;
            float4 _CharClipRect;

            v2f vert(appdata v) {
                v2f o;
                o.worldPosition = v.vertex;
                o.vertex = UnityObjectToClipPos(o.worldPosition);
                o.color = v.color * _Color;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv) * i.color;

                #ifdef UNITY_UI_CLIP_RECT
                col.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
                #endif

                if (any(_CharClipRect.zw > _CharClipRect.xy)) {
                    float2 inChar = step(_CharClipRect.xy, i.worldPosition.xy) * step(i.worldPosition.xy, _CharClipRect.zw);
                    float2 inLine = step(_LineClipRect.xy, i.worldPosition.xy) * step(i.worldPosition.xy, _LineClipRect.zw);
                    col.a *= max(inChar.x * inChar.y, inLine.x * inLine.y);
                }

                clip(col.a - 0.001);
                return col;
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
            #include "UnityUI.cginc"

            struct appdata {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 uv : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float4 _ClipRect;
            float4 _LineClipRect;
            float4 _CharClipRect;

            v2f vert(appdata v) {
                v2f o;
                o.worldPosition = v.vertex;
                o.vertex = UnityObjectToClipPos(o.worldPosition);
                o.color = v.color * _Color;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv) * i.color;

                #ifdef UNITY_UI_CLIP_RECT
                col.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
                #endif

                if (any(_CharClipRect.zw > _CharClipRect.xy)) {
                    float2 inChar = step(_CharClipRect.xy, i.worldPosition.xy) * step(i.worldPosition.xy, _CharClipRect.zw);
                    float2 inLine = step(_LineClipRect.xy, i.worldPosition.xy) * step(i.worldPosition.xy, _LineClipRect.zw);
                    col.a *= max(inChar.x * inChar.y, inLine.x * inLine.y);
                }

                clip(col.a - 0.001);
                return col;
            }
            ENDCG
        }
    }
}
