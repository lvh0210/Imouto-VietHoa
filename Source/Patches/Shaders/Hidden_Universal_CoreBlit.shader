Shader "Hidden/Universal/CoreBlit"
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
        ZWrite Off
        Cull Off

        HLSLINCLUDE
        #pragma target 3.0

        Texture2D _BlitTexture;
        SamplerState sampler_BlitTexture;
        SamplerState sampler_LinearClamp;
        SamplerState sampler_PointClamp;
        SamplerState sampler_LinearRepeat;
        SamplerState sampler_PointRepeat;

        Texture2D _MainTex;
        SamplerState sampler_MainTex;

        uniform float4 _BlitScaleBias;
        uniform float4 _BlitScaleBiasRt;
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

        float4 GetQuadVertexPosition(uint vertexID)
        {
            uint topBit = vertexID >> 1u;
            uint botBit = (vertexID & 1u);
            float x = float(topBit);
            float y = float(1u - ((topBit + botBit) & 1u));
            return float4(x, y, 0.0, 1.0);
        }

        float2 GetQuadTexCoord(uint vertexID)
        {
            uint topBit = vertexID >> 1u;
            uint botBit = (vertexID & 1u);
            float u = float(topBit);
            float v = float((topBit + botBit) & 1u);
            #if UNITY_UV_STARTS_AT_TOP
            v = 1.0 - v;
            #endif
            return float2(u, v);
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

        Varyings VertQuad(Attributes input)
        {
            Varyings output;
            float4 pos = GetQuadVertexPosition(input.vertexID);
            float2 uv  = GetQuadTexCoord(input.vertexID);

            float4 scaleBiasRt = _BlitScaleBiasRt;
            if (scaleBiasRt.x == 0.0 && scaleBiasRt.y == 0.0)
                scaleBiasRt = float4(1.0, 1.0, 0.0, 0.0);

            output.positionCS    = pos * float4(scaleBiasRt.x, scaleBiasRt.y, 1.0, 1.0) + float4(scaleBiasRt.z, scaleBiasRt.w, 0.0, 0.0);
            output.positionCS.xy = output.positionCS.xy * float2(2.0, -2.0) + float2(-1.0, 1.0);

            float4 scaleBias = _BlitScaleBias;
            if (scaleBias.x == 0.0 && scaleBias.y == 0.0)
                scaleBias = float4(1.0, 1.0, 0.0, 0.0);

            output.texcoord      = uv * scaleBias.xy + scaleBias.zw;
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

        float4 FragNearest(Varyings input) : SV_Target
        {
            return SampleBlit(input.texcoord, sampler_PointClamp);
        }

        float4 FragBilinear(Varyings input) : SV_Target
        {
            return SampleBlit(input.texcoord, sampler_LinearClamp);
        }
        ENDHLSL

        // Pass 0: Nearest
        Pass
        {
            Name "Nearest"
            ZWrite Off ZTest Always Blend Off Cull Off
            HLSLPROGRAM
            #pragma vertex VertTriangle
            #pragma fragment FragNearest
            ENDHLSL
        }

        // Pass 1: Bilinear
        Pass
        {
            Name "Bilinear"
            ZWrite Off ZTest Always Blend Off Cull Off
            HLSLPROGRAM
            #pragma vertex VertTriangle
            #pragma fragment FragBilinear
            ENDHLSL
        }

        // Pass 2: Nearest quad
        Pass
        {
            Name "NearestQuad"
            ZWrite Off ZTest Always Blend Off Cull Off
            HLSLPROGRAM
            #pragma vertex VertQuad
            #pragma fragment FragNearest
            ENDHLSL
        }

        // Pass 3: Bilinear quad
        Pass
        {
            Name "BilinearQuad"
            ZWrite Off ZTest Always Blend Off Cull Off
            HLSLPROGRAM
            #pragma vertex VertQuad
            #pragma fragment FragBilinear
            ENDHLSL
        }

        // Pass 4: Nearest quad with padding
        Pass
        {
            Name "NearestQuadPadding"
            ZWrite Off ZTest Always Blend Off Cull Off
            HLSLPROGRAM
            #pragma vertex VertQuad
            #pragma fragment FragNearest
            ENDHLSL
        }

        // Pass 5: Bilinear quad with padding
        Pass
        {
            Name "BilinearQuadPadding"
            ZWrite Off ZTest Always Blend Off Cull Off
            HLSLPROGRAM
            #pragma vertex VertQuad
            #pragma fragment FragBilinear
            ENDHLSL
        }

        // Pass 6..22: Additional passes
        Pass { Name "Pass6" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragNearest ENDHLSL }
        Pass { Name "Pass7" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass8" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass9" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragNearest ENDHLSL }
        Pass { Name "Pass10" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass11" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragNearest ENDHLSL }
        Pass { Name "Pass12" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass13" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass14" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass15" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass16" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass17" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass18" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass19" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass20" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }
        Pass { Name "Pass21" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragNearest ENDHLSL }
        Pass { Name "Pass22" ZWrite Off ZTest Always Blend Off Cull Off HLSLPROGRAM #pragma vertex VertQuad #pragma fragment FragBilinear ENDHLSL }

        // Pass 23: BilinearDebugDraw
        Pass
        {
            Name "BilinearDebugDraw"
            ZWrite Off ZTest Always Blend Off Cull Off
            HLSLPROGRAM
            #pragma vertex VertTriangle
            #pragma fragment FragBilinear
            ENDHLSL
        }

        // Pass 24: NearestDebugDraw
        Pass
        {
            Name "NearestDebugDraw"
            ZWrite Off ZTest Always Blend Off Cull Off
            HLSLPROGRAM
            #pragma vertex VertTriangle
            #pragma fragment FragNearest
            ENDHLSL
        }
    }
    Fallback Off
}
