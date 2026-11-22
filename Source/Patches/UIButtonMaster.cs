using DG.Tweening;
using UnityEngine;
using UnityEngine.EventSystems;

public abstract class UIButtonMaster : MonoBehaviour, IPointerEnterHandler, IEventSystemHandler, IPointerExitHandler, IPointerDownHandler, IPointerUpHandler
{
	[Tooltip("クリック時にスケールを変更するボタンアニメが実行されるようになります。")]
	public bool enableButtonAnimation = true;

	private bool isPointerInside;

	private bool isPointerDown;

	private bool actionFlag;

	public void OnPointerEnter(PointerEventData eventData)
	{
		isPointerInside = true;
		if (!isPointerDown)
		{
			MouseEnter();
		}
	}

	public void OnPointerExit(PointerEventData eventData)
	{
		isPointerInside = false;
		actionFlag = false;
		MouseExit();
		if (enableButtonAnimation)
		{
			base.transform.DOScale(Vector3.one, 0.1f);
		}
	}

	public void OnPointerDown(PointerEventData eventData)
	{
		isPointerInside = true;
		isPointerDown = true;
		actionFlag = true;
		MouseDown();
		if (enableButtonAnimation)
		{
			base.transform.DOScale(Vector3.one * 0.95f, 0.1f);
		}
	}

	public void OnPointerUp(PointerEventData eventData)
	{
		if (actionFlag || isPointerInside)
		{
			MouseClick();
			if (enableButtonAnimation)
			{
				base.transform.DOScale(Vector3.one, 0.1f);
			}
		}
		isPointerDown = false;
		actionFlag = false;
		isPointerInside = false;
	}

	protected abstract void MouseEnter();

	protected abstract void MouseExit();

	protected abstract void MouseDown();

	protected abstract void MouseClick();
}
