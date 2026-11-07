using System;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Naninovel;
using UnityEngine;
using UnityEngine.SceneManagement;

public abstract class SceneMaster : MonoBehaviour
{
	public CanvasGroup black;

	private AsyncOperation async;

	public event Func<Naninovel.UniTask> OnNaninovelInitializeProccess;

	public event Action OnSceneInitialized;

	protected virtual void Awake()
	{
		StaticManagers.CurrentSceneManager = this;
		DismissLoadingUI();
		ForceDismissBlackScreen();
		Invoke(nameof(ForceDismissBlackScreen), 0.5f);
		Invoke(nameof(ForceDismissBlackScreen), 1.5f);
	}

	public static void DismissLoadingUI()
	{
		try
		{
			var canvases = UnityEngine.Object.FindObjectsOfType<Canvas>(true);
			if (canvases != null)
			{
				for (int i = 0; i < canvases.Length; i++)
				{
					var c = canvases[i];
					if (c != null && c.name.IndexOf("Loading", StringComparison.OrdinalIgnoreCase) >= 0)
					{
						c.enabled = false;
						c.sortingOrder = -100;
						c.gameObject.SetActive(false);
					}
				}
			}

			var canvasGroups = UnityEngine.Object.FindObjectsOfType<CanvasGroup>(true);
			if (canvasGroups != null)
			{
				for (int i = 0; i < canvasGroups.Length; i++)
				{
					var cg = canvasGroups[i];
					if (cg != null && (cg.name.IndexOf("Loading", StringComparison.OrdinalIgnoreCase) >= 0 ||
						(cg.transform.root != null && cg.transform.root.name.IndexOf("Loading", StringComparison.OrdinalIgnoreCase) >= 0)))
					{
						cg.alpha = 0f;
						cg.blocksRaycasts = false;
						cg.interactable = false;
						cg.gameObject.SetActive(false);
					}
				}
			}

			int sc = UnityEngine.SceneManagement.SceneManager.sceneCount;
			for (int i = 0; i < sc; i++)
			{
				var scene = UnityEngine.SceneManagement.SceneManager.GetSceneAt(i);
				if (scene.isLoaded)
				{
					var roots = scene.GetRootGameObjects();
					for (int r = 0; r < roots.Length; r++)
					{
						var root = roots[r];
						if (root != null && root.name.IndexOf("Loading", StringComparison.OrdinalIgnoreCase) >= 0)
						{
							root.SetActive(false);
							UnityEngine.Object.Destroy(root);
						}
					}
				}
			}

			if (Engine.Initialized)
			{
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
							UnityEngine.Object.Destroy(mb.gameObject);
						}
					}
				}
			}
		}
		catch { }
	}

	protected void ForceDismissBlackScreen()
	{
		if (black != null)
		{
			black.alpha = 0f;
			black.blocksRaycasts = false;
			black.gameObject.SetActive(false);
		}
		try
		{
			var canvasGroups = UnityEngine.Object.FindObjectsOfType<CanvasGroup>(true);
			if (canvasGroups != null)
			{
				for (int i = 0; i < canvasGroups.Length; i++)
				{
					var cg = canvasGroups[i];
					if (cg != null && (cg.name == "black" || cg.name == "FadeCanvas" || cg.name == "halfBlack"))
					{
						cg.alpha = 0f;
						cg.blocksRaycasts = false;
					}
				}
			}
		}
		catch { }
		DismissLoadingUI();
		try
		{
			var allCanvases = UnityEngine.Object.FindObjectsOfType<Canvas>(true);
			if (allCanvases != null)
			{
				for (int i = 0; i < allCanvases.Length; i++)
				{
					var c = allCanvases[i];
					if (c != null && c.renderMode != RenderMode.ScreenSpaceOverlay)
					{
						c.renderMode = RenderMode.ScreenSpaceOverlay;
					}
				}
			}
		}
		catch { }
	}

	protected virtual async Naninovel.UniTask Start()
	{
		DismissLoadingUI();
		ForceDismissBlackScreen();
		SaveManager.SaveSystemDataIfNeeded();
		try
		{
			var mainCam = Camera.main;
			if (mainCam != null)
			{
				mainCam.clearFlags = CameraClearFlags.SolidColor;
				mainCam.backgroundColor = new Color(0.19215687f, 0.3019608f, 0.4745098f, 1.0f);
				mainCam.rect = new Rect(0f, 0f, 1f, 1f);
				mainCam.allowHDR = false;
				mainCam.allowMSAA = false;
			}
		}
		catch { }
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

		if (OnNaninovelInitializeProccess != null)
		{
			try
			{
				await Naninovel.UniTask.WhenAll(OnNaninovelInitializeProccess()).Timeout(TimeSpan.FromSeconds(1));
			}
			catch { }
		}
		await Naninovel.UniTask.Delay(50);
		DismissLoadingUI();
		ForceDismissBlackScreen();
		OnSceneInitialized?.Invoke();
	}

	public void SousaKinshi(bool kinshi)
	{
		if (black != null)
		{
			black.blocksRaycasts = kinshi;
		}
	}

	public Sequence FadeIn(float fadeTime, Ease ease = Ease.Unset)
	{
		Sequence sequence = DOTween.Sequence();
		sequence.OnStart(() =>
		{
			ForceDismissBlackScreen();
		});
		if (black != null)
		{
			sequence.Append(black.DOFade(0f, fadeTime).SetEase(ease));
		}
		sequence.OnComplete(() =>
		{
			ForceDismissBlackScreen();
		});
		return sequence;
	}

	public Sequence FadeOut(float fadeTime, Ease ease = Ease.Unset)
	{
		Sequence sequence = DOTween.Sequence();
		sequence.OnStart(() =>
		{
			if (black != null)
			{
				black.gameObject.SetActive(true);
				black.blocksRaycasts = true;
			}
		});
		if (black != null)
		{
			sequence.Append(black.DOFade(1f, fadeTime).SetEase(ease));
		}
		sequence.OnComplete(() =>
		{
		});
		return sequence;
	}

	public void MoveToNextTime(float fadeTime)
	{
		PlayerData.Status.time++;
		string sceneName = CheckNextScene();
		StartScenePreloading(sceneName);
		TransitionNextScene(fadeTime);
	}

	public void MoveToSpecifiedTime(int targetTime, float fadeTime)
	{
		PlayerData.Status.time = targetTime;
		string sceneName = CheckNextScene();
		StartScenePreloading(sceneName);
		TransitionNextScene(fadeTime);
	}

	public void MoveToSpecifiedScene(string sceneName, int targetTime, float fadeTime, float interval = 0.9f)
	{
		PlayerData.Status.time = targetTime;
		StartScenePreloading(sceneName);
		TransitionNextScene(fadeTime, interval);
	}

	public void TransitionToTitle(float fadeTime)
	{
		Sequence sequence = DOTween.Sequence();
		sequence.OnStart(() =>
		{
			SousaKinshi(kinshi: true);
			StartScenePreloading("Title");
		});
		sequence.Append(FadeOut(fadeTime));
		sequence.Join(AudioManager.FadeOutBGM(fadeTime));
		sequence.OnComplete(() =>
		{
			TransitionToScene();
		});
	}

	public void TransitionToGallery(float fadeTime, float initDelay = 0f, float latestDelay = 0f)
	{
		Sequence sequence = DOTween.Sequence();
		sequence.OnStart(() =>
		{
			SousaKinshi(kinshi: true);
			StartScenePreloading("Gallery");
		});
		sequence.SetDelay(initDelay);
		sequence.Append(FadeOut(fadeTime));
		sequence.Join(AudioManager.FadeOut(fadeTime));
		sequence.AppendInterval(latestDelay);
		sequence.OnComplete(() =>
		{
			TransitionToScene();
		});
	}

	public void LoadScene(string targetSceneName)
	{
		float fadeTime = 0.5f;
		float interval = 0.4f;
		Sequence sequence = DOTween.Sequence();
		sequence.OnStart(() =>
		{
			if (black != null) black.blocksRaycasts = true;
			StartScenePreloading(targetSceneName);
		});
		sequence.Append(FadeOut(fadeTime));
		sequence.Join(AudioManager.FadeOutBGM(fadeTime));
		sequence.AppendInterval(interval);
		sequence.OnComplete(() =>
		{
			TransitionToScene();
		});
	}

	private string CheckNextScene()
	{
		if (StoryEventManager.CheckEventStoryOccur())
		{
			return "StoryEvent";
		}
		return "Main";
	}

	private void TransitionNextScene(float fadeTime, float interval = 0.9f)
	{
		Sequence sequence = DOTween.Sequence();
		sequence.OnStart(() =>
		{
			if (black != null) black.blocksRaycasts = true;
		});
		sequence.Append(FadeOut(fadeTime));
		sequence.AppendInterval(interval);
		sequence.OnComplete(() =>
		{
			TransitionToScene();
		});
	}

	protected void StartScenePreloading(string sceneName)
	{
		async = SceneManager.LoadSceneAsync(sceneName);
		async.allowSceneActivation = false;
	}

	protected void TransitionToScene()
	{
		async.allowSceneActivation = true;
		ProgressBarSingleton.Instance.ViewLoading(async);
	}
}
