Shader "Naninovel/FX/Digital Glitch" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_GlitchTex ("Glitch Texture", 2D) = "white" {}
		_Intensity ("Glitch Intensity", Range(0.5, 2)) = 1
		_ColorTint ("Color Tint", Vector) = (0.2,0.2,0,0)
		_BurnColors ("Burn Colors", Range(0, 1)) = 1
		_DodgeColors ("Dodge Colors", Range(0, 1)) = 0
		_PerformUVShifting ("Perform UV Shifting", Range(0, 1)) = 1
		_PerformColorShifting ("Perform Color Shifting", Range(0, 1)) = 1
		_PerformScreenShifting ("Perform Screen Shifting", Range(0, 1)) = 1
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			float4x4 unity_ObjectToWorld;
			float4x4 unity_MatrixVP;
			float4 _MainTex_ST;

			struct Vertex_Stage_Input
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct Vertex_Stage_Output
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			Vertex_Stage_Output vert(Vertex_Stage_Input input)
			{
				Vertex_Stage_Output output;
				output.uv = (input.uv.xy * _MainTex_ST.xy) + _MainTex_ST.zw;
				output.pos = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.pos));
				return output;
			}

			Texture2D<float4> _MainTex;
			SamplerState sampler_MainTex;

			struct Fragment_Stage_Input
			{
				float2 uv : TEXCOORD0;
			};

			float4 frag(Fragment_Stage_Input input) : SV_TARGET
			{
				return _MainTex.Sample(sampler_MainTex, input.uv.xy);
			}

			ENDHLSL
		}
	}
}