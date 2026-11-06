Shader "Custom/URP_SingleSilhouetteTransparent" {
	Properties {
		_BaseColor ("Base Color", Vector) = (1,0,0,0.5)
	}
	SubShader {
	Tags { 
		"Queue" = "Transparent" 
		"RenderType" = "Transparent" 
		"RenderPipeline" = "UniversalPipeline"
	}
	LOD 200
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha

	Pass {
		Name "UniversalForward"
		Tags { "LightMode" = "UniversalForward" }

		HLSLPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		float4x4 unity_ObjectToWorld;
		float4x4 unity_MatrixVP;
		float4 _BaseColor;

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
			float4 c = _BaseColor;
			if (dot(c, c) < 0.001) c = float4(1, 0, 0, 0.5);
			return c;
		}
		ENDHLSL
	}
}
}