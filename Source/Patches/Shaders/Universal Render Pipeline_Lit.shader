Shader "Universal Render Pipeline/Lit" {
	Properties {
		_WorkflowMode ("WorkflowMode", Float) = 1
		_BaseMap ("Albedo", 2D) = "white" {}
		_BaseColor ("Color", Vector) = (1,1,1,1)
		_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
		_Smoothness ("Smoothness", Range(0, 1)) = 0.5
		_SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0
		_Metallic ("Metallic", Range(0, 1)) = 0
		_MetallicGlossMap ("Metallic", 2D) = "white" {}
		_SpecColor ("Specular", Vector) = (0.2,0.2,0.2,1)
		_SpecGlossMap ("Specular", 2D) = "white" {}
		[ToggleOff] _SpecularHighlights ("Specular Highlights", Float) = 1
		[ToggleOff] _EnvironmentReflections ("Environment Reflections", Float) = 1
		_BumpScale ("Scale", Float) = 1
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_Parallax ("Scale", Range(0.005, 0.08)) = 0.005
		_ParallaxMap ("Height Map", 2D) = "black" {}
		_OcclusionStrength ("Strength", Range(0, 1)) = 1
		_OcclusionMap ("Occlusion", 2D) = "white" {}
		[HDR] _EmissionColor ("Color", Vector) = (0,0,0,1)
		_EmissionMap ("Emission", 2D) = "white" {}
		_DetailMask ("Detail Mask", 2D) = "white" {}
		_DetailAlbedoMapScale ("Scale", Range(0, 2)) = 1
		_DetailAlbedoMap ("Detail Albedo x2", 2D) = "linearGrey" {}
		_DetailNormalMapScale ("Scale", Range(0, 2)) = 1
		[Normal] _DetailNormalMap ("Normal Map", 2D) = "bump" {}
		[HideInInspector] _ClearCoatMask ("_ClearCoatMask", Float) = 0
		[HideInInspector] _ClearCoatSmoothness ("_ClearCoatSmoothness", Float) = 0
		_Surface ("__surface", Float) = 0
		_Blend ("__blend", Float) = 0
		_Cull ("__cull", Float) = 2
		[ToggleUI] _AlphaClip ("__clip", Float) = 0
		[HideInInspector] _SrcBlend ("__src", Float) = 1
		[HideInInspector] _DstBlend ("__dst", Float) = 0
		[HideInInspector] _SrcBlendAlpha ("__srcA", Float) = 1
		[HideInInspector] _DstBlendAlpha ("__dstA", Float) = 0
		[HideInInspector] _ZWrite ("__zw", Float) = 1
		[HideInInspector] _BlendModePreserveSpecular ("_BlendModePreserveSpecular", Float) = 1
		[HideInInspector] _AlphaToMask ("__alphaToMask", Float) = 0
		[ToggleUI] _ReceiveShadows ("Receive Shadows", Float) = 1
		_QueueOffset ("Queue offset", Float) = 0
		[HideInInspector] _MainTex ("BaseMap", 2D) = "white" {}
		[HideInInspector] _Color ("Base Color", Vector) = (1,1,1,1)
		[HideInInspector] _GlossMapScale ("Smoothness", Float) = 0
		[HideInInspector] _Glossiness ("Smoothness", Float) = 0
		[HideInInspector] _GlossyReflections ("EnvironmentReflections", Float) = 0
		[HideInInspector] [NoScaleOffset] unity_Lightmaps ("unity_Lightmaps", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_LightmapsInd ("unity_LightmapsInd", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_ShadowMasks ("unity_ShadowMasks", 2DArray) = "" {}
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