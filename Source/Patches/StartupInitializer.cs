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
		// Fallback safety guard: If initialization hangs or takes longer than 8 seconds, force load Title scene!
		Invoke(nameof(ForceLoadTitle), 8.0f);
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
				if (mainCamera != null) mainCamera.enabled = true;
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

		try
		{
			Debug.Log("[StartupInitializer] Setting locale: " + currentLanguage);
			LocalizationSettings.SelectedLocale = Locale.CreateLocale(currentLanguage);
			await LocalizationSettings.InitializationOperation.Task;
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
			if (mainCamera != null) mainCamera.enabled = true;
			var cam = Engine.GetService<ICameraManager>();
			if (cam != null && cam.Camera != null) cam.Camera.enabled = false;
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
			SceneManager.LoadScene("Title");
		}
	}
}
