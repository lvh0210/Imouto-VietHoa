using System;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.Localization.Settings;

public class TMProLocalize : MonoBehaviour
{
	public enum TableName
	{
		PublicLocalization = 0,
		TitleLocalization = 1,
		MainLocalization = 2,
		ShopLocalization = 3,
		InteractionLocalization = 4,
		SexSceneLocalization = 5,
		GalleryLocalization = 6,
		StatusLocalization = 7,
		HSelectLocalization = 8,
		BonusLocalization = 9
	}

	public bool startInitialize = true;

	public TableName tableName = TableName.TitleLocalization;

	public string key;

	public bool applyFontSize = true;

	public bool applyCharSpacing = true;

	public bool applyLineSpacing = true;

	private bool initialized;

	private TextMeshProUGUI textComponent;

	private TMProLocalization localizationObject;

	public string Key
	{
		set
		{
			key = value;
		}
	}

	private void Awake()
	{
		Initialize();
	}

	private void Start()
	{
		if (startInitialize)
		{
			UpdateText().Forget();
		}
	}

	private void Initialize()
	{
		textComponent = GetComponent<TextMeshProUGUI>();
		initialized = true;
	}

	public TextMeshProUGUI GetTextComponent()
	{
		return textComponent;
	}

	public async UniTask UpdateText()
	{
		try
		{
			if (!initialized)
			{
				Initialize();
			}
			string _tableName = tableName.ToString();
			try
			{
				if (LocalizationSettings.SelectedLocale == null)
				{
					LocalizationSettings.SelectedLocale = UnityEngine.Localization.Locale.CreateLocale("ja");
				}
				if (!LocalizationSettings.InitializationOperation.IsDone)
				{
					await LocalizationSettings.InitializationOperation.Task;
				}
				localizationObject = LocalizationSettings.AssetDatabase.GetLocalizedAsset<TMProLocalization>(_tableName, key);
			}
			catch (Exception ex)
			{
				Debug.LogWarning("[TMProLocalize] Table query exception: " + ex.Message);
			}

			if (localizationObject != null)
			{
				if (textComponent != null)
				{
					string text = localizationObject.text;
					if (text.Contains("\\n"))
					{
						text = text.Replace("\\n", Environment.NewLine);
					}
					textComponent.text = text;
					if (applyFontSize)
					{
						textComponent.fontSize = localizationObject.fontsize;
					}
					if (applyCharSpacing)
					{
						textComponent.characterSpacing = localizationObject.characterSpacing;
					}
					if (applyLineSpacing)
					{
						textComponent.lineSpacing = localizationObject.lineSpacing;
					}
				}
			}
			else
			{
				Debug.LogWarning("[TMProLocalize] Table " + tableName.ToString() + " Key " + key + " not found, keeping default text.");
			}
		}
		catch (Exception ex)
		{
			Debug.LogWarning("[TMProLocalize] UpdateText exception caught safely: " + ex.Message);
		}
	}
}
