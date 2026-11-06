Shader "AnimeSpeedLine/Speed Lines" {
	Properties {
		_MainTex ("Screen", 2D) = "black" {}
		[HDR] _Colour ("Colour", Vector) = (1,1,1,1)
		_SpeedLinesTiling ("Speed Lines Tiling", Float) = 200
		_SpeedLinesRadialScale ("Speed Lines Radial Scale", Range(0, 10)) = 0.1
		_SpeedLinesPower ("Speed Lines Power", Float) = 1
		_SpeedLinesRemap ("Speed Lines Remap", Range(0, 1)) = 0.8
		_SpeedLinesAnimation ("Speed Lines Animation", Float) = 3
		_MaskScale ("Mask Scale", Range(0, 2)) = 1
		_MaskHardness ("Mask Hardness", Range(0, 1)) = 0
		_MaskPower ("Mask Power", Float) = 5
		[HideInInspector] _texcoord ("", 2D) = "white" {}
	}
	SubShader {
	Tags {
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
		"PreviewType" = "Plane"
		"CanUseSpriteAtlas" = "True"
	}

	Cull Off
	Lighting Off
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
		float4 _MainTex_ST;
		float4 _Color;
		float4 _RendererColor;
		float4 _Flip;

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
			float4 pos = input.positionOS;
			if (_Flip.x != 0.0 || _Flip.y != 0.0) {
				pos.xy *= _Flip.xy;
			}
			output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, pos));
			output.uv = (input.uv * _MainTex_ST.xy) + _MainTex_ST.zw;
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			float4 rCol = _RendererColor;
			if (dot(rCol, rCol) < 0.001) rCol = float4(1,1,1,1);
			output.color = input.color * tint * rCol;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 texColor = _MainTex.Sample(sampler_MainTex, input.uv);
			return texColor * input.color;
		}
		ENDHLSL
	}

	Pass {
		Name "Universal2D"
		Tags { "LightMode" = "Universal2D" }

		HLSLPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		float4x4 unity_ObjectToWorld;
		float4x4 unity_MatrixVP;
		float4 _MainTex_ST;
		float4 _Color;
		float4 _RendererColor;
		float4 _Flip;

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
			float4 pos = input.positionOS;
			if (_Flip.x != 0.0 || _Flip.y != 0.0) {
				pos.xy *= _Flip.xy;
			}
			output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, pos));
			output.uv = (input.uv * _MainTex_ST.xy) + _MainTex_ST.zw;
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			float4 rCol = _RendererColor;
			if (dot(rCol, rCol) < 0.001) rCol = float4(1,1,1,1);
			output.color = input.color * tint * rCol;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 texColor = _MainTex.Sample(sampler_MainTex, input.uv);
			return texColor * input.color;
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
		float4 _RendererColor;
		float4 _Flip;

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
			float4 pos = input.positionOS;
			if (_Flip.x != 0.0 || _Flip.y != 0.0) {
				pos.xy *= _Flip.xy;
			}
			output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, pos));
			output.uv = (input.uv * _MainTex_ST.xy) + _MainTex_ST.zw;
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			float4 rCol = _RendererColor;
			if (dot(rCol, rCol) < 0.001) rCol = float4(1,1,1,1);
			output.color = input.color * tint * rCol;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 texColor = _MainTex.Sample(sampler_MainTex, input.uv);
			return texColor * input.color;
		}
		ENDHLSL
	}
}
Fallback "Sprites/Default"
}