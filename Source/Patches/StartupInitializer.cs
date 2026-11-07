using System;
using System.Threading.Tasks;
using CustomNaninovelCommand;
using Naninovel;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.Localization;
using UnityEngine.Localization.Settings;
using UnityEngine.SceneManagement;

public class StartupInitializer : MonoBehaviour
{
	public Camera mainCamera;
	private bool titleLoaded = false;

	private void Start()
	{
		// Fallback safety guard: If initialization hangs or takes longer than 2.5 seconds, force load Title scene!
		Invoke(nameof(ForceLoadTitle), 2.5f);
		Initialize();
	}

	private void ForceLoadTitle()
	{
		if (!titleLoaded)
		{
			titleLoaded = true;
			Debug.LogWarning("[StartupInitializer] Timeout fallback triggered! Force loading Title scene.");
			try
			{
				if (mainCamera != null)
				{
					mainCamera.enabled = true;
					mainCamera.clearFlags = CameraClearFlags.SolidColor;
					mainCamera.backgroundColor = new Color(0.19215687f, 0.3019608f, 0.4745098f, 1.0f);
					mainCamera.allowHDR = false;
					mainCamera.allowMSAA = false;
				}
				SceneMaster.DismissLoadingUI();
			}
			catch { }
			SceneManager.LoadScene("Title");
		}
	}

	private async void Initialize()
	{
		try
		{
			SaveManager.LoadSystemData();
		}
		catch (Exception ex)
		{
			Debug.LogWarning("[StartupInitializer] SaveManager.LoadSystemData warning: " + ex.Message);
		}

		string currentLanguage = "ja";
		try
		{
			if (!string.IsNullOrEmpty(PlayerData.Settings.language))
			{
				currentLanguage = PlayerData.Settings.language;
			}
		}
		catch { }

#if !UNITY_ANDROID
		try
		{
			Debug.Log("[StartupInitializer] Initializing Addressables...");
			await Addressables.InitializeAsync().Task;
			Debug.Log("[StartupInitializer] Addressables initialized successfully.");
		}
		catch (Exception ex)
		{
			Debug.LogWarning("[StartupInitializer] Addressables.InitializeAsync warning: " + ex.Message);
		}
#endif

		try
		{
			Debug.Log("[StartupInitializer] Setting locale: " + currentLanguage);
			var targetLocale = Locale.CreateLocale(currentLanguage);
			LocalizationSettings.SelectedLocale = targetLocale;
			if (!LocalizationSettings.InitializationOperation.IsDone)
			{
				await LocalizationSettings.InitializationOperation.Task;
			}
			if (LocalizationSettings.SelectedLocale == null)
			{
				LocalizationSettings.SelectedLocale = targetLocale;
			}
		}
		catch (Exception ex)
		{
			Debug.LogWarning("[StartupInitializer] Localization warning: " + ex.Message);
		}

		try
		{
			Debug.Log("[StartupInitializer] Initializing Naninovel Runtime...");
			await RuntimeInitializer.InitializeAsync();
			Debug.Log("[StartupInitializer] Naninovel Runtime initialized.");
		}
		catch (Exception ex)
		{
			Debug.LogWarning("[StartupInitializer] Naninovel RuntimeInitializer warning: " + ex.Message);
		}

		try
		{
			var locManager = Engine.GetService<ILocalizationManager>();
			if (locManager != null)
			{
				await locManager.SelectLocaleAsync(currentLanguage);
			}
		}
		catch (Exception ex)
		{
			Debug.LogWarning("[StartupInitializer] SelectLocaleAsync warning: " + ex.Message);
		}

		try
		{
			await new SwitchToPlayMode
			{
				ResetState = false
			}.ExecuteAsync();
		}
		catch (Exception ex)
		{
			Debug.LogWarning("[StartupInitializer] SwitchToPlayMode warning: " + ex.Message);
		}

		try
		{
			if (mainCamera != null)
			{
				mainCamera.enabled = true;
				mainCamera.clearFlags = CameraClearFlags.SolidColor;
				mainCamera.backgroundColor = new Color(0.19215687f, 0.3019608f, 0.4745098f, 1.0f);
				mainCamera.allowHDR = false;
				mainCamera.allowMSAA = false;
			}
			var cam = Engine.GetService<ICameraManager>();
			if (cam != null)
			{
				if (cam.Camera != null) cam.Camera.enabled = false;
				if (cam.UICamera != null) cam.UICamera.enabled = false;
			}
			var printer = Engine.GetService<ITextPrinterManager>();
			if (printer != null) printer.BaseRevealSpeed = PlayerData.Settings.revealSpeed;
			Application.runInBackground = PlayerData.Settings.runInBackground;
			AudioManager.SetBGMVolume(PlayerData.Settings.bgmVolume);
			AudioManager.SetSEVolume(PlayerData.Settings.seVolume);
		}
		catch (Exception ex)
		{
			Debug.LogWarning("[StartupInitializer] Post-init settings warning: " + ex.Message);
		}

		if (!titleLoaded)
		{
			titleLoaded = true;
			CancelInvoke(nameof(ForceLoadTitle));
			Debug.Log("[StartupInitializer] Transitioning to Title scene!");
			try
			{
				SceneMaster.DismissLoadingUI();
			}
			catch { }
			SceneManager.LoadScene("Title");
		}
	}
}
