using CustomNaninovelCommand;
using Naninovel;
using UnityEngine;

namespace Prologue
{
	public class SceneManager : DynamicBackGroundScene
	{
		private const string sceneName_Main = "Main";

		private const string naninovelScriptName = "Prologue";

		private const string naninovelScriptLabel = "GameStart";

		protected override async UniTask Start()
		{
			await base.Start();
			if (black != null)
			{
				black.alpha = 0f;
				black.blocksRaycasts = false;
				black.gameObject.SetActive(false);
			}
			Managers.Instance.uIManager.StartPrologueDialogue();
		}

		public void StartPrologue()
		{
			SetupBackgroundCanvas();
			SceneMaster.SetupURPCameraStack();
			if (black != null)
			{
				black.alpha = 0f;
				black.blocksRaycasts = false;
				black.gameObject.SetActive(false);
			}
			new SwitchToNovelMode
			{
				ScriptName = "Prologue",
				Label = "GameStart"
			}.ExecuteAsync().Forget();
		}

		public void PreloadingMainScene()
		{
			StartScenePreloading("Main");
		}

		public async void StartMainScene()
		{
			await UniTask.Delay(400);
			TransitionToScene();
		}
	}
}
