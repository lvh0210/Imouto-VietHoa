using Naninovel;
using UnityEngine;

namespace CustomNaninovelCommand
{
	[CommandAlias("novel")]
	public class SwitchToNovelMode : Command
	{
		public StringParameter ScriptName;

		public StringParameter Label;

		public override async UniTask ExecuteAsync(AsyncToken asyncToken = default(AsyncToken))
		{
			SceneMaster.SetupURPCameraStack();

			try
			{
				var blackObj = GameObject.Find("black");
				if (blackObj != null)
				{
					var cg = blackObj.GetComponent<CanvasGroup>();
					if (cg != null) { cg.alpha = 0f; cg.blocksRaycasts = false; }
					blackObj.SetActive(false);
				}
			}
			catch { }

			var uiGo = GameObject.Find("[UI]");
			if (uiGo != null)
			{
				CanvasGroup component = uiGo.GetComponent<CanvasGroup>();
				if (component != null)
				{
					component.blocksRaycasts = false;
				}
			}

			if (Command.Assigned(ScriptName))
			{
				await Engine.GetService<IScriptPlayer>().PreloadAndPlayAsync(ScriptName, 0, 0, Label);
			}

			SceneMaster.SetupURPCameraStack();
			Engine.GetService<IInputManager>().ProcessInput = true;

			var uiGo2 = GameObject.Find("UI");
			if (uiGo2 != null)
			{
				CanvasGroup component2 = uiGo2.GetComponent<CanvasGroup>();
				if (component2 != null)
				{
					component2.blocksRaycasts = true;
				}
			}
		}
	}
}
