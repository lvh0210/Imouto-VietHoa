Shader "Naninovel/RevealableTMProText" {
    Properties {
        _FaceColor ("Face Color", Color) = (1,1,1,1)
        _FaceDilate ("Face Dilate", Range(-1, 1)) = 0
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _OutlineWidth ("Outline Thickness", Range(0, 1)) = 0
        _OutlineSoftness ("Outline Softness", Range(0, 1)) = 0
        _UnderlayColor ("Border Color", Color) = (0,0,0,0.5)
        _UnderlayOffsetX ("Border OffsetX", Range(-1, 1)) = 0
        _UnderlayOffsetY ("Border OffsetY", Range(-1, 1)) = 0
        _UnderlayDilate ("Border Dilate", Range(-1, 1)) = 0
        _UnderlaySoftness ("Border Softness", Range(0, 1)) = 0
        _WeightNormal ("Weight Normal", Float) = 0
        _WeightBold ("Weight Bold", Float) = 0.5
        _ShaderFlags ("Flags", Float) = 0
        _ScaleRatioA ("Scale RatioA", Float) = 1
        _ScaleRatioB ("Scale RatioB", Float) = 1
        _ScaleRatioC ("Scale RatioC", Float) = 1
        _MainTex ("Font Atlas", 2D) = "white" {}
        _TextureWidth ("Texture Width", Float) = 512
        _TextureHeight ("Texture Height", Float) = 512
        _GradientScale ("Gradient Scale", Float) = 5
        _ScaleX ("Scale X", Float) = 1
        _ScaleY ("Scale Y", Float) = 1
        _PerspectiveFilter ("Perspective Correction", Range(0, 1)) = 0.875
        _VertexOffsetX ("Vertex OffsetX", Float) = 0
        _VertexOffsetY ("Vertex OffsetY", Float) = 0
        _ClipRect ("Clip Rect", Vector) = (-32767,-32767,32767,32767)
        _MaskSoftnessX ("Mask SoftnessX", Float) = 0
        _MaskSoftnessY ("Mask SoftnessY", Float) = 0
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _CullMode ("Cull Mode", Float) = 0
        _ColorMask ("Color Mask", Float) = 15
        _LineClipRect ("Lines Clip Rect", Vector) = (0,0,0,0)
        _CharClipRect ("Characters Clip Rect", Vector) = (0,0,0,0)
        _CharFadeWidth ("Characters Fade Width", Float) = 0
        _CharSlantAngle ("Characters Slate Angle", Float) = 0
    }
    SubShader {
        Tags {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
        }
        Stencil {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }
        Cull [_CullMode]
        ZWrite Off
        Lighting Off
        Fog { Mode Off }
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]

        Pass {
            Tags { "LightMode"="UniversalForward" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
            };

            sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform fixed4 _FaceColor;
            uniform float _FaceDilate;
            uniform float _OutlineWidth;
            uniform float _OutlineSoftness;
            uniform fixed4 _OutlineColor;
            uniform float _GradientScale;
            uniform float4 _ClipRect;
            uniform float4 _LineClipRect;
            uniform float4 _CharClipRect;
            uniform float _CharFadeWidth;

            v2f vert(appdata_t v) {
                v2f o;
                o.worldPosition = v.vertex;
                o.vertex = UnityObjectToClipPos(o.worldPosition);
                o.color = v.color * _FaceColor;
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                half d = tex2D(_MainTex, i.texcoord).a;
                half scale = max(_GradientScale * 1.5, 1.0);
                half faceAlpha = saturate((d - (0.5 - _FaceDilate)) * scale + 0.5);

                fixed4 faceCol = i.color;
                faceCol.a *= faceAlpha;

                fixed4 col = faceCol;

                if (_OutlineWidth > 0.005) {
                    half outlineAlpha = saturate((d - (0.5 - _FaceDilate - _OutlineWidth)) * scale + 0.5);
                    fixed4 outlineCol = _OutlineColor;
                    outlineCol.a *= outlineAlpha;
                    col.rgb = lerp(outlineCol.rgb, faceCol.rgb, faceAlpha);
                    col.a = max(faceCol.a, outlineCol.a);
                }

                #ifdef UNITY_UI_CLIP_RECT
                col.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
                #endif

                if (any(_CharClipRect.zw > _CharClipRect.xy)) {
                    float2 inChar = step(_CharClipRect.xy, i.worldPosition.xy) * step(i.worldPosition.xy, _CharClipRect.zw);
                    float2 inLine = step(_LineClipRect.xy, i.worldPosition.xy) * step(i.worldPosition.xy, _LineClipRect.zw);
                    col.a *= max(inChar.x * inChar.y, inLine.x * inLine.y);
                }

                clip(col.a - 0.005);
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

            struct appdata_t {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
            };

            sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform fixed4 _FaceColor;
            uniform float _FaceDilate;
            uniform float _OutlineWidth;
            uniform float _OutlineSoftness;
            uniform fixed4 _OutlineColor;
            uniform float _GradientScale;
            uniform float4 _ClipRect;
            uniform float4 _LineClipRect;
            uniform float4 _CharClipRect;
            uniform float _CharFadeWidth;

            v2f vert(appdata_t v) {
                v2f o;
                o.worldPosition = v.vertex;
                o.vertex = UnityObjectToClipPos(o.worldPosition);
                o.color = v.color * _FaceColor;
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                half d = tex2D(_MainTex, i.texcoord).a;
                half scale = max(_GradientScale * 1.5, 1.0);
                half faceAlpha = saturate((d - (0.5 - _FaceDilate)) * scale + 0.5);

                fixed4 faceCol = i.color;
                faceCol.a *= faceAlpha;

                fixed4 col = faceCol;

                if (_OutlineWidth > 0.005) {
                    half outlineAlpha = saturate((d - (0.5 - _FaceDilate - _OutlineWidth)) * scale + 0.5);
                    fixed4 outlineCol = _OutlineColor;
                    outlineCol.a *= outlineAlpha;
                    col.rgb = lerp(outlineCol.rgb, faceCol.rgb, faceAlpha);
                    col.a = max(faceCol.a, outlineCol.a);
                }

                #ifdef UNITY_UI_CLIP_RECT
                col.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
                #endif

                if (any(_CharClipRect.zw > _CharClipRect.xy)) {
                    float2 inChar = step(_CharClipRect.xy, i.worldPosition.xy) * step(i.worldPosition.xy, _CharClipRect.zw);
                    float2 inLine = step(_LineClipRect.xy, i.worldPosition.xy) * step(i.worldPosition.xy, _LineClipRect.zw);
                    col.a *= max(inChar.x * inChar.y, inLine.x * inLine.y);
                }

                clip(col.a - 0.005);
                return col;
            }
            ENDCG
        }
    }
}

