# Script sua toan bo cac shader Post effect de tranh lam chay sang trang man hinh
$ErrorActionPreference = "Stop"

$shaderDir = "D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project\ExportedProject\Assets\Shader"

function Replace-FragReturn {
    param(
        [string]$filePath,
        [string]$returnVal
    )
    if (-not (Test-Path $filePath)) {
        return
    }
    $raw = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    $raw = $raw.Replace("return float4(1.0, 1.0, 1.0, 1.0);", "return $returnVal;")
    [System.IO.File]::WriteAllText($filePath, $raw, [System.Text.Encoding]::UTF8)
    Write-Host "Updated: $(Split-Path $filePath -Leaf)"
}

$postEffects = @(
    "$shaderDir\Hidden_Universal Render Pipeline_Bloom.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_BokehDepthOfField.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_CameraMotionBlur.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_CameraMotionVectors.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_CopyDepth.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_Debug_DebugReplacement.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_Edge Adaptive Spatial Upsampling.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_FallbackLoading.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_GaussianDepthOfField.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_LensFlareDataDriven.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_LutBuilderHdr.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_LutBuilderLdr.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_ObjectMotionVectors.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_PaniniProjection.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_Scaling Setup.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_StencilDeferred.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_Stop NaN.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_SubpixelMorphologicalAntialiasing.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_TemporalAA.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_XR_XRMirrorView.shader",
    "$shaderDir\Hidden_Universal Render Pipeline_XR_XROcclusionMesh.shader",
    "$shaderDir\Hidden_Universal_HDRDebugView.shader"
)

foreach ($f in $postEffects) {
    Replace-FragReturn $f "float4(0.0, 0.0, 0.0, 0.0)"
}

Write-Host 'Done updating Post effect shaders!'
