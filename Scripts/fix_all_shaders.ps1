# Script tá»± Ä‘á»™ng nÃ¢ng cáº¥p toÃ n bá»™ Shader URP cho Imouto Mobile
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
# 1. TEMPLATE: SPRITE TRANSPARENT SUB-SHADER
# ==========================================
$spriteSubShader = @'
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
'@

# Cáº­p nháº­t Sprite Shaders
Replace-SubShader "$shaderDir\AllIn1SpriteShader_AllIn1SpriteShader.shader" $spriteSubShader
Replace-SubShader "$shaderDir\AllIn1SpriteShader_AllIn1SpriteShaderUiMask.shader" $spriteSubShader
Replace-SubShader "$shaderDir\AnimeSpeedLine_Speed Lines.shader" $spriteSubShader

# ==========================================
# 2. TEMPLATE: KTOON OPAQUE TOON SUB-SHADER
# ==========================================
$ktoonOpaqueSubShader = @'
SubShader {
	Tags { 
		"RenderType" = "Opaque" 
		"Queue" = "Geometry"
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
		float4 _HColor;
		float4 _SColor;
		float _RampThreshold;
		float _RampSmoothing;

		float4 _MainLightPosition;
		float4 _MainLightColor;

		Texture2D _BaseMap;
		SamplerState sampler_BaseMap;

		struct Attributes {
			float4 positionOS : POSITION;
			float3 normalOS : NORMAL;
			float2 uv : TEXCOORD0;
		};

		struct Varyings {
			float4 positionCS : SV_POSITION;
			float2 uv : TEXCOORD0;
			float3 worldNormal : TEXCOORD1;
		};

		Varyings vert(Attributes input) {
			Varyings output;
			float4 worldPos = mul(unity_ObjectToWorld, input.positionOS);
			output.positionCS = mul(unity_MatrixVP, worldPos);
			output.uv = (input.uv * _BaseMap_ST.xy) + _BaseMap_ST.zw;
			output.worldNormal = mul((float3x3)unity_ObjectToWorld, input.normalOS);
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 albedo = _BaseMap.Sample(sampler_BaseMap, input.uv);
			
			float4 bColor = _BaseColor;
			if (dot(bColor, bColor) < 0.001) bColor = float4(1,1,1,1);
			float4 cColor = _Color;
			if (dot(cColor, cColor) < 0.001) cColor = float4(1,1,1,1);
			float4 tint = bColor * cColor;
			
			float3 lightDir = normalize(_MainLightPosition.xyz);
			if (dot(lightDir, lightDir) < 0.1) {
				lightDir = normalize(float3(0.3, 0.8, -0.5));
			}
			
			float3 normal = normalize(input.worldNormal);
			float ndotl = dot(normal, lightDir) * 0.5 + 0.5;
			
			float threshold = _RampThreshold > 0.001 ? _RampThreshold : 0.5;
			float smoothing = _RampSmoothing > 0.001 ? _RampSmoothing : 0.1;
			float ramp = smoothstep(threshold - smoothing, threshold + smoothing, ndotl);
			
			float3 shadowCol = _SColor.rgb;
			if (dot(shadowCol, shadowCol) < 0.001) shadowCol = float3(0.4, 0.4, 0.4);
			float3 highlightCol = _HColor.rgb;
			if (dot(highlightCol, highlightCol) < 0.001) highlightCol = float3(1.0, 1.0, 1.0);
			float3 rampColor = lerp(shadowCol, highlightCol, ramp);
			
			float3 finalRgb = albedo.rgb * tint.rgb * rampColor;
			return float4(finalRgb, albedo.a * tint.a);
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
'@

# Cáº­p nháº­t KToon Opaque & SS Shaders
Replace-SubShader "$shaderDir\KToon_KToon.shader" $ktoonOpaqueSubShader
Replace-SubShader "$shaderDir\KToon_KToonSSHand.shader" $ktoonOpaqueSubShader
Replace-SubShader "$shaderDir\KToon_KToonSS.shader" $ktoonOpaqueSubShader

# ==========================================
# 3. TEMPLATE: KTOON TRANSPARENT SUB-SHADER
# ==========================================
$ktoonTransparentSubShader = @'
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
		float4 _BaseMap_ST;
		float4 _BaseColor;
		float4 _Color;
		float4 _HColor;
		float4 _SColor;

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
'@

# Cáº­p nháº­t KToon Transparent
Replace-SubShader "$shaderDir\KToon_KToon Transparent.shader" $ktoonTransparentSubShader

# ==========================================
# 4. TEMPLATE: KTOON EYE SUB-SHADER
# ==========================================
$ktoonEyeSubShader = @'
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
'@

# Cáº­p nháº­t KToon Eye
Replace-SubShader "$shaderDir\KToon_KToon Eye.shader" $ktoonEyeSubShader

# ==========================================
# 5. TEMPLATE: LILTOON OPAQUE / OUTLINE SUB-SHADER
# ==========================================
$lilToonOpaqueSubShader = @'
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
		float4 _MainTex_ST;
		float4 _Color;

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
			float4 col = _MainTex.Sample(sampler_MainTex, input.uv);
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			return col * tint;
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
			float4 col = _MainTex.Sample(sampler_MainTex, input.uv);
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			return col * tint;
		}
		ENDHLSL
	}
}
Fallback "Universal Render Pipeline/Unlit"
'@

# Cáº­p nháº­t lilToon Opaque & Outline
Replace-SubShader "$shaderDir\Hidden_lilToonOutline.shader" $lilToonOpaqueSubShader
Replace-SubShader "$shaderDir\lilToon.shader" $lilToonOpaqueSubShader
Replace-SubShader "$shaderDir\Hidden_ltspass_opaque.shader" $lilToonOpaqueSubShader

# ==========================================
# 6. TEMPLATE: LILTOON TRANSPARENT SUB-SHADER
# ==========================================
$lilToonTransparentSubShader = @'
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
			float4 col = _MainTex.Sample(sampler_MainTex, input.uv);
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			return col * tint;
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
			float4 col = _MainTex.Sample(sampler_MainTex, input.uv);
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			return col * tint;
		}
		ENDHLSL
	}
}
Fallback "Universal Render Pipeline/Unlit"
'@

# Cáº­p nháº­t lilToon Transparent
Replace-SubShader "$shaderDir\Hidden_lilToonTransparent.shader" $lilToonTransparentSubShader
Replace-SubShader "$shaderDir\Hidden_lilToonTwoPassTransparent.shader" $lilToonTransparentSubShader
Replace-SubShader "$shaderDir\Hidden_lilToonTransparentOutline.shader" $lilToonTransparentSubShader
Replace-SubShader "$shaderDir\Hidden_ltspass_transparent.shader" $lilToonTransparentSubShader

# ==========================================
# 7. TEMPLATE: LILTOON CUTOUT SUB-SHADER
# ==========================================
$lilToonCutoutSubShader = @'
SubShader {
	Tags { 
		"Queue" = "AlphaTest" 
		"RenderType" = "TransparentCutout" 
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
		float4 _MainTex_ST;
		float4 _Color;
		float _Cutoff;

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
			float4 col = _MainTex.Sample(sampler_MainTex, input.uv);
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			float4 finalCol = col * tint;
			float cutoff = _Cutoff > 0.001 ? _Cutoff : 0.5;
			clip(finalCol.a - cutoff);
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
		float4 _Color;
		float _Cutoff;

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
			float4 col = _MainTex.Sample(sampler_MainTex, input.uv);
			float4 tint = _Color;
			if (dot(tint, tint) < 0.001) tint = float4(1,1,1,1);
			float4 finalCol = col * tint;
			float cutoff = _Cutoff > 0.001 ? _Cutoff : 0.5;
			clip(finalCol.a - cutoff);
			return finalCol;
		}
		ENDHLSL
	}
}
Fallback "Universal Render Pipeline/Unlit"
'@

# Cáº­p nháº­t lilToon Cutout
Replace-SubShader "$shaderDir\Hidden_lilToonCutout.shader" $lilToonCutoutSubShader
Replace-SubShader "$shaderDir\Hidden_ltspass_cutout.shader" $lilToonCutoutSubShader

# ==========================================
# 8. TEMPLATE: URP UNLIT & LIT SUB-SHADERS
# ==========================================
$urpUnlitSubShader = @'
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
'@

# Cáº­p nháº­t URP Unlit vÃ  Lit
Replace-SubShader "$shaderDir\Universal Render Pipeline_Unlit.shader" $urpUnlitSubShader
Replace-SubShader "$shaderDir\Universal Render Pipeline_Lit.shader" $urpUnlitSubShader
Replace-SubShader "$shaderDir\Universal Render Pipeline_Particles_Unlit.shader" $urpUnlitSubShader
Replace-SubShader "$shaderDir\Custom_URP_KPSPenetrator_Phase3_WithOutline.shader" $urpUnlitSubShader

# ==========================================
# 9. Sá»¬A CÃC SHADER ERROR / SILHOUETTE / PIXELIZE
# ==========================================
$silhouetteSubShader = @'
SubShader {
	Tags { 
		"Queue" = "Transparent" 
		"RenderType" = "Transparent" 
		"RenderPipeline" = "UniversalPipeline"
	}
	LOD 200
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
		float4 _BaseColor;

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
			float4 c = _BaseColor;
			if (dot(c, c) < 0.001) c = float4(1, 0, 0, 0.5);
			return c;
		}
		ENDHLSL
	}
}
'@

Replace-SubShader "$shaderDir\Custom_URP_SingleSilhouetteTransparent.shader" $silhouetteSubShader

Write-Host 'Done updating all shaders!'

