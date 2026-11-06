using System;
using System.IO;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEngine;

public class Builder
{
    [MenuItem("Build/Build Android Native APK")]
    public static void BuildAndroidAPK()
    {
        Debug.Log("=== BẮT ĐẦU QUY TRÌNH BIÊN DỊCH NATIVE ANDROID APK ===");

        // 1. Cấu hình SDK / NDK / JDK Paths
        string editorDataDir = Path.Combine(EditorApplication.applicationContentsPath, "PlaybackEngines/AndroidPlayer");
        string sdkDir = Path.Combine(editorDataDir, "SDK");
        string ndkDir = Path.Combine(editorDataDir, "NDK");
        string jdkDir = Path.Combine(editorDataDir, "OpenJDK");

        if (Directory.Exists(sdkDir))
        {
            EditorPrefs.SetString("AndroidSdkRoot", sdkDir);
            Debug.Log($"[Builder] AndroidSdkRoot: {sdkDir}");
        }
        if (Directory.Exists(ndkDir))
        {
            EditorPrefs.SetString("AndroidNdkRoot", ndkDir);
            EditorPrefs.SetString("AndroidNdkRootR23b", ndkDir);
            Debug.Log($"[Builder] AndroidNdkRoot: {ndkDir}");
        }
        if (Directory.Exists(jdkDir))
        {
            EditorPrefs.SetString("JdkPath", jdkDir);
            Debug.Log($"[Builder] JdkPath: {jdkDir}");
        }

        // 2. Chuyển đổi Build Target sang Android
        if (EditorUserBuildSettings.activeBuildTarget != BuildTarget.Android)
        {
            Debug.Log("[Builder] Chuyển đổi Active Build Target sang Android...");
            EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.Android, BuildTarget.Android);
        }

        // 3. Cấu hình Player Settings cho Android
        PlayerSettings.companyName = "ImoutoTeam";
        PlayerSettings.productName = "妹と過ごす1ヵ月間_Re";
        PlayerSettings.bundleVersion = "1.0.0";
        PlayerSettings.Android.bundleVersionCode = 1; // BẮT BUỘC DƯƠNG >= 1
        PlayerSettings.SetApplicationIdentifier(BuildTargetGroup.Android, "com.imouto.viethoa");

        // IL2CPP 64-bit (ARM64)
        PlayerSettings.SetScriptingBackend(BuildTargetGroup.Android, ScriptingImplementation.IL2CPP);
        PlayerSettings.Android.targetArchitectures = AndroidArchitecture.ARM64;
        PlayerSettings.Android.minSdkVersion = AndroidSdkVersions.AndroidApiLevel26; // Android 8.0
        PlayerSettings.Android.targetSdkVersion = AndroidSdkVersions.AndroidApiLevel33; // Android 13

        // Khóa Graphics API chuẩn OpenGLES3 (loại trừ lỗi màn đen Vulkan trên Android mobile)
        PlayerSettings.SetUseDefaultGraphicsAPIs(BuildTarget.Android, false);
        PlayerSettings.SetGraphicsAPIs(BuildTarget.Android, new[] { UnityEngine.Rendering.GraphicsDeviceType.OpenGLES3 });

        // Xuất file APK trực tiếp (không dùng .aab)
        EditorUserBuildSettings.buildAppBundle = false;
        EditorUserBuildSettings.exportAsGoogleAndroidProject = false;

        // Xoay màn hình Landscape
        PlayerSettings.defaultInterfaceOrientation = UIOrientation.LandscapeLeft;

        // 4. Thu thập danh sách Scenes
        List<string> scenesList = new List<string>();
        foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
        {
            if (scene.enabled && !string.IsNullOrEmpty(scene.path))
            {
                scenesList.Add(scene.path);
                Debug.Log($"[Builder] Scene added: {scene.path}");
            }
        }

        if (scenesList.Count == 0)
        {
            Debug.LogError("[Builder] LỖI: Không tìm thấy scenes nào trong EditorBuildSettings!");
            EditorApplication.Exit(1);
            return;
        }

        // 5. Đường dẫn output
        string outputDir = @"D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project\BuildOutput";
        if (!Directory.Exists(outputDir))
        {
            Directory.CreateDirectory(outputDir);
        }
        string apkPath = Path.Combine(outputDir, "Imouto_Native_Unsigned.apk");

        // 6. Thực hiện Build
        BuildPlayerOptions buildOptions = new BuildPlayerOptions();
        buildOptions.scenes = scenesList.ToArray();
        buildOptions.locationPathName = apkPath;
        buildOptions.target = BuildTarget.Android;
        buildOptions.options = BuildOptions.None;

        Debug.Log($"[Builder] Bắt đầu gọi BuildPipeline.BuildPlayer -> {apkPath}");
        BuildReport report = BuildPipeline.BuildPlayer(buildOptions);
        BuildSummary summary = report.summary;

        if (summary.result == BuildResult.Succeeded)
        {
            Debug.Log($"[Builder] THÀNH CÔNG RỰC RỠ! Kích thước APK: {summary.totalSize / (1024 * 1024)} MB. Thời gian: {summary.totalTime.TotalSeconds:F1}s");
            EditorApplication.Exit(0);
        }
        else
        {
            Debug.LogError($"[Builder] THẤT BẠI! Lỗi: {summary.totalErrors}, Cảnh báo: {summary.totalWarnings}");
            EditorApplication.Exit(1);
        }
    }
}
