Shader "Live2D Cubism/Unlit"
{
    Properties
    {
        [PerRendererData] _MainTex ("Main Texture", 2D) = "white" {}
        [PerRendererData] cubism_ModelOpacity ("Model Opacity", Float) = 1
        [PerRendererData] cubism_MultiplyColor ("Multiply Color", Vector) = (1, 1, 1, 1)
        [PerRendererData] cubism_ScreenColor ("Screen Color", Vector) = (0, 0, 0, 0)
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
            "RenderPipeline" = "UniversalPipeline"
        }
        LOD 100
        Cull [_Cull]
        ZWrite Off
        Blend [_SrcColor] [_DstColor], [_SrcAlpha] [_DstAlpha]

        Pass
        {
            Name "UniversalForward"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ CUBISM_MASK_ON
            #pragma multi_compile _ CUBISM_INVERT_ON

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float4 color        : COLOR;
                float2 uv           : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS   : SV_POSITION;
                float4 color        : COLOR;
                float2 uv           : TEXCOORD0;
                #if defined(CUBISM_MASK_ON)
                float4 screenPos    : TEXCOORD1;
                #endif
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            #if defined(CUBISM_MASK_ON)
            TEXTURE2D(cubism_MaskTexture);
            SAMPLER(sampler_cubism_MaskTexture);
            #endif

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float cubism_ModelOpacity;
                float4 cubism_MultiplyColor;
                float4 cubism_ScreenColor;
                #if defined(CUBISM_MASK_ON)
                float4 cubism_MaskTile;
                float4 cubism_MaskTransform;
                #endif
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                output.color = input.color;

                #if defined(CUBISM_MASK_ON)
                output.screenPos = ComputeScreenPos(output.positionCS);
                #endif

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                half4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);

                // Live2D Multiply Color
                col.rgb *= cubism_MultiplyColor.rgb;
                // Live2D Screen Color
                col.rgb = col.rgb + cubism_ScreenColor.rgb * (1.0 - col.rgb);

                col *= input.color;
                col.a *= cubism_ModelOpacity;

                #if defined(CUBISM_MASK_ON)
                float2 maskUV = (input.screenPos.xy / input.screenPos.w) * cubism_MaskTransform.xy + cubism_MaskTransform.zw;
                half4 maskColor = SAMPLE_TEXTURE2D(cubism_MaskTexture, sampler_cubism_MaskTexture, maskUV);
                #if defined(CUBISM_INVERT_ON)
                half maskVal = 1.0 - maskColor.a;
                #else
                half maskVal = maskColor.a;
                #endif
                col.a *= maskVal;
                #endif

                return col;
            }
            ENDHLSL
        }

        Pass
        {
            Name "SRPDefaultUnlit"
            Tags { "LightMode" = "SRPDefaultUnlit" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ CUBISM_MASK_ON
            #pragma multi_compile _ CUBISM_INVERT_ON

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float4 color        : COLOR;
                float2 uv           : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS   : SV_POSITION;
                float4 color        : COLOR;
                float2 uv           : TEXCOORD0;
                #if defined(CUBISM_MASK_ON)
                float4 screenPos    : TEXCOORD1;
                #endif
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            #if defined(CUBISM_MASK_ON)
            TEXTURE2D(cubism_MaskTexture);
            SAMPLER(sampler_cubism_MaskTexture);
            #endif

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float cubism_ModelOpacity;
                float4 cubism_MultiplyColor;
                float4 cubism_ScreenColor;
                #if defined(CUBISM_MASK_ON)
                float4 cubism_MaskTile;
                float4 cubism_MaskTransform;
                #endif
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                output.color = input.color;

                #if defined(CUBISM_MASK_ON)
                output.screenPos = ComputeScreenPos(output.positionCS);
                #endif

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                half4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);

                col.rgb *= cubism_MultiplyColor.rgb;
                col.rgb = col.rgb + cubism_ScreenColor.rgb * (1.0 - col.rgb);

                col *= input.color;
                col.a *= cubism_ModelOpacity;

                #if defined(CUBISM_MASK_ON)
                float2 maskUV = (input.screenPos.xy / input.screenPos.w) * cubism_MaskTransform.xy + cubism_MaskTransform.zw;
                half4 maskColor = SAMPLE_TEXTURE2D(cubism_MaskTexture, sampler_cubism_MaskTexture, maskUV);
                #if defined(CUBISM_INVERT_ON)
                half maskVal = 1.0 - maskColor.a;
                #else
                half maskVal = maskColor.a;
                #endif
                col.a *= maskVal;
                #endif

                return col;
            }
            ENDHLSL
        }
    }
}
