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

					Camera uICamera = camMgr.UICamera;
					if (uICamera != null && mainCamera != null)
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
		catch (System.Exception ex)
		{
			Debug.LogWarning("[InitializeNaninovelEngine] Exception caught: " + ex.Message);
		}
	}
}
