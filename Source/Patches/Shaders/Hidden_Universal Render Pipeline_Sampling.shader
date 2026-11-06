Shader "Hidden/Universal Render Pipeline/Sampling" {
	Properties {
	}
	SubShader {
	Tags { "RenderType" = "Opaque" }
	LOD 100
	ZTest Always
	ZWrite Off
	Cull Off

	Pass {
		Name "BlitPass"
		HLSLPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		float4x4 unity_ObjectToWorld;
		float4x4 unity_MatrixVP;

		Texture2D _BlitTexture;
		SamplerState sampler_BlitTexture;
		Texture2D _MainTex;
		SamplerState sampler_MainTex;

		struct Attributes {
			float4 positionOS : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct Varyings {
			float4 positionCS : SV_POSITION;
			float2 uv : TEXCOORD0;
		};

		Varyings vert(Attributes input) {
			Varyings output;
			output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.positionOS));
			output.uv = input.uv;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 col = _BlitTexture.Sample(sampler_BlitTexture, input.uv);
			if (dot(col, col) < 0.00001) {
				col = _MainTex.Sample(sampler_MainTex, input.uv);
			}
			return col;
		}
		ENDHLSL
	}
}
}