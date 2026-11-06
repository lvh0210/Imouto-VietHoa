Shader "LocalPixelizeURP" {
	Properties {
		_CellSize ("Cell Size", Vector) = (0.02,0.02,0,0)
	}
	SubShader {
	Tags { 
		"Queue" = "Transparent+100" 
		"RenderType" = "Transparent" 
		"RenderPipeline" = "UniversalPipeline"
	}
	LOD 200
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Off

	Pass {
		Name "UniversalForward"
		Tags { "LightMode" = "UniversalForward" }

		HLSLPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		float4x4 unity_ObjectToWorld;
		float4x4 unity_MatrixVP;
		float4 _CellSize;

		struct Attributes {
			float4 positionOS : POSITION;
		};

		struct Varyings {
			float4 positionCS : SV_POSITION;
		};

		Varyings vert(Attributes input) {
			Varyings output;
			output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.positionOS));
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			// Transparent mosaic overlay (thay vÃ¬ mÃ u tráº¯ng xoÃ¡ mÃ¹ má»‹t)
			return float4(0.0, 0.0, 0.0, 0.0);
		}
		ENDHLSL
	}

	Pass {
		Name "SRPDefaultUnlit"
		Tags { "LightMode" = "SRPDefaultUnlit" }

		HLSLPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		float4x4 unity_ObjectToWorld;
		float4x4 unity_MatrixVP;

		struct Attributes {
			float4 positionOS : POSITION;
		};

		struct Varyings {
			float4 positionCS : SV_POSITION;
		};

		Varyings vert(Attributes input) {
			Varyings output;
			output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.positionOS));
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			return float4(0.0, 0.0, 0.0, 0.0);
		}
		ENDHLSL
	}
}
}