Shader "Hidden/Universal Render Pipeline/Blit"
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

        Pass
        {
            Name "Blit"
            HLSLPROGRAM
            #pragma target 3.0
            #pragma vertex Vert
            #pragma fragment Frag

            Texture2D _BlitTexture;
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

            Varyings Vert(Attributes input)
            {
                Varyings output;
                float2 uv = float2(float((input.vertexID << 1u) & 2u), float(input.vertexID & 2u));
                float4 pos = float4(uv * 2.0 - 1.0, 0.0, 1.0);

                float4 scaleBias = _BlitScaleBias;
                if (scaleBias.x == 0.0 && scaleBias.y == 0.0)
                    scaleBias = float4(1.0, 1.0, 0.0, 0.0);

                output.positionCS = pos;
                output.texcoord   = uv * scaleBias.xy + scaleBias.zw;
                return output;
            }

            float4 Frag(Varyings input) : SV_Target
            {
                float4 col = _BlitTexture.SampleLevel(sampler_BlitTexture, input.texcoord, _BlitMipLevel);
                if (dot(col, col) < 0.00001)
                {
                    col = _MainTex.SampleLevel(sampler_MainTex, input.texcoord, _BlitMipLevel);
                }
                return col;
            }
            ENDHLSL
        }
    }
    Fallback Off
}
