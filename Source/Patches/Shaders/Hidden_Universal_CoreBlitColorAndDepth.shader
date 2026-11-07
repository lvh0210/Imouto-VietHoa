Shader "Hidden/Universal/CoreBlitColorAndDepth"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
        LOD 100
        ZTest Always
        Cull Off

        HLSLINCLUDE
        #pragma target 3.0

        Texture2D _BlitTexture;
        Texture2D _InputDepthTexture;
        SamplerState sampler_BlitTexture;
        SamplerState sampler_LinearClamp;
        SamplerState sampler_PointClamp;

        Texture2D _MainTex;
        SamplerState sampler_MainTex;

        uniform float4 _BlitScaleBias;
        uniform float _BlitMipLevel;

        struct Attributes
        {
            uint vertexID : SV_VertexID;
        };

        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float2 texcoord   : TEXCOORD0;
        };

        float4 GetFullScreenTriangleVertexPosition(uint vertexID)
        {
            float2 uv = float2(float((vertexID << 1u) & 2u), float(vertexID & 2u));
            return float4(uv * 2.0 - 1.0, 0.0, 1.0);
        }

        float2 GetFullScreenTriangleTexCoord(uint vertexID)
        {
            return float2(float((vertexID << 1u) & 2u), float(vertexID & 2u));
        }

        Varyings VertTriangle(Attributes input)
        {
            Varyings output;
            float4 pos = GetFullScreenTriangleVertexPosition(input.vertexID);
            float2 uv  = GetFullScreenTriangleTexCoord(input.vertexID);

            float4 scaleBias = _BlitScaleBias;
            if (scaleBias.x == 0.0 && scaleBias.y == 0.0)
                scaleBias = float4(1.0, 1.0, 0.0, 0.0);

            output.positionCS = pos;
            output.texcoord   = uv * scaleBias.xy + scaleBias.zw;
            return output;
        }

        float4 SampleBlit(float2 uv, SamplerState s)
        {
            float4 col = _BlitTexture.SampleLevel(s, uv, _BlitMipLevel);
            if (dot(col, col) < 0.00001)
            {
                col = _MainTex.SampleLevel(s, uv, _BlitMipLevel);
            }
            return col;
        }

        float4 FragColorOnly(Varyings input) : SV_Target
        {
            return SampleBlit(input.texcoord, sampler_LinearClamp);
        }

        struct PixelData
        {
            float4 color : SV_Target;
            float depth : SV_Depth;
        };

        PixelData FragColorAndDepth(Varyings input)
        {
            PixelData pd;
            pd.color = SampleBlit(input.texcoord, sampler_LinearClamp);
            pd.depth = _InputDepthTexture.SampleLevel(sampler_PointClamp, input.texcoord, _BlitMipLevel).r;
            return pd;
        }
        ENDHLSL

        // Pass 0: Color Only
        Pass
        {
            Name "ColorOnly"
            ZWrite Off Blend Off
            HLSLPROGRAM
            #pragma vertex VertTriangle
            #pragma fragment FragColorOnly
            ENDHLSL
        }

        // Pass 1: Color Only and Depth
        Pass
        {
            Name "ColorAndDepth"
            ZWrite On Blend Off
            HLSLPROGRAM
            #pragma vertex VertTriangle
            #pragma fragment FragColorAndDepth
            ENDHLSL
        }
    }
    Fallback Off
}
