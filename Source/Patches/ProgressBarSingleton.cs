using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

public class ProgressBarSingleton : MonoBehaviour
{
	private static ProgressBarSingleton instance;

	public Canvas progressCanvas;

	public Slider progressSlider;

	[Tooltip("シーン遷移演出の完了後、どれだけの時間が経過した際にProgressBarを表示するか。")]
	public float delayTime;

	public static ProgressBarSingleton Instance => instance;

	private void Awake()
	{
		if (instance == null)
		{
			instance = this;
		}
	}

	private void OnDestroy()
	{
		if (instance == this)
		{
			instance = null;
		}
	}

	public async void ViewLoading(AsyncOperation async)
	{
		try
		{
			await UniTask.Delay((int)(delayTime * 1000f));
			if (this == null || progressCanvas == null || progressSlider == null || async == null) return;
			progressCanvas.enabled = true;
			progressSlider.value = 0f;
			while (async != null && !async.isDone)
			{
				if (this == null || progressCanvas == null || progressSlider == null) return;
				float value = Mathf.Clamp01(async.progress / 0.9f);
				progressSlider.value = value;
				await UniTask.Yield();
			}
			if (progressCanvas != null)
			{
				progressCanvas.enabled = false;
			}
		}
		catch (System.Exception ex)
		{
			Debug.LogWarning("[ProgressBarSingleton] Safe caught exception in ViewLoading: " + ex.Message);
		}
	}
}
