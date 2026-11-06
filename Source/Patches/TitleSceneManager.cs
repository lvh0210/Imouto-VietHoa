using DG.Tweening;
using Naninovel;
using UnityEngine;

namespace Title
{
	public class SceneManager : SceneMaster
	{
		protected override async UniTask Start()
		{
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

			// Safety fallback: guarantee Title screen is visible within 1.0 second
			Invoke(nameof(ForceEnsureTitleVisible), 1.0f);

			await UniTask.Delay(500);
			Sequence sequence = DOTween.Sequence();
			sequence.Append(FadeIn(1f));
			sequence.OnComplete(() =>
			{
				SousaKinshi(kinshi: false);
				ForceEnsureTitleVisible();
			});
			AudioManager.PlayBGM.Title();
		}

		private void ForceEnsureTitleVisible()
		{
			ForceDismissBlackScreen();
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
