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
		if (black != null)
		{
			black.gameObject.SetActive(true);
		}
		// Failsafe: After 2.0 seconds, force the black overlay off so screen is NEVER stuck black
		Invoke(nameof(ForceDismissBlackScreen), 2.0f);
	}

	protected void ForceDismissBlackScreen()
	{
		if (black != null)
		{
			black.alpha = 0f;
			black.blocksRaycasts = false;
			black.gameObject.SetActive(false);
		}
	}

	protected virtual async Naninovel.UniTask Start()
	{
		SaveManager.SaveSystemDataIfNeeded();
		try
		{
			if (!Engine.Initialized)
			{
				await Cysharp.Threading.Tasks.UniTask.WaitUntil(() => Engine.GetService<ICameraManager>() != null && Engine.GetService<ICameraManager>().Camera != null).Timeout(TimeSpan.FromSeconds(3));
				Camera naniCamera = Engine.GetService<ICameraManager>()?.Camera;
				if (naniCamera != null)
				{
					await Cysharp.Threading.Tasks.UniTask.WaitUntil(() => !naniCamera.enabled).Timeout(TimeSpan.FromSeconds(2));
				}
			}
			else
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
				await Naninovel.UniTask.WhenAll(OnNaninovelInitializeProccess());
			}
			catch { }
		}
		await Naninovel.UniTask.Delay(100);
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
