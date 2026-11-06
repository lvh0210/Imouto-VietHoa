# Script bo sung sua cac shader con lai
$ErrorActionPreference = "Stop"

$shaderDir = "D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project\ExportedProject\Assets\Shader"

function Replace-SubShader {
    param(
        [string]$filePath,
        [string]$newSubShader
    )
    if (-not (Test-Path $filePath)) {
        Write-Warning "File not found: $filePath"
        return
    }
    $raw = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    $marker = "//DummyShaderTextExporter"
    $idx = $raw.IndexOf($marker)
    if ($idx -lt 0) {
        $idx = $raw.IndexOf("SubShader")
    }
    if ($idx -lt 0) {
        Write-Warning "No SubShader found in $filePath"
        return
    }
    $props = $raw.Substring(0, $idx).TrimEnd()
    $full = $props + "`r`n`t" + $newSubShader.Trim() + "`r`n}"
    [System.IO.File]::WriteAllText($filePath, $full, [System.Text.Encoding]::UTF8)
    Write-Host "Successfully replaced SubShader in: $(Split-Path $filePath -Leaf)"
}

# ==========================================
# 1. LIVE2D CUBISM UNLIT
# ==========================================
$live2dSubShader = @'
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
'@

Replace-SubShader "$shaderDir\Live2D Cubism_Unlit.shader" $live2dSubShader
Replace-SubShader "$shaderDir\Live2D Cubism_Unlit_0.shader" $live2dSubShader

# ==========================================
# 2. LOCAL PIXELIZE URP (MOSAIC CHE MỜ)
# ==========================================
$pixelizeSubShader = @'
SubShader {
	Tags { 
		"Queue" = "Transparent+100" 
		"RenderType" = "Transparent" 
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
		float4 _CellSize;

		struct Attributes {
			float4 positionOS : POSITION;
		};

		struct Varyings {
			float4 positionCS : SV_POSITION;
		};

		Varyings vert(Attributes input) {
			Varyings output;
			output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.positionOS));
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			// Transparent mosaic overlay (thay vì màu trắng xoá mù mịt)
			return float4(0.0, 0.0, 0.0, 0.0);
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

		struct Attributes {
			float4 positionOS : POSITION;
		};

		struct Varyings {
			float4 positionCS : SV_POSITION;
		};

		Varyings vert(Attributes input) {
			Varyings output;
			output.positionCS = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.positionOS));
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			return float4(0.0, 0.0, 0.0, 0.0);
		}
		ENDHLSL
	}
}
'@

Replace-SubShader "$shaderDir\LocalPixelizeURP.shader" $pixelizeSubShader

# ==========================================
# 3. PARTICLES & EFFECTS
# ==========================================
$particleSubShader = @'
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
'@

Replace-SubShader "$shaderDir\Effect_Particles_Blend_CenterGlow.shader" $particleSubShader
Replace-SubShader "$shaderDir\Shader Graphs_HS_Blend_CG.shader" $particleSubShader
Replace-SubShader "$shaderDir\Cartoon FX_Remaster_Particle Ubershader.shader" $particleSubShader

Write-Host 'Done updating remaining shaders!'
