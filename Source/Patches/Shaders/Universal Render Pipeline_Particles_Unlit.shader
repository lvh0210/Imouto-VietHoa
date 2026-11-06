Shader "Universal Render Pipeline/Particles/Unlit" {
	Properties {
		_BaseMap ("Base Map", 2D) = "white" {}
		_BaseColor ("Base Color", Vector) = (1,1,1,1)
		_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
		_BumpMap ("Normal Map", 2D) = "bump" {}
		[HDR] _EmissionColor ("Color", Vector) = (0,0,0,1)
		_EmissionMap ("Emission", 2D) = "white" {}
		_SoftParticlesNearFadeDistance ("Soft Particles Near Fade", Float) = 0
		_SoftParticlesFarFadeDistance ("Soft Particles Far Fade", Float) = 1
		_CameraNearFadeDistance ("Camera Near Fade", Float) = 1
		_CameraFarFadeDistance ("Camera Far Fade", Float) = 2
		_DistortionBlend ("Distortion Blend", Range(0, 1)) = 0.5
		_DistortionStrength ("Distortion Strength", Float) = 1
		_Surface ("__surface", Float) = 0
		_Blend ("__mode", Float) = 0
		_Cull ("__cull", Float) = 2
		[ToggleUI] _AlphaClip ("__clip", Float) = 0
		[HideInInspector] _BlendOp ("__blendop", Float) = 0
		[HideInInspector] _SrcBlend ("__src", Float) = 1
		[HideInInspector] _DstBlend ("__dst", Float) = 0
		[HideInInspector] _SrcBlendAlpha ("__srcA", Float) = 1
		[HideInInspector] _DstBlendAlpha ("__dstA", Float) = 0
		[HideInInspector] _ZWrite ("__zw", Float) = 1
		[HideInInspector] _AlphaToMask ("__alphaToMask", Float) = 0
		_ColorMode ("_ColorMode", Float) = 0
		[HideInInspector] _BaseColorAddSubDiff ("_ColorMode", Vector) = (0,0,0,0)
		[ToggleOff] _FlipbookBlending ("__flipbookblending", Float) = 0
		[ToggleUI] _SoftParticlesEnabled ("__softparticlesenabled", Float) = 0
		[ToggleUI] _CameraFadingEnabled ("__camerafadingenabled", Float) = 0
		[ToggleUI] _DistortionEnabled ("__distortionenabled", Float) = 0
		[HideInInspector] _SoftParticleFadeParams ("__softparticlefadeparams", Vector) = (0,0,0,0)
		[HideInInspector] _CameraFadeParams ("__camerafadeparams", Vector) = (0,0,0,0)
		[HideInInspector] _DistortionStrengthScaled ("Distortion Strength Scaled", Float) = 0.1
		_QueueOffset ("Queue offset", Float) = 0
		[HideInInspector] _FlipbookMode ("flipbook", Float) = 0
		[HideInInspector] _Mode ("mode", Float) = 0
		[HideInInspector] _Color ("color", Vector) = (1,1,1,1)
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