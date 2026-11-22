using DG.Tweening;
using Naninovel;
using UnityEngine;

namespace CustomNaninovelCommand
{
	public class FadeIn : Command
	{
		[ParameterAlias("")]
		[RequiredParameter]
		public DecimalParameter fadeTime;

		public BooleanParameter changeEase;

		public override async UniTask ExecuteAsync(AsyncToken asyncToken = default(AsyncToken))
		{
			SceneMaster.SetupURPCameraStack();

			Ease ease = Ease.Unset;
			bool flag = Command.Assigned(changeEase) && (bool)(bool?)changeEase;
			if (((float)(float?)fadeTime >= 3f) | flag)
			{
				ease = Ease.InOutSine;
			}
			float duration = fadeTime.Value;
			if (StaticManagers.CurrentSceneManager != null)
			{
				try
				{
					var seq = StaticManagers.CurrentSceneManager.FadeIn(duration, ease);
					if (seq != null)
					{
						await seq.AsyncWaitForCompletion();
					}
				}
				catch (System.Exception ex)
				{
					Debug.LogWarning("[FadeIn] Warning: " + ex.Message);
				}
			}
			SceneMaster.SetupURPCameraStack();
		}
	}
}
