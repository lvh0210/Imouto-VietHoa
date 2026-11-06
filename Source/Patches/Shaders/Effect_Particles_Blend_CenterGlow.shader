Shader "Effect/Particles/Blend_CenterGlow" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Noise ("Noise", 2D) = "white" {}
		_Flow ("Flow", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_SpeedMainTexUVNoiseZW ("Speed MainTex U/V + Noise Z/W", Vector) = (0,0,0,0)
		_DistortionSpeedXYPowerZ ("Distortion Speed XY Power Z", Vector) = (0,0,0,0)
		_Emission ("Emission", Float) = 2
		_Color ("Color", Vector) = (0.5,0.5,0.5,1)
		_Opacity ("Opacity", Range(0, 3)) = 1
		[Toggle] _Usecenterglow ("Use center glow?", Float) = 0
		[MaterialToggle] _Usedepth ("Use depth?", Float) = 0
		_Depthpower ("Depth power", Float) = 1
		[Enum(Cull Off,0, Cull Front,1, Cull Back,2)] _CullMode ("Culling", Float) = 0
		[HideInInspector] _texcoord ("", 2D) = "white" {}
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