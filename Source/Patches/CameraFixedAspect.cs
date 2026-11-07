using UnityEngine;

public class CameraFixedAspect : MonoBehaviour
{
	[SerializeField]
	private Vector2 aspect = new Vector2(16f, 9f);

	private Camera cam;

	private int prevWidth;

	private int prevHeight;

	private void Awake()
	{
		cam = GetComponent<Camera>();
		prevWidth = Screen.width;
		prevHeight = Screen.height;
		SetAspectRatio();
	}

	private void Update()
	{
		if (Screen.width != prevWidth || Screen.height != prevHeight)
		{
			prevWidth = Screen.width;
			prevHeight = Screen.height;
			SetAspectRatio();
		}
	}

	private void SetAspectRatio()
	{
		if (cam == null) cam = GetComponent<Camera>();
		if (cam != null)
		{
			cam.rect = new Rect(0f, 0f, 1f, 1f);
			cam.clearFlags = CameraClearFlags.SolidColor;
			cam.backgroundColor = new Color(0.19215687f, 0.3019608f, 0.4745098f, 1.0f);
			cam.allowHDR = false;
			cam.allowMSAA = false;
		}
	}
}
