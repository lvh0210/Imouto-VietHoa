Shader "KToon/KToon Eye" {
	Properties {
		[Header(Rendering)] [Enum(Front, 2, Back, 1, Both, 0)] _Cull ("Render Face", Float) = 2
		[Toggle] _ZWrite ("Depth Write", Float) = 1
		[Header(Base)] _BaseColor ("Color", Vector) = (1,1,1,1)
		[HDR] _HColor ("Highlight Color", Vector) = (0.75,0.75,0.75,1)
		_SColor ("Shadow Color", Vector) = (0.2,0.2,0.2,1)
		[Toggle(TCP2_SHADOW_ALBEDO_TEX)] _UseShadowAlbedoTex ("Use Shadow Albedo Texture", Float) = 0
		[NoScaleOffset] _ShadowAlbedoTex ("Shadow Albedo Texture", 2D) = "white" {}
		_BaseMap ("Albedo", 2D) = "white" {}
		[Header(Ramp Shading)] _RampThreshold ("Threshold", Range(0.01, 1)) = 0.5
		_RampSmoothing ("Smoothing", Range(0.001, 1)) = 0.5
		[Header(Pupil)] [Toggle(USE_PUPIL)] _UsePupil ("Enable Pupil", Float) = 1
		_PupilTex ("Pupil Texture", 2D) = "clear" {}
		_PupilColor ("Pupil Color", Vector) = (1,1,1,1)
		_PupilScale ("Pupil Scale", Float) = 1
		_PupilBaseOffset ("Pupil Base Offset", Vector) = (0,0,0,0)
		_PupilOffset ("Pupil Anim Offset", Vector) = (0,0,0,0)
		[Header(Highlight)] [Toggle(USE_HIGHLIGHT)] _UseHighlight ("Enable Highlight", Float) = 1
		_HighlightTex ("Highlight Texture", 2D) = "clear" {}
		_HighlightColor ("Highlight Color", Vector) = (1,1,1,1)
		_HighlightScale ("Highlight Scale", Float) = 1
		_HighlightBaseOffset ("Highlight Base Offset", Vector) = (0,0,0,0)
		_HighlightOffset ("Highlight Anim Offset", Vector) = (0,0,0,0)
		[Header(Stencil Settings)] [Enum(None,0, Read,1, Write,2, Cutout,3)] _StencilMode ("Stencil Mode", Float) = 0
		_StencilReference ("Stencil Reference", Range(0, 255)) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Float) = 8
		[Enum(UnityEngine.Rendering.StencilOp)] [HideInInspector] _StencilPass ("Stencil Pass Op", Float) = 0
		[Header(Advanced)] [NoScaleOffset] _ShadowMapTex ("Shadow Map Texture", 2D) = "white" {}
		_IgnoreYNormal ("Ignore Y Normal Direction", Range(0, 1)) = 0
		[ToggleOff(_RECEIVE_SHADOWS_OFF)] _ReceiveShadowsOff ("Receive Shadows", Float) = 1
		[HideInInspector] __dummy__ ("unused", Float) = 0
	}
	SubShader {
	Tags { 
		"Queue" = "Geometry+1" 
		"RenderType" = "Opaque"
		"RenderPipeline" = "UniversalPipeline"
	}
	LOD 200
	ZWrite On

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