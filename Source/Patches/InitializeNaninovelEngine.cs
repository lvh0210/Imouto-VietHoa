using CustomNaninovelCommand;
using Naninovel;
using UnityEngine;
using UnityEngine.Rendering.Universal;

public class InitializeNaninovelEngine : MonoBehaviour
{
	public Camera mainCamera;

	private async void Start()
	{
		try
		{
			if (mainCamera == null)
			{
				mainCamera = GetComponent<Camera>();
				if (mainCamera == null) mainCamera = Camera.main;
			}
			if (mainCamera != null)
			{
				mainCamera.enabled = true;
				mainCamera.depth = 10;
				mainCamera.rect = new Rect(0f, 0f, 1f, 1f);
				mainCamera.clearFlags = CameraClearFlags.SolidColor;
				mainCamera.backgroundColor = new Color(0.19215687f, 0.3019608f, 0.4745098f, 1.0f);
			}

			if (!Engine.Initialized)
			{
				await RuntimeInitializer.InitializeAsync();
				await new SwitchToPlayMode
				{
					ResetState = false
				}.ExecuteAsync();
			}

			if (Engine.Initialized)
			{
				var camMgr = Engine.GetService<ICameraManager>();
				if (camMgr != null)
				{
					if (camMgr.Camera != null)
					{
						camMgr.Camera.enabled = false;
					}

					bool isTitle = UnityEngine.SceneManagement.SceneManager.GetActiveScene().name == "Title";
					Camera uICamera = camMgr.UICamera;
					if (uICamera != null)
					{
						if (isTitle)
						{
							uICamera.enabled = false;
						}
						else if (mainCamera != null)
						{
							var additionalData = mainCamera.GetComponent<UniversalAdditionalCameraData>();
							if (additionalData != null && !additionalData.cameraStack.Contains(uICamera))
							{
								additionalData.cameraStack.Add(uICamera);
							}
						}
					}
				}
			}
		}
		catch (System.Exception ex)
		{
			Debug.LogWarning("[InitializeNaninovelEngine] Exception caught: " + ex.Message);
		}
	}
}
