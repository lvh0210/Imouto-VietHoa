# Script sua toan bo shader Blit va PostProcess cua URP
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
    Write-Host "Successfully replaced Blit SubShader in: $(Split-Path $filePath -Leaf)"
}

$blitSubShader = @'
SubShader {
	Tags { "RenderType" = "Opaque" }
	LOD 100
	ZTest Always
	ZWrite Off
	Cull Off

	Pass {
		Name "BlitPass"
		HLSLPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		float4x4 unity_ObjectToWorld;
		float4x4 unity_MatrixVP;

		Texture2D _BlitTexture;
		SamplerState sampler_BlitTexture;
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
			output.uv = input.uv;
			return output;
		}

		float4 frag(Varyings input) : SV_TARGET {
			float4 col = _BlitTexture.Sample(sampler_BlitTexture, input.uv);
			if (dot(col, col) < 0.00001) {
				col = _MainTex.Sample(sampler_MainTex, input.uv);
			}
			return col;
		}
		ENDHLSL
	}
}
'@

$blitFiles = @(
    "$shaderDir\Hidden_Universal_CoreBlit.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_Blit.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_FinalPost.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_UberPost.shader",
    "$shaderDir\Hidden_Universal_CoreBlitColorAndDepth.shader",
    "$shaderDir\Hidden_Universal_BlitHDROverlay.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_Sampling.shader",
    "$shaderDir\Hidden_KToon_SSOutlinePostProcess.shader"
)

foreach ($f in $blitFiles) {
    Replace-SubShader $f $blitSubShader
}

Write-Host 'Done updating Blit shaders!'
