Shader "Custom/URP_KPSPenetrator_Phase3_WithOutline" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		[Header(Penetration Entry Deformation)] _Squeeze ("Squeeze Minimum Size", Range(0, 0.2)) = 0.05
		_SqueezeDist ("Squeeze Smoothness", Range(0, 0.1)) = 0.05
		_BulgePower ("Bulge Amount", Range(0, 1)) = 0.2
		_BulgeOffset ("Bulge Length", Range(0, 0.3)) = 0.1
		_Length ("Length of Penetrator Model", Range(0, 3)) = 0.5
		[Header(Alignment Adjustment)] _EntranceStiffness ("Entrance Stiffness", Range(0.01, 1)) = 0.5
		[Header(Resting Curvature)] _Curvature ("Curvature", Range(-1, 1)) = 0
		_ReCurvature ("ReCurvature", Range(-1, 1)) = 0
		[Header(Movement)] _Wriggle ("Wriggle Amount", Range(0, 1)) = 0.1
		_WriggleSpeed ("Wriggle Speed", Range(0.1, 30)) = 5
		[Header(Target Information from Script)] _TargetPositionOS ("Target Position (Object Space)", Vector) = (0,0,0.3,0)
		_TargetNormalOS ("Target Normal (Object Space)", Vector) = (0,0,1,0)
		_OrificeType ("Orifice Type (0:Hole, 1:Ring)", Float) = 0
		[Header(Outline Settings)] [Toggle(_OUTLINE_ON)] _OutlineOn ("Enable Outline", Float) = 0
		_OutlineColor ("Outline Color", Vector) = (0,0,0,1)
		_OutlineWidth ("Outline Width", Range(0, 0.05)) = 0.01
	}
	SubShader {
	Tags { 
		"Queue" = "Geometry"
		"RenderType" = "Opaque" 
		"RenderPipeline" = "UniversalPipeline"
	}
	LOD 200

	Pass {
		Name "UniversalForward"
		Tags { "LightMode" = "UniversalForward" }

		HLSLPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		float4x4 unity_ObjectToWorld;
		float4x4 unity_MatrixVP;
		float4 _BaseMap_ST;
		float4 _BaseColor;
		float4 _Color;

		Texture2D _BaseMap;
		SamplerState sampler_BaseMap;

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
			output.uv = (input.uv * _BaseMap_ST.xy) + _BaseMap_ST.zw;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 col = _BaseMap.Sample(sampler_BaseMap, input.uv);
			float4 bColor = _BaseColor;
			if (dot(bColor, bColor) < 0.001) bColor = float4(1,1,1,1);
			float4 cColor = _Color;
			if (dot(cColor, cColor) < 0.001) cColor = float4(1,1,1,1);
			return col * bColor * cColor;
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
		float4 _BaseMap_ST;
		float4 _BaseColor;
		float4 _Color;

		Texture2D _BaseMap;
		SamplerState sampler_BaseMap;

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
			output.uv = (input.uv * _BaseMap_ST.xy) + _BaseMap_ST.zw;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 col = _BaseMap.Sample(sampler_BaseMap, input.uv);
			float4 bColor = _BaseColor;
			if (dot(bColor, bColor) < 0.001) bColor = float4(1,1,1,1);
			float4 cColor = _Color;
			if (dot(cColor, cColor) < 0.001) cColor = float4(1,1,1,1);
			return col * bColor * cColor;
		}
		ENDHLSL
	}
}
Fallback "Hidden/Universal Render Pipeline/FallbackError"
}