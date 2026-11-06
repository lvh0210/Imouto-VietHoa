Shader "Universal Render Pipeline/2D/Sprite-Lit-Default" {
	Properties {
		_MainTex ("Diffuse", 2D) = "white" {}
		_MaskTex ("Mask", 2D) = "white" {}
		_NormalMap ("Normal Map", 2D) = "bump" {}
		[HideInInspector] _Color ("Tint", Vector) = (1,1,1,1)
		[HideInInspector] _RendererColor ("RendererColor", Vector) = (1,1,1,1)
		[HideInInspector] _Flip ("Flip", Vector) = (1,1,1,1)
		[HideInInspector] _AlphaTex ("External Alpha", 2D) = "white" {}
		[HideInInspector] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
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
				pos.xy *= _Flip.xy;
				output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, pos));
				output.uv = (input.uv * _MainTex_ST.xy) + _MainTex_ST.zw;
				output.color = input.color * _Color * _RendererColor;
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
				pos.xy *= _Flip.xy;
				output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, pos));
				output.uv = (input.uv * _MainTex_ST.xy) + _MainTex_ST.zw;
				output.color = input.color * _Color * _RendererColor;
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
				pos.xy *= _Flip.xy;
				output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, pos));
				output.uv = (input.uv * _MainTex_ST.xy) + _MainTex_ST.zw;
				output.color = input.color * _Color * _RendererColor;
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
