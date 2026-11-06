Shader "Live2D Cubism/Unlit" {
	Properties {
		[PerRendererData] _MainTex ("Main Texture", 2D) = "white" {}
		[PerRendererData] cubism_ModelOpacity ("Model Opacity", Float) = 1
		[PerRendererData] cubism_MultiplyColor ("Multiply Color", Vector) = (1,1,1,1)
		[PerRendererData] cubism_ScreenColor ("Screen Color", Vector) = (0,0,0,1)
		_SrcColor ("Source Color", Float) = 0
		_DstColor ("Destination Color", Float) = 0
		_SrcAlpha ("Source Alpha", Float) = 0
		_DstAlpha ("Destination Alpha", Float) = 0
		_Cull ("Culling", Float) = 0
		[Toggle(CUBISM_MASK_ON)] cubism_MaskOn ("Mask?", Float) = 0
		[Toggle(CUBISM_INVERT_ON)] cubism_InvertOn ("Inverted?", Float) = 0
		[PerRendererData] cubism_MaskTexture ("cubism_Internal", 2D) = "white" {}
		[PerRendererData] cubism_MaskTile ("cubism_Internal", Vector) = (0,0,0,0)
		[PerRendererData] cubism_MaskTransform ("cubism_Internal", Vector) = (0,0,0,0)
	}
	SubShader {
	Tags { 
		"Queue" = "Transparent" 
		"RenderType" = "Transparent" 
		"IgnoreProjector" = "True"
		"RenderPipeline" = "UniversalPipeline"
	}
	LOD 200
	Cull Off
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
		float cubism_ModelOpacity;
		float4 cubism_MultiplyColor;
		float4 cubism_ScreenColor;

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
			float opacity = cubism_ModelOpacity > 0.001 ? cubism_ModelOpacity : 1.0;
			float4 multCol = cubism_MultiplyColor;
			if (dot(multCol, multCol) < 0.001) multCol = float4(1,1,1,1);
			float4 finalCol = col * multCol * input.color;
			finalCol.a *= opacity;
			return finalCol;
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

		Texture2D _MainTex;
		SamplerState sampler_MainTex;

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
			output.uv = (input.uv * _MainTex_ST.xy) + _MainTex_ST.zw;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			return _MainTex.Sample(sampler_MainTex, input.uv);
		}
		ENDHLSL
	}
}
Fallback "Sprites/Default"
}