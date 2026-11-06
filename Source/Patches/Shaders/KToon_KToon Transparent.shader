Shader "KToon/KToon Transparent" {
	Properties {
		[Header(Rendering)] [Enum(Front, 2, Back, 1, Both, 0)] _Cull ("Render Face", Float) = 2
		[Header(Transparency)] _ThroughVeilOpacity ("Opacity", Range(0, 1)) = 0.5
		_ThroughVeilTint ("Tint Color", Vector) = (1,1,1,1)
		_ThroughVeilBrightness ("Brightness", Range(0, 2)) = 0.8
		_EdgeSoftness ("Edge Softness", Range(0, 1)) = 0.2
		[Header(Base)] _BaseColor ("Color", Vector) = (1,1,1,1)
		[HDR] _HColor ("Highlight Color", Vector) = (0.75,0.75,0.75,1)
		_SColor ("Shadow Color", Vector) = (0.2,0.2,0.2,1)
		[Toggle(TCP2_SHADOW_ALBEDO_TEX)] _UseShadowAlbedoTex ("Use Shadow Albedo Texture", Float) = 0
		[NoScaleOffset] _ShadowAlbedoTex ("Shadow Albedo Texture", 2D) = "white" {}
		_BaseMap ("Albedo", 2D) = "white" {}
		[Header(Ramp Shading)] _RampThreshold ("Threshold", Range(0.01, 1)) = 0.5
		_RampSmoothing ("Smoothing", Range(0.001, 1)) = 0.5
		[Header(Specular)] [Toggle(TCP2_SPECULAR)] _UseSpecular ("Enable Specular", Float) = 0
		_SpecularColor ("Specular Color", Vector) = (0.5,0.5,0.5,1)
		_SpecularToonSize ("Toon Size", Range(0, 1)) = 0.25
		_SpecularToonSmoothness ("Toon Smoothness", Range(0.001, 0.5)) = 0.05
		[Header(MatCap)] [Toggle(TCP2_MATCAP)] _UseMatCap ("Enable MatCap", Float) = 0
		[NoScaleOffset] _MatCapTex ("MatCap (RGB)", 2D) = "gray" {}
		_MatCapColor ("MatCap Color", Vector) = (1,1,1,1)
		[Header(Ambient Lighting)] _TCP2_AMBIENT_RIGHT ("+X (Right)", Vector) = (0,0,0,1)
		_TCP2_AMBIENT_LEFT ("-X (Left)", Vector) = (0,0,0,1)
		_TCP2_AMBIENT_TOP ("+Y (Top)", Vector) = (0,0,0,1)
		_TCP2_AMBIENT_BOTTOM ("-Y (Bottom)", Vector) = (0,0,0,1)
		_TCP2_AMBIENT_FRONT ("+Z (Front)", Vector) = (0,0,0,1)
		_TCP2_AMBIENT_BACK ("-Z (Back)", Vector) = (0,0,0,1)
		[Header(Stencil Settings)] [Enum(None,0, Read,1, Write,2, Cutout,3)] _StencilMode ("Stencil Mode", Float) = 0
		_StencilReference ("Stencil Reference", Range(0, 255)) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Float) = 8
		[Enum(UnityEngine.Rendering.StencilOp)] [HideInInspector] _StencilPass ("Stencil Pass Op", Float) = 0
		[Header(Outline)] [Toggle(OUTLINE_ON)] _OutlineEnable ("Enable Outline", Float) = 0
		_OutlineWidth ("Outline Width", Range(0.0001, 4)) = 1
		[NoScaleOffset] _OutlineMask ("Outline Mask", 2D) = "white" {}
		_OutlineColor ("Outline Color", Vector) = (0,0,0,1)
		[KeywordEnum(None, Width, Normal)] _OutlineVertexColorMode ("Vertex Color Mode", Float) = 0
		_OutlineZBias ("Z Bias", Float) = 0
		_OutlineFixWidth ("Fix Width (Distance Compensation)", Range(0, 1)) = 0.5
		[Header(Advanced)] [NoScaleOffset] _ShadowMapTex ("Shadow Map Texture", 2D) = "white" {}
		_IgnoreYNormal ("Ignore Y Normal Direction", Range(0, 1)) = 0
		[ToggleOff(_RECEIVE_SHADOWS_OFF)] _ReceiveShadowsOff ("Receive Shadows", Float) = 1
		[HideInInspector] __dummy__ ("unused", Float) = 0
	}
	SubShader {
	Tags { 
		"Queue" = "Transparent" 
		"RenderType" = "Transparent"
		"IgnoreProjector" = "True"
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
		float4 _BaseMap_ST;
		float4 _BaseColor;
		float4 _Color;
		float4 _HColor;
		float4 _SColor;

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
			float4 worldPos = mul(unity_ObjectToWorld, input.positionOS);
			output.positionCS = mul(unity_MatrixVP, worldPos);
			output.uv = (input.uv * _BaseMap_ST.xy) + _BaseMap_ST.zw;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 albedo = _BaseMap.Sample(sampler_BaseMap, input.uv);
			float4 bColor = _BaseColor;
			if (dot(bColor, bColor) < 0.001) bColor = float4(1,1,1,1);
			float4 cColor = _Color;
			if (dot(cColor, cColor) < 0.001) cColor = float4(1,1,1,1);
			return albedo * bColor * cColor;
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
			float4 worldPos = mul(unity_ObjectToWorld, input.positionOS);
			output.positionCS = mul(unity_MatrixVP, worldPos);
			output.uv = (input.uv * _BaseMap_ST.xy) + _BaseMap_ST.zw;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 albedo = _BaseMap.Sample(sampler_BaseMap, input.uv);
			float4 bColor = _BaseColor;
			if (dot(bColor, bColor) < 0.001) bColor = float4(1,1,1,1);
			float4 cColor = _Color;
			if (dot(cColor, cColor) < 0.001) cColor = float4(1,1,1,1);
			return albedo * bColor * cColor;
		}
		ENDHLSL
	}
}
Fallback "Universal Render Pipeline/Unlit"
}