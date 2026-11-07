using DG.Tweening;
using Naninovel;
using UnityEngine;

namespace Title
{
	public class SceneManager : SceneMaster
	{
		protected override async UniTask Start()
		{
			ForceEnsureTitleVisible();

			// Make sure main Camera is active and high depth
			var mainCam = Camera.main;
			if (mainCam != null)
			{
				mainCam.enabled = true;
				mainCam.depth = 10;
			}

			// Force disable Naninovel background camera so it doesn't occlude Title
			try
			{
				if (Engine.Initialized)
				{
					var camMgr = Engine.GetService<ICameraManager>();
					if (camMgr != null && camMgr.Camera != null)
					{
						camMgr.Camera.enabled = false;
					}
				}
			}
			catch { }

			try
			{
				await base.Start();
			}
			catch (System.Exception ex)
			{
				Debug.LogWarning("[Title.SceneManager] base.Start warning: " + ex.Message);
			}

			try
			{
				RegisterEvent();
			}
			catch { }

			ForceEnsureTitleVisible();
			Invoke(nameof(ForceEnsureTitleVisible), 0.5f);
			Invoke(nameof(ForceEnsureTitleVisible), 1.0f);

			await UniTask.Delay(100);
			Sequence sequence = DOTween.Sequence();
			sequence.Append(FadeIn(0.5f));
			sequence.OnComplete(() =>
			{
				SousaKinshi(kinshi: false);
				ForceEnsureTitleVisible();
			});
			AudioManager.PlayBGM.Title();
		}

		private void Update()
		{
			ForceEnsureTitleVisible();
		}

		private void ForceEnsureTitleVisible()
		{
			ForceDismissBlackScreen();
			DismissLoadingUI();

			var mainCam = Camera.main;
			if (mainCam != null)
			{
				mainCam.enabled = true;
				mainCam.clearFlags = CameraClearFlags.SolidColor;
				mainCam.backgroundColor = new Color(0.19215687f, 0.3019608f, 0.4745098f, 1.0f);
				mainCam.allowHDR = false;
				mainCam.allowMSAA = false;
				mainCam.depth = 10;

				var addData = mainCam.GetComponent<UnityEngine.Rendering.Universal.UniversalAdditionalCameraData>();
				if (addData != null)
				{
					if (addData.cameraStack != null && addData.cameraStack.Count > 0)
					{
						addData.cameraStack.Clear();
					}
					addData.renderPostProcessing = false;
					addData.dithering = false;
				}
			}

			try
			{
				if (Engine.Initialized)
				{
					var camMgr = Engine.GetService<ICameraManager>();
					if (camMgr != null)
					{
						if (camMgr.Camera != null) camMgr.Camera.enabled = false;
						if (camMgr.UICamera != null) camMgr.UICamera.enabled = false;
					}
					var uiManager = Engine.GetService<IUIManager>();
					if (uiManager != null)
					{
						var loadingUI = uiManager.GetUI("LoadingUI");
						if (loadingUI != null)
						{
							loadingUI.Hide();
							loadingUI.Visible = false;
							var mb = loadingUI as MonoBehaviour;
							if (mb != null && mb.gameObject != null)
							{
								mb.gameObject.SetActive(false);
							}
						}
					}
				}
			}
			catch { }
		}

		private void RegisterEvent()
		{
			Managers.Instance.eventHandler.OnClickNewgameButton += StartNewGame;
		}

		private void StartNewGame()
		{
			float delay = 1.5f;
			float fadeTime = 0.5f;
			float interval = 0.4f;
			Sequence sequence = DOTween.Sequence();
			sequence.OnStart(() =>
			{
				if (black != null) black.blocksRaycasts = true;
				PlayerData.InitializePlayerData(endlessMode: false);
				string sceneName_NewGame = GetSceneName_NewGame();
				StartScenePreloading(sceneName_NewGame);
			});
			sequence.SetDelay(delay);
			sequence.Append(FadeOut(fadeTime));
			sequence.Join(AudioManager.FadeOut(fadeTime));
			sequence.AppendInterval(interval);
			sequence.OnComplete(() =>
			{
				TransitionToScene();
			});
		}

		private string GetSceneName_NewGame()
		{
			if (PlayerData.System.clear)
			{
				return "Bonus";
			}
			return "Prologue";
		}

		public void StartEndlessMode()
		{
			float delay = 1.5f;
			float fadeTime = 0.5f;
			float interval = 0.4f;
			Sequence sequence = DOTween.Sequence();
			sequence.OnStart(() =>
			{
				if (black != null) black.blocksRaycasts = true;
				StartScenePreloading("Main");
			});
			sequence.SetDelay(delay);
			sequence.Append(FadeOut(fadeTime));
			sequence.Join(AudioManager.FadeOut(fadeTime));
			sequence.AppendInterval(interval);
			sequence.OnComplete(() =>
			{
				PlayerData.InitializePlayerData(endlessMode: true);
				TransitionToScene();
			});
		}

		public void QuitGame()
		{
			float fadeTime = 0.5f;
			Sequence sequence = DOTween.Sequence();
			sequence.OnStart(() =>
			{
				if (black != null) black.blocksRaycasts = true;
			});
			sequence.Append(FadeOut(fadeTime));
			sequence.Join(AudioManager.FadeOut(fadeTime));
			sequence.OnComplete(() =>
			{
				Application.Quit();
			});
		}
	}
}
