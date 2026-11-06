Shader "Hidden/ltspass_cutout" {
	Properties {
		_DummyProperty ("If you are seeing this, some script is broken.", Float) = 0
		_DummyProperty ("This also happens if something other than lilToon is broken.", Float) = 0
		_DummyProperty ("You need to check the error on the console and take appropriate action, such as reinstalling the relevant tool.", Float) = 0
		_DummyProperty (" ", Float) = 0
		_DummyProperty ("これが表示されている場合、なんらかのスクリプトが壊れています。", Float) = 0
		_DummyProperty ("これはlilToon以外のものが壊れている場合にも発生します。", Float) = 0
		_DummyProperty ("コンソールでエラーを確認し、該当するツールを入れ直すなどの対処を行う必要があります。", Float) = 0
		[Space(1000)] _DummyProperty ("", Float) = 0
		[lilToggle] _Invisible ("sInvisible", Float) = 0
		_AsUnlit ("sAsUnlit", Range(0, 1)) = 0
		_Cutoff ("sCutoff", Range(-0.001, 1.001)) = 0.5
		_SubpassCutoff ("sSubpassCutoff", Range(0, 1)) = 0.5
		[lilToggle] _FlipNormal ("sFlipBackfaceNormal", Float) = 0
		[lilToggle] _ShiftBackfaceUV ("sShiftBackfaceUV", Float) = 0
		_BackfaceForceShadow ("sBackfaceForceShadow", Range(0, 1)) = 0
		[lilHDR] _BackfaceColor ("sColor", Vector) = (0,0,0,0)
		_VertexLightStrength ("sVertexLightStrength", Range(0, 1)) = 0
		_LightMinLimit ("sLightMinLimit", Range(0, 1)) = 0.05
		_LightMaxLimit ("sLightMaxLimit", Range(0, 10)) = 1
		_BeforeExposureLimit ("sBeforeExposureLimit", Float) = 10000
		_MonochromeLighting ("sMonochromeLighting", Range(0, 1)) = 0
		_AlphaBoostFA ("sAlphaBoostFA", Range(1, 100)) = 10
		_lilDirectionalLightStrength ("sDirectionalLightStrength", Range(0, 1)) = 1
		[lilVec3B] _LightDirectionOverride ("sLightDirectionOverrides", Vector) = (0.001,0.002,0.001,0)
		_AAStrength ("sAAShading", Range(0, 1)) = 1
		[lilToggle] _UseDither ("sDither", Float) = 0
		[NoScaleOffset] _DitherTex ("Dither", 2D) = "white" {}
		_DitherMaxValue ("Max Value", Float) = 255
		[lilHDR] _Color ("sColor", Vector) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		[lilUVAnim] _MainTex_ScrollRotate ("sScrollRotates", Vector) = (0,0,0,0)
		[lilHSVG] _MainTexHSVG ("sHSVGs", Vector) = (0,1,1,1)
		_MainGradationStrength ("Gradation Strength", Range(0, 1)) = 0
		[NoScaleOffset] _MainGradationTex ("Gradation Map", 2D) = "white" {}
		[NoScaleOffset] _MainColorAdjustMask ("Adjust Mask", 2D) = "white" {}
		[lilToggleLeft] _UseMain2ndTex ("sMainColor2nd", Float) = 0
		[lilHDR] _Color2nd ("sColor", Vector) = (1,1,1,1)
		_Main2ndTex ("Texture", 2D) = "white" {}
		[lilAngle] _Main2ndTexAngle ("sAngle", Float) = 0
		[lilUVAnim] _Main2ndTex_ScrollRotate ("sScrollRotates", Vector) = (0,0,0,0)
		[lilEnum] _Main2ndTex_UVMode ("UV Mode|UV0|UV1|UV2|UV3|MatCap", Float) = 0
		[lilEnum] _Main2ndTex_Cull ("sCullModes", Float) = 0
		[lilDecalAnim] _Main2ndTexDecalAnimation ("sDecalAnimations", Vector) = (1,1,1,30)
		[lilDecalSub] _Main2ndTexDecalSubParam ("sDecalSubParams", Vector) = (1,1,0,1)
		[lilToggle] _Main2ndTexIsDecal ("sAsDecal", Float) = 0
		[lilToggle] _Main2ndTexIsLeftOnly ("Left Only", Float) = 0
		[lilToggle] _Main2ndTexIsRightOnly ("Right Only", Float) = 0
		[lilToggle] _Main2ndTexShouldCopy ("Copy", Float) = 0
		[lilToggle] _Main2ndTexShouldFlipMirror ("Flip Mirror", Float) = 0
		[lilToggle] _Main2ndTexShouldFlipCopy ("Flip Copy", Float) = 0
		[lilToggle] _Main2ndTexIsMSDF ("sAsMSDF", Float) = 0
		[NoScaleOffset] _Main2ndBlendMask ("Mask", 2D) = "white" {}
		[lilEnum] _Main2ndTexBlendMode ("sBlendModes", Float) = 0
		[lilEnum] _Main2ndTexAlphaMode ("sAlphaModes", Float) = 0
		_Main2ndEnableLighting ("sEnableLighting", Range(0, 1)) = 1
		_Main2ndDissolveMask ("Dissolve Mask", 2D) = "white" {}
		_Main2ndDissolveNoiseMask ("Dissolve Noise Mask", 2D) = "gray" {}
		[lilUVAnim] _Main2ndDissolveNoiseMask_ScrollRotate ("Scroll", Vector) = (0,0,0,0)
		_Main2ndDissolveNoiseStrength ("Dissolve Noise Strength", Float) = 0.1
		[lilHDR] _Main2ndDissolveColor ("sColor", Vector) = (1,1,1,1)
		[lilDissolve] _Main2ndDissolveParams ("sDissolveParams", Vector) = (0,0,0.5,0.1)
		[lilDissolveP] _Main2ndDissolvePos ("Dissolve Position", Vector) = (0,0,0,0)
		[lilFFFB] _Main2ndDistanceFade ("sDistanceFadeSettings", Vector) = (0.1,0.01,0,0)
		[lilToggleLeft] _UseMain3rdTex ("sMainColor3rd", Float) = 0
		[lilHDR] _Color3rd ("sColor", Vector) = (1,1,1,1)
		_Main3rdTex ("Texture", 2D) = "white" {}
		[lilAngle] _Main3rdTexAngle ("sAngle", Float) = 0
		[lilUVAnim] _Main3rdTex_ScrollRotate ("sScrollRotates", Vector) = (0,0,0,0)
		[lilEnum] _Main3rdTex_UVMode ("UV Mode|UV0|UV1|UV2|UV3|MatCap", Float) = 0
		[lilEnum] _Main3rdTex_Cull ("sCullModes", Float) = 0
		[lilDecalAnim] _Main3rdTexDecalAnimation ("sDecalAnimations", Vector) = (1,1,1,30)
		[lilDecalSub] _Main3rdTexDecalSubParam ("sDecalSubParams", Vector) = (1,1,0,1)
		[lilToggle] _Main3rdTexIsDecal ("sAsDecal", Float) = 0
		[lilToggle] _Main3rdTexIsLeftOnly ("Left Only", Float) = 0
		[lilToggle] _Main3rdTexIsRightOnly ("Right Only", Float) = 0
		[lilToggle] _Main3rdTexShouldCopy ("Copy", Float) = 0
		[lilToggle] _Main3rdTexShouldFlipMirror ("Flip Mirror", Float) = 0
		[lilToggle] _Main3rdTexShouldFlipCopy ("Flip Copy", Float) = 0
		[lilToggle] _Main3rdTexIsMSDF ("sAsMSDF", Float) = 0
		[NoScaleOffset] _Main3rdBlendMask ("Mask", 2D) = "white" {}
		[lilEnum] _Main3rdTexBlendMode ("sBlendModes", Float) = 0
		[lilEnum] _Main3rdTexAlphaMode ("sAlphaModes", Float) = 0
		_Main3rdEnableLighting ("sEnableLighting", Range(0, 1)) = 1
		_Main3rdDissolveMask ("Dissolve Mask", 2D) = "white" {}
		_Main3rdDissolveNoiseMask ("Dissolve Noise Mask", 2D) = "gray" {}
		[lilUVAnim] _Main3rdDissolveNoiseMask_ScrollRotate ("Scroll", Vector) = (0,0,0,0)
		_Main3rdDissolveNoiseStrength ("Dissolve Noise Strength", Float) = 0.1
		[lilHDR] _Main3rdDissolveColor ("sColor", Vector) = (1,1,1,1)
		[lilDissolve] _Main3rdDissolveParams ("sDissolveParams", Vector) = (0,0,0.5,0.1)
		[lilDissolveP] _Main3rdDissolvePos ("Dissolve Position", Vector) = (0,0,0,0)
		[lilFFFB] _Main3rdDistanceFade ("sDistanceFadeSettings", Vector) = (0.1,0.01,0,0)
		[lilEnumLabel] _AlphaMaskMode ("sAlphaMaskModes", Float) = 0
		_AlphaMask ("AlphaMask", 2D) = "white" {}
		_AlphaMaskScale ("Scale", Float) = 1
		_AlphaMaskValue ("Offset", Float) = 0
		[lilToggleLeft] _UseBumpMap ("sNormalMap", Float) = 0
		[Normal] _BumpMap ("Normal Map", 2D) = "bump" {}
		_BumpScale ("Scale", Range(-10, 10)) = 1
		[lilToggleLeft] _UseBump2ndMap ("sNormalMap2nd", Float) = 0
		[Normal] _Bump2ndMap ("Normal Map", 2D) = "bump" {}
		[lilEnum] _Bump2ndMap_UVMode ("UV Mode|UV0|UV1|UV2|UV3", Float) = 0
		_Bump2ndScale ("Scale", Range(-10, 10)) = 1
		[NoScaleOffset] _Bump2ndScaleMask ("Mask", 2D) = "white" {}
		[lilToggleLeft] _UseAnisotropy ("sAnisotropy", Float) = 0
		[Normal] _AnisotropyTangentMap ("Tangent Map", 2D) = "bump" {}
		_AnisotropyScale ("Scale", Range(-1, 1)) = 1
		[NoScaleOffset] _AnisotropyScaleMask ("Scale Mask", 2D) = "white" {}
		_AnisotropyTangentWidth ("sTangentWidth", Range(0, 10)) = 1
		_AnisotropyBitangentWidth ("sBitangentWidth", Range(0, 10)) = 1
		_AnisotropyShift ("sOffset", Range(-10, 10)) = 0
		_AnisotropyShiftNoiseScale ("sNoiseStrength", Range(-1, 1)) = 0
		_AnisotropySpecularStrength ("sStrength", Range(0, 10)) = 1
		_Anisotropy2ndTangentWidth ("sTangentWidth", Range(0, 10)) = 1
		_Anisotropy2ndBitangentWidth ("sBitangentWidth", Range(0, 10)) = 1
		_Anisotropy2ndShift ("sOffset", Range(-10, 10)) = 0
		_Anisotropy2ndShiftNoiseScale ("sNoiseStrength", Range(-1, 1)) = 0
		_Anisotropy2ndSpecularStrength ("sStrength", Range(0, 10)) = 0
		_AnisotropyShiftNoiseMask ("sNoise", 2D) = "white" {}
		[lilToggle] _Anisotropy2Reflection ("sReflection", Float) = 0
		[lilToggle] _Anisotropy2MatCap ("sMatCap", Float) = 0
		[lilToggle] _Anisotropy2MatCap2nd ("sMatCap2nd", Float) = 0
		[lilToggleLeft] _UseBacklight ("sBacklight", Float) = 0
		[lilHDR] _BacklightColor ("sColor", Vector) = (0.85,0.8,0.7,1)
		[NoScaleOffset] _BacklightColorTex ("Texture", 2D) = "white" {}
		_BacklightMainStrength ("sMainColorPower", Range(0, 1)) = 0
		_BacklightNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		_BacklightBorder ("Border", Range(0, 1)) = 0.35
		_BacklightBlur ("sBlur", Range(0, 1)) = 0.05
		_BacklightDirectivity ("sDirectivity", Float) = 5
		_BacklightViewStrength ("sViewDirectionStrength", Range(0, 1)) = 1
		[lilToggle] _BacklightReceiveShadow ("sReceiveShadow", Float) = 1
		[lilToggle] _BacklightBackfaceMask ("sBackfaceMask", Float) = 1
		[lilToggleLeft] _UseShadow ("sShadow", Float) = 0
		_ShadowStrength ("sStrength", Range(0, 1)) = 1
		[NoScaleOffset] _ShadowStrengthMask ("sStrength", 2D) = "white" {}
		[lilLOD] _ShadowStrengthMaskLOD ("LOD", Range(0, 1)) = 0
		[NoScaleOffset] _ShadowBorderMask ("sBorder", 2D) = "white" {}
		[lilLOD] _ShadowBorderMaskLOD ("LOD", Range(0, 1)) = 0
		[NoScaleOffset] _ShadowBlurMask ("sBlur", 2D) = "white" {}
		[lilLOD] _ShadowBlurMaskLOD ("LOD", Range(0, 1)) = 0
		[lilFFFF] _ShadowAOShift ("1st Scale|1st Offset|2nd Scale|2nd Offset", Vector) = (1,0,1,0)
		[lilFF] _ShadowAOShift2 ("3rd Scale|3rd Offset", Vector) = (1,0,1,0)
		[lilToggle] _ShadowPostAO ("sIgnoreBorderProperties", Float) = 0
		[lilEnum] _ShadowColorType ("sShadowColorTypes", Float) = 0
		_ShadowColor ("Shadow Color", Vector) = (0.82,0.76,0.85,1)
		[NoScaleOffset] _ShadowColorTex ("Shadow Color", 2D) = "black" {}
		_ShadowNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		_ShadowBorder ("sBorder", Range(0, 1)) = 0.5
		_ShadowBlur ("sBlur", Range(0, 1)) = 0.1
		_ShadowReceive ("sReceiveShadow", Range(0, 1)) = 0
		_Shadow2ndColor ("2nd Color", Vector) = (0.68,0.66,0.79,1)
		[NoScaleOffset] _Shadow2ndColorTex ("2nd Color", 2D) = "black" {}
		_Shadow2ndNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		_Shadow2ndBorder ("sBorder", Range(0, 1)) = 0.15
		_Shadow2ndBlur ("sBlur", Range(0, 1)) = 0.1
		_Shadow2ndReceive ("sReceiveShadow", Range(0, 1)) = 0
		_Shadow3rdColor ("3rd Color", Vector) = (0,0,0,0)
		[NoScaleOffset] _Shadow3rdColorTex ("3rd Color", 2D) = "black" {}
		_Shadow3rdNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		_Shadow3rdBorder ("sBorder", Range(0, 1)) = 0.25
		_Shadow3rdBlur ("sBlur", Range(0, 1)) = 0.1
		_Shadow3rdReceive ("sReceiveShadow", Range(0, 1)) = 0
		_ShadowBorderColor ("sShadowBorderColor", Vector) = (1,0.1,0,1)
		_ShadowBorderRange ("sShadowBorderRange", Range(0, 1)) = 0.08
		_ShadowMainStrength ("sContrast", Range(0, 1)) = 0
		_ShadowEnvStrength ("sShadowEnvStrength", Range(0, 1)) = 0
		[lilEnum] _ShadowMaskType ("sShadowMaskTypes", Float) = 0
		_ShadowFlatBorder ("sBorder", Range(-2, 2)) = 1
		_ShadowFlatBlur ("sBlur", Range(0.001, 2)) = 1
		[lilToggleLeft] _UseRimShade ("RimShade", Float) = 0
		_RimShadeColor ("sColor", Vector) = (0.5,0.5,0.5,1)
		[NoScaleOffset] _RimShadeMask ("Mask", 2D) = "white" {}
		_RimShadeNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		_RimShadeBorder ("sBorder", Range(0, 1)) = 0.5
		_RimShadeBlur ("sBlur", Range(0, 1)) = 1
		[PowerSlider(3.0)] _RimShadeFresnelPower ("sFresnelPower", Range(0.01, 50)) = 1
		[lilToggleLeft] _UseReflection ("sReflection", Float) = 0
		_Smoothness ("Smoothness", Range(0, 1)) = 1
		[NoScaleOffset] _SmoothnessTex ("Smoothness", 2D) = "white" {}
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
		[NoScaleOffset] _MetallicGlossMap ("Metallic", 2D) = "white" {}
		[Gamma] _Reflectance ("sReflectance", Range(0, 1)) = 0.04
		_GSAAStrength ("GSAA", Range(0, 1)) = 0
		[lilToggle] _ApplySpecular ("Apply Specular", Float) = 1
		[lilToggle] _ApplySpecularFA ("sMultiLightSpecular", Float) = 1
		[lilToggle] _SpecularToon ("Specular Toon", Float) = 1
		_SpecularNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		_SpecularBorder ("sBorder", Range(0, 1)) = 0.5
		_SpecularBlur ("sBlur", Range(0, 1)) = 0
		[lilToggle] _ApplyReflection ("sApplyReflection", Float) = 0
		_ReflectionNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		[lilHDR] _ReflectionColor ("sColor", Vector) = (1,1,1,1)
		[NoScaleOffset] _ReflectionColorTex ("sColor", 2D) = "white" {}
		[lilToggle] _ReflectionApplyTransparency ("sApplyTransparency", Float) = 1
		[NoScaleOffset] _ReflectionCubeTex ("Cubemap Fallback", Cube) = "black" {}
		[lilHDR] _ReflectionCubeColor ("sColor", Vector) = (0,0,0,1)
		[lilToggle] _ReflectionCubeOverride ("Override", Float) = 0
		_ReflectionCubeEnableLighting ("sEnableLighting+ (Fallback)", Range(0, 1)) = 1
		[lilEnum] _ReflectionBlendMode ("sBlendModes", Float) = 1
		[lilToggleLeft] _UseMatCap ("sMatCap", Float) = 0
		[lilHDR] _MatCapColor ("sColor", Vector) = (1,1,1,1)
		_MatCapTex ("Texture", 2D) = "white" {}
		_MatCapMainStrength ("sMainColorPower", Range(0, 1)) = 0
		[lilVec2R] _MatCapBlendUV1 ("sBlendUV1", Vector) = (0,0,0,0)
		[lilToggle] _MatCapZRotCancel ("sMatCapZRotCancel", Float) = 1
		[lilToggle] _MatCapPerspective ("sFixPerspective", Float) = 1
		_MatCapVRParallaxStrength ("sVRParallaxStrength", Range(0, 1)) = 1
		_MatCapBlend ("Blend", Range(0, 1)) = 1
		[NoScaleOffset] _MatCapBlendMask ("Mask", 2D) = "white" {}
		_MatCapEnableLighting ("sEnableLighting", Range(0, 1)) = 1
		_MatCapShadowMask ("sShadowMask", Range(0, 1)) = 0
		[lilToggle] _MatCapBackfaceMask ("sBackfaceMask", Float) = 0
		_MatCapLod ("sBlur", Range(0, 10)) = 0
		[lilEnum] _MatCapBlendMode ("sBlendModes", Float) = 1
		[lilToggle] _MatCapApplyTransparency ("sApplyTransparency", Float) = 1
		_MatCapNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		[lilToggle] _MatCapCustomNormal ("sMatCapCustomNormal", Float) = 0
		[Normal] _MatCapBumpMap ("Normal Map", 2D) = "bump" {}
		_MatCapBumpScale ("Scale", Range(-10, 10)) = 1
		[lilToggleLeft] _UseMatCap2nd ("sMatCap2nd", Float) = 0
		[lilHDR] _MatCap2ndColor ("sColor", Vector) = (1,1,1,1)
		_MatCap2ndTex ("Texture", 2D) = "white" {}
		_MatCap2ndMainStrength ("sMainColorPower", Range(0, 1)) = 0
		[lilVec2R] _MatCap2ndBlendUV1 ("sBlendUV1", Vector) = (0,0,0,0)
		[lilToggle] _MatCap2ndZRotCancel ("sMatCapZRotCancel", Float) = 1
		[lilToggle] _MatCap2ndPerspective ("sFixPerspective", Float) = 1
		_MatCap2ndVRParallaxStrength ("sVRParallaxStrength", Range(0, 1)) = 1
		_MatCap2ndBlend ("Blend", Range(0, 1)) = 1
		[NoScaleOffset] _MatCap2ndBlendMask ("Mask", 2D) = "white" {}
		_MatCap2ndEnableLighting ("sEnableLighting", Range(0, 1)) = 1
		_MatCap2ndShadowMask ("sShadowMask", Range(0, 1)) = 0
		[lilToggle] _MatCap2ndBackfaceMask ("sBackfaceMask", Float) = 0
		_MatCap2ndLod ("sBlur", Range(0, 10)) = 0
		[lilEnum] _MatCap2ndBlendMode ("sBlendModes", Float) = 1
		[lilToggle] _MatCap2ndApplyTransparency ("sApplyTransparency", Float) = 1
		_MatCap2ndNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		[lilToggle] _MatCap2ndCustomNormal ("sMatCapCustomNormal", Float) = 0
		[Normal] _MatCap2ndBumpMap ("Normal Map", 2D) = "bump" {}
		_MatCap2ndBumpScale ("Scale", Range(-10, 10)) = 1
		[lilToggleLeft] _UseRim ("sRimLight", Float) = 0
		[lilHDR] _RimColor ("sColor", Vector) = (0.66,0.5,0.48,1)
		[NoScaleOffset] _RimColorTex ("Texture", 2D) = "white" {}
		_RimMainStrength ("sMainColorPower", Range(0, 1)) = 0
		_RimNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		_RimBorder ("sBorder", Range(0, 1)) = 0.5
		_RimBlur ("sBlur", Range(0, 1)) = 0.65
		[PowerSlider(3.0)] _RimFresnelPower ("sFresnelPower", Range(0.01, 50)) = 3.5
		_RimEnableLighting ("sEnableLighting", Range(0, 1)) = 1
		_RimShadowMask ("sShadowMask", Range(0, 1)) = 0.5
		[lilToggle] _RimBackfaceMask ("sBackfaceMask", Float) = 1
		_RimVRParallaxStrength ("sVRParallaxStrength", Range(0, 1)) = 1
		[lilToggle] _RimApplyTransparency ("sApplyTransparency", Float) = 1
		_RimDirStrength ("sRimLightDirection", Range(0, 1)) = 0
		_RimDirRange ("sRimDirectionRange", Range(-1, 1)) = 0
		_RimIndirRange ("sRimIndirectionRange", Range(-1, 1)) = 0
		[lilHDR] _RimIndirColor ("sColor", Vector) = (1,1,1,1)
		_RimIndirBorder ("sBorder", Range(0, 1)) = 0.5
		_RimIndirBlur ("sBlur", Range(0, 1)) = 0.1
		[lilEnum] _RimBlendMode ("sBlendModes", Float) = 1
		[lilToggleLeft] _UseGlitter ("sGlitter", Float) = 0
		[lilEnum] _GlitterUVMode ("UV Mode|UV0|UV1", Float) = 0
		[lilHDR] _GlitterColor ("sColor", Vector) = (1,1,1,1)
		_GlitterColorTex ("Texture", 2D) = "white" {}
		[lilEnum] _GlitterColorTex_UVMode ("UV Mode|UV0|UV1|UV2|UV3", Float) = 0
		_GlitterMainStrength ("sMainColorPower", Range(0, 1)) = 0
		_GlitterNormalStrength ("sNormalStrength", Range(0, 1)) = 1
		_GlitterScaleRandomize ("sRandomize+ (Size)", Range(0, 1)) = 0
		[lilToggle] _GlitterApplyShape ("Shape", Float) = 0
		_GlitterShapeTex ("Texture", 2D) = "white" {}
		[lilVec2] _GlitterAtras ("Atras", Vector) = (1,1,0,0)
		[lilToggle] _GlitterAngleRandomize ("sRandomize+ (+sAngle+)", Float) = 0
		[lilGlitParam1] _GlitterParams1 ("Tiling|Particle Size|Contrast", Vector) = (256,256,0.16,50)
		[lilGlitParam2] _GlitterParams2 ("sGlitterParams2", Vector) = (0.25,0,0,0)
		_GlitterPostContrast ("sPostContrast", Float) = 1
		_GlitterSensitivity ("Sensitivity", Float) = 0.25
		_GlitterEnableLighting ("sEnableLighting", Range(0, 1)) = 1
		_GlitterShadowMask ("sShadowMask", Range(0, 1)) = 0
		[lilToggle] _GlitterBackfaceMask ("sBackfaceMask", Float) = 0
		[lilToggle] _GlitterApplyTransparency ("sApplyTransparency", Float) = 1
		_GlitterVRParallaxStrength ("sVRParallaxStrength", Range(0, 1)) = 0
		[lilToggleLeft] _UseEmission ("sEmission", Float) = 0
		[lilHDR] [HDR] _EmissionColor ("sColor", Vector) = (1,1,1,1)
		_EmissionMap ("Texture", 2D) = "white" {}
		[lilUVAnim] _EmissionMap_ScrollRotate ("sScrollRotates", Vector) = (0,0,0,0)
		[lilEnum] _EmissionMap_UVMode ("UV Mode|UV0|UV1|UV2|UV3|Rim", Float) = 0
		_EmissionMainStrength ("sMainColorPower", Range(0, 1)) = 0
		_EmissionBlend ("Blend", Range(0, 1)) = 1
		_EmissionBlendMask ("Mask", 2D) = "white" {}
		[lilUVAnim] _EmissionBlendMask_ScrollRotate ("sScrollRotates", Vector) = (0,0,0,0)
		[lilEnum] _EmissionBlendMode ("sBlendModes", Float) = 1
		[lilBlink] _EmissionBlink ("sBlinkSettings", Vector) = (0,0,3.141593,0)
		[lilToggle] _EmissionUseGrad ("sGradation", Float) = 0
		[NoScaleOffset] _EmissionGradTex ("Gradation Texture", 2D) = "white" {}
		_EmissionGradSpeed ("Gradation Speed", Float) = 1
		_EmissionParallaxDepth ("sParallaxDepth", Float) = 0
		_EmissionFluorescence ("sFluorescence", Range(0, 1)) = 0
		[HideInInspector] _egci ("", Float) = 2
		[HideInInspector] _egai ("", Float) = 2
		[HideInInspector] _egc0 ("", Vector) = (1,1,1,0)
		[HideInInspector] _egc1 ("", Vector) = (1,1,1,1)
		[HideInInspector] _egc2 ("", Vector) = (1,1,1,0)
		[HideInInspector] _egc3 ("", Vector) = (1,1,1,0)
		[HideInInspector] _egc4 ("", Vector) = (1,1,1,0)
		[HideInInspector] _egc5 ("", Vector) = (1,1,1,0)
		[HideInInspector] _egc6 ("", Vector) = (1,1,1,0)
		[HideInInspector] _egc7 ("", Vector) = (1,1,1,0)
		[HideInInspector] _ega0 ("", Vector) = (1,0,0,0)
		[HideInInspector] _ega1 ("", Vector) = (1,0,0,1)
		[HideInInspector] _ega2 ("", Vector) = (1,0,0,0)
		[HideInInspector] _ega3 ("", Vector) = (1,0,0,0)
		[HideInInspector] _ega4 ("", Vector) = (1,0,0,0)
		[HideInInspector] _ega5 ("", Vector) = (1,0,0,0)
		[HideInInspector] _ega6 ("", Vector) = (1,0,0,0)
		[HideInInspector] _ega7 ("", Vector) = (1,0,0,0)
		[lilToggleLeft] _UseEmission2nd ("sEmission2nd", Float) = 0
		[lilHDR] [HDR] _Emission2ndColor ("sColor", Vector) = (1,1,1,1)
		_Emission2ndMap ("Texture", 2D) = "white" {}
		[lilUVAnim] _Emission2ndMap_ScrollRotate ("sScrollRotates", Vector) = (0,0,0,0)
		[lilEnum] _Emission2ndMap_UVMode ("UV Mode|UV0|UV1|UV2|UV3|Rim", Float) = 0
		_Emission2ndMainStrength ("sMainColorPower", Range(0, 1)) = 0
		_Emission2ndBlend ("Blend", Range(0, 1)) = 1
		_Emission2ndBlendMask ("Mask", 2D) = "white" {}
		[lilUVAnim] _Emission2ndBlendMask_ScrollRotate ("sScrollRotates", Vector) = (0,0,0,0)
		[lilEnum] _Emission2ndBlendMode ("sBlendModes", Float) = 1
		[lilBlink] _Emission2ndBlink ("sBlinkSettings", Vector) = (0,0,3.141593,0)
		[lilToggle] _Emission2ndUseGrad ("sGradation", Float) = 0
		[NoScaleOffset] _Emission2ndGradTex ("Gradation Texture", 2D) = "white" {}
		_Emission2ndGradSpeed ("Gradation Speed", Float) = 1
		_Emission2ndParallaxDepth ("sParallaxDepth", Float) = 0
		_Emission2ndFluorescence ("sFluorescence", Range(0, 1)) = 0
		[HideInInspector] _e2gci ("", Float) = 2
		[HideInInspector] _e2gai ("", Float) = 2
		[HideInInspector] _e2gc0 ("", Vector) = (1,1,1,0)
		[HideInInspector] _e2gc1 ("", Vector) = (1,1,1,1)
		[HideInInspector] _e2gc2 ("", Vector) = (1,1,1,0)
		[HideInInspector] _e2gc3 ("", Vector) = (1,1,1,0)
		[HideInInspector] _e2gc4 ("", Vector) = (1,1,1,0)
		[HideInInspector] _e2gc5 ("", Vector) = (1,1,1,0)
		[HideInInspector] _e2gc6 ("", Vector) = (1,1,1,0)
		[HideInInspector] _e2gc7 ("", Vector) = (1,1,1,0)
		[HideInInspector] _e2ga0 ("", Vector) = (1,0,0,0)
		[HideInInspector] _e2ga1 ("", Vector) = (1,0,0,1)
		[HideInInspector] _e2ga2 ("", Vector) = (1,0,0,0)
		[HideInInspector] _e2ga3 ("", Vector) = (1,0,0,0)
		[HideInInspector] _e2ga4 ("", Vector) = (1,0,0,0)
		[HideInInspector] _e2ga5 ("", Vector) = (1,0,0,0)
		[HideInInspector] _e2ga6 ("", Vector) = (1,0,0,0)
		[HideInInspector] _e2ga7 ("", Vector) = (1,0,0,0)
		[lilToggleLeft] _UseParallax ("sParallax", Float) = 0
		[lilToggle] _UsePOM ("sPOM", Float) = 0
		[NoScaleOffset] _ParallaxMap ("Parallax Map", 2D) = "gray" {}
		_Parallax ("Parallax Scale", Float) = 0.02
		_ParallaxOffset ("sParallaxOffset", Float) = 0.5
		[lilHDR] _DistanceFadeColor ("sColor", Vector) = (0,0,0,1)
		[lilFFFB] _DistanceFade ("sDistanceFadeSettings", Vector) = (0.1,0.01,0,0)
		[lilEnum] _DistanceFadeMode ("sDistanceFadeModes", Float) = 0
		[lilHDR] _DistanceFadeRimColor ("sColor", Vector) = (0,0,0,0)
		[PowerSlider(3.0)] _DistanceFadeRimFresnelPower ("sFresnelPower", Range(0.01, 50)) = 5
		[lilToggleLeft] _UseAudioLink ("sAudioLink", Float) = 0
		[lilFRFR] _AudioLinkDefaultValue ("Strength|Blink Strength|Blink Speed|Blink Threshold", Vector) = (0,0,2,0.75)
		[lilEnum] _AudioLinkUVMode ("sAudioLinkUVModes", Float) = 1
		[lilALUVParams] _AudioLinkUVParams ("Scale|Offset|sAngle|Band|Bass|Low Mid|High Mid|Treble", Vector) = (0.25,0,0,0.125)
		[lilVec3] _AudioLinkStart ("sAudioLinkStartPosition", Vector) = (0,0,0,0)
		_AudioLinkMask ("Mask", 2D) = "blue" {}
		[lilUVAnim] _AudioLinkMask_ScrollRotate ("sScrollRotates", Vector) = (0,0,0,0)
		[lilEnum] _AudioLinkMask_UVMode ("UV Mode|UV0|UV1|UV2|UV3", Float) = 0
		[lilToggle] _AudioLink2Main2nd ("sMainColor2nd", Float) = 0
		[lilToggle] _AudioLink2Main3rd ("sMainColor3rd", Float) = 0
		[lilToggle] _AudioLink2Emission ("sEmission", Float) = 0
		[lilToggle] _AudioLink2EmissionGrad ("sEmission+sGradation", Float) = 0
		[lilToggle] _AudioLink2Emission2nd ("sEmission2nd", Float) = 0
		[lilToggle] _AudioLink2Emission2ndGrad ("sEmission2nd+sGradation", Float) = 0
		[lilToggle] _AudioLink2Vertex ("sVertex", Float) = 0
		[lilEnum] _AudioLinkVertexUVMode ("sAudioLinkVertexUVModes", Float) = 1
		[lilALUVParams] _AudioLinkVertexUVParams ("Scale|Offset|sAngle|Band|Bass|Low Mid|High Mid|Treble", Vector) = (0.25,0,0,0.125)
		[lilVec3] _AudioLinkVertexStart ("sAudioLinkStartPosition", Vector) = (0,0,0,0)
		[lilVec3Float] _AudioLinkVertexStrength ("sAudioLinkVertexStrengths", Vector) = (0,0,0,1)
		[lilToggle] _AudioLinkAsLocal ("sAudioLinkAsLocal", Float) = 0
		[NoScaleOffset] _AudioLinkLocalMap ("Local Map", 2D) = "black" {}
		[lilALLocal] _AudioLinkLocalMapParams ("sAudioLinkLocalMapParams", Vector) = (120,1,0,0)
		_DissolveMask ("Dissolve Mask", 2D) = "white" {}
		_DissolveNoiseMask ("Dissolve Noise Mask", 2D) = "gray" {}
		[lilUVAnim] _DissolveNoiseMask_ScrollRotate ("Scroll", Vector) = (0,0,0,0)
		_DissolveNoiseStrength ("Dissolve Noise Strength", Float) = 0.1
		[lilHDR] _DissolveColor ("sColor", Vector) = (1,1,1,1)
		[lilDissolve] _DissolveParams ("sDissolveParamsModes", Vector) = (0,0,0.5,0.1)
		[lilDissolveP] _DissolvePos ("Dissolve Position", Vector) = (0,0,0,0)
		[ToggleUI] _IDMaskCompile ("_IDMaskCompile", Float) = 0
		[lilEnum] _IDMaskFrom ("_IDMaskFrom|0: UV0|1: UV1|2: UV2|3: UV3|4: UV4|5: UV5|6: UV6|7: UV7|8: VertexID", Float) = 8
		[ToggleUI] _IDMask1 ("_IDMask1", Float) = 0
		[ToggleUI] _IDMask2 ("_IDMask2", Float) = 0
		[ToggleUI] _IDMask3 ("_IDMask3", Float) = 0
		[ToggleUI] _IDMask4 ("_IDMask4", Float) = 0
		[ToggleUI] _IDMask5 ("_IDMask5", Float) = 0
		[ToggleUI] _IDMask6 ("_IDMask6", Float) = 0
		[ToggleUI] _IDMask7 ("_IDMask7", Float) = 0
		[ToggleUI] _IDMask8 ("_IDMask8", Float) = 0
		[ToggleUI] _IDMaskIsBitmap ("_IDMaskIsBitmap", Float) = 0
		_IDMaskIndex1 ("_IDMaskIndex1", Float) = 0
		_IDMaskIndex2 ("_IDMaskIndex2", Float) = 0
		_IDMaskIndex3 ("_IDMaskIndex3", Float) = 0
		_IDMaskIndex4 ("_IDMaskIndex4", Float) = 0
		_IDMaskIndex5 ("_IDMaskIndex5", Float) = 0
		_IDMaskIndex6 ("_IDMaskIndex6", Float) = 0
		_IDMaskIndex7 ("_IDMaskIndex7", Float) = 0
		_IDMaskIndex8 ("_IDMaskIndex8", Float) = 0
		[ToggleUI] _IDMaskControlsDissolve ("_IDMaskControlsDissolve", Float) = 0
		[ToggleUI] _IDMaskPrior1 ("_IDMaskPrior1", Float) = 0
		[ToggleUI] _IDMaskPrior2 ("_IDMaskPrior2", Float) = 0
		[ToggleUI] _IDMaskPrior3 ("_IDMaskPrior3", Float) = 0
		[ToggleUI] _IDMaskPrior4 ("_IDMaskPrior4", Float) = 0
		[ToggleUI] _IDMaskPrior5 ("_IDMaskPrior5", Float) = 0
		[ToggleUI] _IDMaskPrior6 ("_IDMaskPrior6", Float) = 0
		[ToggleUI] _IDMaskPrior7 ("_IDMaskPrior7", Float) = 0
		[ToggleUI] _IDMaskPrior8 ("_IDMaskPrior8", Float) = 0
		[lilToggleLeft] _UDIMDiscardCompile ("sUDIMDiscard", Float) = 0
		[lilEnum] _UDIMDiscardUV ("sUDIMDiscardUV|0: UV0|1: UV1|2: UV2|3: UV3", Float) = 0
		[lilEnum] _UDIMDiscardMode ("sUDIMDiscardMode|0: Vertex|1: Pixel (slower)", Float) = 0
		[lilToggle] _UDIMDiscardRow3_3 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow3_2 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow3_1 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow3_0 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow2_3 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow2_2 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow2_1 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow2_0 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow1_3 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow1_2 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow1_1 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow1_0 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow0_3 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow0_2 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow0_1 ("", Float) = 0
		[lilToggle] _UDIMDiscardRow0_0 ("", Float) = 0
		[lilToggle] _IgnoreEncryption ("sIgnoreEncryption", Float) = 0
		_Keys ("sKeys", Vector) = (0,0,0,0)
		_BitKey0 ("_BitKey0", Float) = 0
		_BitKey1 ("_BitKey1", Float) = 0
		_BitKey2 ("_BitKey2", Float) = 0
		_BitKey3 ("_BitKey3", Float) = 0
		_BitKey4 ("_BitKey4", Float) = 0
		_BitKey5 ("_BitKey5", Float) = 0
		_BitKey6 ("_BitKey6", Float) = 0
		_BitKey7 ("_BitKey7", Float) = 0
		_BitKey8 ("_BitKey8", Float) = 0
		_BitKey9 ("_BitKey9", Float) = 0
		_BitKey10 ("_BitKey10", Float) = 0
		_BitKey11 ("_BitKey11", Float) = 0
		_BitKey12 ("_BitKey12", Float) = 0
		_BitKey13 ("_BitKey13", Float) = 0
		_BitKey14 ("_BitKey14", Float) = 0
		_BitKey15 ("_BitKey15", Float) = 0
		_BitKey16 ("_BitKey16", Float) = 0
		_BitKey17 ("_BitKey17", Float) = 0
		_BitKey18 ("_BitKey18", Float) = 0
		_BitKey19 ("_BitKey19", Float) = 0
		_BitKey20 ("_BitKey20", Float) = 0
		_BitKey21 ("_BitKey21", Float) = 0
		_BitKey22 ("_BitKey22", Float) = 0
		_BitKey23 ("_BitKey23", Float) = 0
		_BitKey24 ("_BitKey24", Float) = 0
		_BitKey25 ("_BitKey25", Float) = 0
		_BitKey26 ("_BitKey26", Float) = 0
		_BitKey27 ("_BitKey27", Float) = 0
		_BitKey28 ("_BitKey28", Float) = 0
		_BitKey29 ("_BitKey29", Float) = 0
		_BitKey30 ("_BitKey30", Float) = 0
		_BitKey31 ("_BitKey31", Float) = 0
		[lilHDR] _OutlineColor ("sColor", Vector) = (0.6,0.56,0.73,1)
		_OutlineTex ("Texture", 2D) = "white" {}
		[lilUVAnim] _OutlineTex_ScrollRotate ("sScrollRotates", Vector) = (0,0,0,0)
		[lilHSVG] _OutlineTexHSVG ("sHSVGs", Vector) = (0,1,1,1)
		[lilHDR] _OutlineLitColor ("sColor", Vector) = (1,0.2,0,0)
		[lilToggle] _OutlineLitApplyTex ("sColorFromMain", Float) = 0
		_OutlineLitScale ("Scale", Float) = 10
		_OutlineLitOffset ("Offset", Float) = -8
		[lilToggle] _OutlineLitShadowReceive ("sReceiveShadow", Float) = 0
		[lilOLWidth] _OutlineWidth ("Width", Range(0, 1)) = 0.08
		[NoScaleOffset] _OutlineWidthMask ("Width", 2D) = "white" {}
		_OutlineFixWidth ("sFixWidth", Range(0, 1)) = 0.5
		[lilEnum] _OutlineVertexR2Width ("sOutlineVertexColorUsages", Float) = 0
		[lilToggle] _OutlineDeleteMesh ("sDeleteMesh0", Float) = 0
		[NoScaleOffset] [Normal] _OutlineVectorTex ("Vector", 2D) = "bump" {}
		[lilEnum] _OutlineVectorUVMode ("UV Mode|UV0|UV1|UV2|UV3", Float) = 0
		_OutlineVectorScale ("Vector scale", Range(-10, 10)) = 1
		_OutlineEnableLighting ("sEnableLighting", Range(0, 1)) = 1
		_OutlineZBias ("Z Bias", Float) = 0
		[lilToggle] _OutlineDisableInVR ("sDisableInVR", Float) = 0
		_TessEdge ("sTessellationEdge", Range(1, 100)) = 10
		_TessStrength ("sStrength", Range(0, 1)) = 0.5
		_TessShrink ("sTessellationShrink", Range(0, 1)) = 0
		[IntRange] _TessFactorMax ("sTessellationFactor", Range(1, 8)) = 3
		[lilToggleLeft] _UseOutline ("Use Outline", Float) = 0
		[lilEnum] _TransparentMode ("Rendering Mode|Opaque|Cutout|Transparent|Refraction|Fur|FurCutout|Gem", Float) = 0
		[lilToggle] _UseClippingCanceller ("sSettingClippingCanceller", Float) = 0
		[lilToggle] _AsOverlay ("sAsOverlay", Float) = 0
		[HideInInspector] _BaseColor ("sColor", Vector) = (1,1,1,1)
		[HideInInspector] _BaseMap ("Texture", 2D) = "white" {}
		[HideInInspector] _BaseColorMap ("Texture", 2D) = "white" {}
		[HideInInspector] _lilToonVersion ("Version", Float) = 42
		[lilEnum] _Cull ("sCullModes", Float) = 2
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("sSrcBlendRGB", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("sDstBlendRGB", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendAlpha ("sSrcBlendAlpha", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlendAlpha ("sDstBlendAlpha", Float) = 10
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOp ("sBlendOpRGB", Float) = 0
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOpAlpha ("sBlendOpAlpha", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendFA ("sSrcBlendRGB", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlendFA ("sDstBlendRGB", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendAlphaFA ("sSrcBlendAlpha", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlendAlphaFA ("sDstBlendAlpha", Float) = 1
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOpFA ("sBlendOpRGB", Float) = 4
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOpAlphaFA ("sBlendOpAlpha", Float) = 4
		[lilToggle] _ZClip ("sZClip", Float) = 1
		[lilToggle] _ZWrite ("sZWrite", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("sZTest", Float) = 4
		[IntRange] _StencilRef ("Ref", Range(0, 255)) = 0
		[IntRange] _StencilReadMask ("ReadMask", Range(0, 255)) = 255
		[IntRange] _StencilWriteMask ("WriteMask", Range(0, 255)) = 255
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Comp", Float) = 8
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilPass ("Pass", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Fail", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("ZFail", Float) = 0
		_OffsetFactor ("sOffsetFactor", Float) = 0
		_OffsetUnits ("sOffsetUnits", Float) = 0
		[lilColorMask] _ColorMask ("sColorMask", Float) = 15
		[lilToggle] _AlphaToMask ("sAlphaToMask", Float) = 1
		_lilShadowCasterBias ("Shadow Caster Bias", Float) = 0
		[lilEnum] _OutlineCull ("sCullModes", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _OutlineSrcBlend ("sSrcBlendRGB", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _OutlineDstBlend ("sDstBlendRGB", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _OutlineSrcBlendAlpha ("sSrcBlendAlpha", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _OutlineDstBlendAlpha ("sDstBlendAlpha", Float) = 10
		[Enum(UnityEngine.Rendering.BlendOp)] _OutlineBlendOp ("sBlendOpRGB", Float) = 0
		[Enum(UnityEngine.Rendering.BlendOp)] _OutlineBlendOpAlpha ("sBlendOpAlpha", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _OutlineSrcBlendFA ("sSrcBlendRGB", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _OutlineDstBlendFA ("sDstBlendRGB", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _OutlineSrcBlendAlphaFA ("sSrcBlendAlpha", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _OutlineDstBlendAlphaFA ("sDstBlendAlpha", Float) = 1
		[Enum(UnityEngine.Rendering.BlendOp)] _OutlineBlendOpFA ("sBlendOpRGB", Float) = 4
		[Enum(UnityEngine.Rendering.BlendOp)] _OutlineBlendOpAlphaFA ("sBlendOpAlpha", Float) = 4
		[lilToggle] _OutlineZClip ("sZClip", Float) = 1
		[lilToggle] _OutlineZWrite ("sZWrite", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _OutlineZTest ("sZTest", Float) = 2
		[IntRange] _OutlineStencilRef ("Ref", Range(0, 255)) = 0
		[IntRange] _OutlineStencilReadMask ("ReadMask", Range(0, 255)) = 255
		[IntRange] _OutlineStencilWriteMask ("WriteMask", Range(0, 255)) = 255
		[Enum(UnityEngine.Rendering.CompareFunction)] _OutlineStencilComp ("Comp", Float) = 8
		[Enum(UnityEngine.Rendering.StencilOp)] _OutlineStencilPass ("Pass", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _OutlineStencilFail ("Fail", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _OutlineStencilZFail ("ZFail", Float) = 0
		_OutlineOffsetFactor ("sOffsetFactor", Float) = 0
		_OutlineOffsetUnits ("sOffsetUnits", Float) = 0
		[lilColorMask] _OutlineColorMask ("sColorMask", Float) = 15
		[lilToggle] _OutlineAlphaToMask ("sAlphaToMask", Float) = 1
	}
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
}