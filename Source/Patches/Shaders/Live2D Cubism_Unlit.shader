Shader "Live2D Cubism/Unlit"
{
    Properties
    {
        [PerRendererData] _MainTex ("Main Texture", 2D) = "white" {}
        [PerRendererData] cubism_ModelOpacity ("Model Opacity", Float) = 1
        [PerRendererData] cubism_MultiplyColor ("Multiply Color", Color) = (1, 1, 1, 1)
        [PerRendererData] cubism_ScreenColor ("Screen Color", Color) = (0, 0, 0, 0)
        _SrcColor ("Source Color", Float) = 1
        _DstColor ("Destination Color", Float) = 10
        _SrcAlpha ("Source Alpha", Float) = 1
        _DstAlpha ("Destination Alpha", Float) = 10
        _Cull ("Culling", Float) = 0
        [Toggle(CUBISM_MASK_ON)] cubism_MaskOn ("Mask?", Float) = 0
        [Toggle(CUBISM_INVERT_ON)] cubism_InvertOn ("Inverted?", Float) = 0
        [PerRendererData] cubism_MaskTexture ("cubism_Internal", 2D) = "white" {}
        [PerRendererData] cubism_MaskTile ("cubism_Internal", Vector) = (0, 0, 0, 0)
        [PerRendererData] cubism_MaskTransform ("cubism_Internal", Vector) = (0, 0, 0, 0)
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "PreviewType" = "Plane"
        }
        LOD 100
        Cull [_Cull]
        ZWrite Off
        Blend [_SrcColor] [_DstColor], [_SrcAlpha] [_DstAlpha]

        Pass
        {
            Name "UniversalForward"
            Tags { "LightMode" = "UniversalForward" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile _ CUBISM_MASK_ON
            #pragma multi_compile _ CUBISM_INVERT_ON

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex   : POSITION;
                fixed4 color    : COLOR;
                float2 uv       : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 uv       : TEXCOORD0;
                #if defined(CUBISM_MASK_ON)
                float4 clipPos  : TEXCOORD1;
                #endif
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed cubism_ModelOpacity;
            fixed4 cubism_MultiplyColor;
            fixed4 cubism_ScreenColor;

            #if defined(CUBISM_MASK_ON)
            sampler2D cubism_MaskTexture;
            float4 cubism_MaskTile;
            float4 cubism_MaskTransform;
            #endif

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                #if defined(CUBISM_MASK_ON)
                o.clipPos = ComputeScreenPos(o.vertex);
                #endif
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                col.rgb *= cubism_MultiplyColor.rgb;
                col.rgb = col.rgb + cubism_ScreenColor.rgb * (1.0 - col.rgb);

                col *= i.color;
                col.a *= cubism_ModelOpacity;

                #if defined(CUBISM_MASK_ON)
                float2 maskUV = (i.clipPos.xy / i.clipPos.w) * cubism_MaskTransform.xy + cubism_MaskTransform.zw;
                fixed4 maskCol = tex2D(cubism_MaskTexture, maskUV);
                #if defined(CUBISM_INVERT_ON)
                fixed maskVal = 1.0 - maskCol.a;
                #else
                fixed maskVal = maskCol.a;
                #endif
                col.a *= maskVal;
                #endif

                return col;
            }
            ENDCG
        }

        Pass
        {
            Name "SRPDefaultUnlit"
            Tags { "LightMode" = "SRPDefaultUnlit" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile _ CUBISM_MASK_ON
            #pragma multi_compile _ CUBISM_INVERT_ON

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex   : POSITION;
                fixed4 color    : COLOR;
                float2 uv       : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 uv       : TEXCOORD0;
                #if defined(CUBISM_MASK_ON)
                float4 clipPos  : TEXCOORD1;
                #endif
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed cubism_ModelOpacity;
            fixed4 cubism_MultiplyColor;
            fixed4 cubism_ScreenColor;

            #if defined(CUBISM_MASK_ON)
            sampler2D cubism_MaskTexture;
            float4 cubism_MaskTile;
            float4 cubism_MaskTransform;
            #endif

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                #if defined(CUBISM_MASK_ON)
                o.clipPos = ComputeScreenPos(o.vertex);
                #endif
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                col.rgb *= cubism_MultiplyColor.rgb;
                col.rgb = col.rgb + cubism_ScreenColor.rgb * (1.0 - col.rgb);

                col *= i.color;
                col.a *= cubism_ModelOpacity;

                #if defined(CUBISM_MASK_ON)
                float2 maskUV = (i.clipPos.xy / i.clipPos.w) * cubism_MaskTransform.xy + cubism_MaskTransform.zw;
                fixed4 maskCol = tex2D(cubism_MaskTexture, maskUV);
                #if defined(CUBISM_INVERT_ON)
                fixed maskVal = 1.0 - maskCol.a;
                #else
                fixed maskVal = maskCol.a;
                #endif
                col.a *= maskVal;
                #endif

                return col;
            }
            ENDCG
        }
    }
}
