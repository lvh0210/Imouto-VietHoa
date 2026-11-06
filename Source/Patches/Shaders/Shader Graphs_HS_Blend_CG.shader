Shader "Shader Graphs/HS_Blend_CG" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Noise ("Noise", 2D) = "white" {}
		_Flow ("Flow", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_SpeedMainTexUVNoiseZW ("Speed MainTex U/V + Noise Z/W", Vector) = (0,0,0,0)
		_DistortionSpeedXYPowerZ ("Distortion Speed XY Power Z", Vector) = (0,0,0,0)
		_Emission ("Emission", Float) = 1
		[HDR] _Color ("Color", Vector) = (1,1,1,1)
		_Opacity ("Opacity", Float) = 1
		[ToggleUI] _Usecenterglow ("Use center glow?", Float) = 0
		[ToggleUI] _Usedepth ("Use depth?", Float) = 0
		_Depthpower ("Depth power", Float) = 1
		[HideInInspector] _CastShadows ("_CastShadows", Float) = 0
		[HideInInspector] _Surface ("_Surface", Float) = 1
		[HideInInspector] _Blend ("_Blend", Float) = 0
		[HideInInspector] _AlphaClip ("_AlphaClip", Float) = 0
		[HideInInspector] _SrcBlend ("_SrcBlend", Float) = 1
		[HideInInspector] _DstBlend ("_DstBlend", Float) = 0
		[ToggleUI] [HideInInspector] _ZWrite ("_ZWrite", Float) = 0
		[HideInInspector] _ZWriteControl ("_ZWriteControl", Float) = 0
		[HideInInspector] _ZTest ("_ZTest", Float) = 4
		[HideInInspector] _Cull ("_Cull", Float) = 0
		[HideInInspector] _AlphaToMask ("_AlphaToMask", Float) = 0
		[HideInInspector] _QueueOffset ("_QueueOffset", Float) = 0
		[HideInInspector] _QueueControl ("_QueueControl", Float) = -1
		[HideInInspector] [NoScaleOffset] unity_Lightmaps ("unity_Lightmaps", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_LightmapsInd ("unity_LightmapsInd", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_ShadowMasks ("unity_ShadowMasks", 2DArray) = "" {}
		[HideInInspector] _BUILTIN_Surface ("Float", Float) = 1
		[HideInInspector] _BUILTIN_Blend ("Float", Float) = 0
		[HideInInspector] _BUILTIN_AlphaClip ("Float", Float) = 0
		[HideInInspector] _BUILTIN_SrcBlend ("Float", Float) = 1
		[HideInInspector] _BUILTIN_DstBlend ("Float", Float) = 0
		[HideInInspector] _BUILTIN_ZWrite ("Float", Float) = 0
		[HideInInspector] _BUILTIN_ZWriteControl ("Float", Float) = 0
		[HideInInspector] _BUILTIN_ZTest ("Float", Float) = 4
		[HideInInspector] _BUILTIN_CullMode ("Float", Float) = 0
		[HideInInspector] _BUILTIN_QueueOffset ("Float", Float) = 0
		[HideInInspector] _BUILTIN_QueueControl ("Float", Float) = -1
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
		float4 _MainTex_ST;
		float4 _Color;

		Texture2D _MainTex;
		SamplerState sampler_MainTex;

		struct Attributes {
			float4 positionOS : POSITION;
			float4 color : COLOR;
			float2 uv : TEXCOORD0;
		};

		struct Varyings {
			float4 positionCS : SV_POSITION;
			float4 color : COLOR;
			float2 uv : TEXCOORD0;
		};

		Varyings vert(Attributes input) {
			Varyings output;
			output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.positionOS));
			output.uv = (input.uv * _MainTex_ST.xy) + _MainTex_ST.zw;
			output.color = input.color;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 col = _MainTex.Sample(sampler_MainTex, input.uv);
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			return col * tint * input.color;
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
		float4 _MainTex_ST;
		float4 _Color;

		Texture2D _MainTex;
		SamplerState sampler_MainTex;

		struct Attributes {
			float4 positionOS : POSITION;
			float4 color : COLOR;
			float2 uv : TEXCOORD0;
		};

		struct Varyings {
			float4 positionCS : SV_POSITION;
			float4 color : COLOR;
			float2 uv : TEXCOORD0;
		};

		Varyings vert(Attributes input) {
			Varyings output;
			output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.positionOS));
			output.uv = (input.uv * _MainTex_ST.xy) + _MainTex_ST.zw;
			output.color = input.color;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 col = _MainTex.Sample(sampler_MainTex, input.uv);
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			return col * tint * input.color;
		}
		ENDHLSL
	}
}
Fallback "Sprites/Default"
}