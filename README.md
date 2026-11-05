# Dự Án Bản Địa Hóa Tiếng Việt: 妹と過ごす1ヵ月間_Re (One Month with My Sister _Re)

<p align="center">
  <img src="Data/icon.png" width="128" height="128" alt="Logo Game">
  <br>
  <b>Bản dịch tiếng Việt hoàn thiện 100% dành cho cả PC (Windows) và Android (Standalone APK)</b>
</p>

---

## 📖 1. Giới Thiệu Dự Án

* **Tên gốc:** 妹と過ごす1ヵ月間_Re (One Month with My Sister _Re)
* **Nhà phát triển:** やくも牛乳 (Yakumo Milk)
* **Game Engine:** Unity 2022.3.62f2 (Mono x64) + Naninovel Visual Novel Engine + BehaviorDesigner + Unity.Localization + TextMeshPro.
* **Mục tiêu:** Bản địa hóa trọn vẹn 100% cốt truyện, hội thoại, giao diện, bong bóng thoại tương tác và phân cảnh đặc biệt sang tiếng Việt với văn phong mượt mà, tự nhiên và hiển thị chuẩn xác không lỗi dấu.

---

## 🛠️ 2. Kiến Trúc Kỹ Thuật Bản Địa Hóa

Dự án áp dụng giải pháp can thiệp nhị phân chuyên sâu kết hợp hook động tại thời gian chạy (runtime):

```
+---------------------------------------------------------------------------------------+
|                              KIẾN TRÚC BẢN ĐỊA HÓA                                   |
+---------------------------------------------------------------------------------------+
|  [Thoại cốt truyện Naninovel]     --> resources.assets (17 kịch bản, 4.516 câu thoại) |
|  [Font hiển thị tiếng Việt]      --> RiiPopkaku_VI (M PLUS Rounded 1c, 8.546 glyphs) |
|  [Giao diện Addressables UI]      --> localization-assets-english & japanese bundles  |
|  [Fix Fallback Font TextMeshPro]  --> Zero-Byte Shift trong sharedassets0.assets      |
|  [Bong bóng thoại & Dynamic Text] --> Runtime Hook: ImoutoVi.dll (IL Hook set_text)   |
|  [Master Dictionary]              --> translation_extra.json (2.806 mục dịch)         |
|  [Đóng gói Android]               --> Standalone APK Wrapper (Tích hợp Box64 + Wine)  |
+---------------------------------------------------------------------------------------+
```

### Điểm nhấn kỹ thuật:
1. **Triệt tiêu hoàn toàn lỗi rụng dấu & ô vuông `□`:**
   - Thay thế font nhúng trong `customprinter.bundle` bằng **`RiiPopkaku_VI`**, hỗ trợ đầy đủ 100% dải ký tự tiếng Việt có dấu.
   - Dịch chuyển mã Unicode tại chỗ (Zero-Byte Shift) cho 93 ký tự Latin-1 rỗng và 18 ký tự bị bẫy mã ô vuông trong `sharedassets0.assets` mà không làm lệch độ dài file nhị phân.
2. **Hook động IL qua `ImoutoVi.dll`:**
   - Tiêm trực tiếp 3 lệnh bytecode IL vào hàm `TMP_Text.set_text` trong `Unity.TextMeshPro.dll`.
   - Tự động tra cứu từ điển `translation_extra.json` và áp dụng Regex chuyển đổi động (tiền tệ, ngày tháng, lượt chơi, slot lưu game tiếng Nhật) ngay khi hiển thị lên màn hình.
3. **Bộ tiện ích mở rộng tích hợp:**
   - Hồi phục tự động thể lực HP, dung lượng túi đồ tối đa và tiền tệ vô hạn để trải nghiệm trọn vẹn cốt truyện.

---

## 📱 3. Hướng Dẫn Cài Đặt

### Cách 1: Cài đặt trực tiếp qua file Standalone APK (Dành cho Android)
1. Tải file **`Imouto_Re_VietHoa.apk`** (~711 MB) từ mục [Releases](https://github.com/lvh0210/Imouto-VietHoa/releases/latest).
2. Cài đặt file APK lên điện thoại Android (yêu cầu Android 8.0 trở lên, khuyến nghị chip Snapdragon 7/8 series).
3. Mở ứng dụng `ImoutoRe` từ màn hình chính để vào thẳng game và chơi mượt mà với bàn phím cảm ứng được tích hợp sẵn.

### Cách 2: Cài đặt bản Patch cho Winlator / Mobox (Android)
Nếu bạn đã có sẵn thư mục game trong Winlator:
1. Tải gói **`Imouto_VietHoa_Update_Patch.zip`** (118 KB) từ mục Releases.
2. Giải nén đè toàn bộ các file bên trong vào thư mục game trên điện thoại:
   `/storage/emulated/0/MT2/妹と過ごす1ヵ月間_Re/`
3. Trong Winlator: Nhấn giữ vào `妹と過ごす1ヵ月間_Re.exe` $\rightarrow$ Chọn **Create Shortcut** $\rightarrow$ Tại tab Shortcuts, chọn **Export to Android Home Screen** để tạo icon 1 chạm ngoài màn hình chính.

### Cách 3: Chơi trên máy tính Windows (PC)
1. Tải gói full game hoặc sao chép thư mục game đã Việt hóa vào máy tính.
2. Chạy trực tiếp file `妹と過ごす1ヵ月間_Re.exe` để trải nghiệm.

---

## 📂 4. Cấu Trúc Thư Mục Mã Nguồn

```
Imouto-VietHoa/
├── Source/
│   └── ImoutoVi.cs              # Mã nguồn C# module IL Hook runtime
├── Data/
│   ├── translation_extra.json   # Từ điển chuyển ngữ 2.806 mục
│   └── icon.png                 # Biểu tượng gốc sắc nét 256x256 của game
├── Scripts/
│   ├── build_standalone_apk.py  # Script tự động đóng gói và ký số APK Android
│   └── extract_ico.py           # Script trích xuất icon từ PE Resource
├── .gitignore
├── LICENSE                      # Giấy phép MIT
└── README.md
```

---

## ⚙️ 5. Hướng Dẫn Tự Biên Dịch Mã Nguồn

### 1. Biên dịch module `ImoutoVi.dll`:
```powershell
& "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe" `
  /target:library `
  /out:"ImoutoVi.dll" `
  /r:"<Đường_dẫn_game>\妹と過ごす1ヵ月間_Re_Data\Managed\netstandard.dll" `
  /r:"<Đường_dẫn_game>\妹と過ごす1ヵ月間_Re_Data\Managed\UnityEngine.CoreModule.dll" `
  Source\ImoutoVi.cs
```

### 2. Tự đóng gói Standalone APK:
```bash
python Scripts/build_standalone_apk.py
```

---

## 📄 6. Tuyên Bố Miễn Trừ Trách Nhiệm (Disclaimer)

* Bản dịch và các công cụ trong kho mã nguồn này được phát triển cho mục đích học tập, nghiên cứu kỹ thuật đảo ngược (reverse-engineering) và hỗ trợ cộng đồng người chơi Việt ngữ.
* Bản quyền gốc của trò chơi hoàn toàn thuộc về tác giả và nhà phát triển **やくも牛乳**. Hãy ủng hộ nhà phát triển nếu bạn yêu thích tác phẩm!
