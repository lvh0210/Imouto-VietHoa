# Dự Án Bản Địa Hóa Tiếng Việt: 妹と過ごす1ヵ月間_Re (One Month with My Sister _Re)

<p align="center">
  <img src="Data/icon.png" width="128" height="128" alt="Logo Game">
  <br>
  <b>Bản dịch tiếng Việt hoàn thiện 100% dành cho Android (Native ARM64 APK) và PC (Windows)</b>
</p>

---

## 📖 1. Giới Thiệu Dự Án

* **Tên gốc:** 妹と過ごす1ヵ月間_Re (One Month with My Sister _Re)
* **Nhà phát triển:** 八雲ミル (Yakumo Milk)
* **Game Engine:** Unity 2022.3.62f1 + IL2CPP ARM64 + Naninovel Visual Novel Engine + BehaviorDesigner + Universal Render Pipeline (URP).
* **Mục tiêu:** Bản địa hóa trọn vẹn 100% cốt truyện, hội thoại, giao diện, bong bóng thoại tương tác và phân cảnh sang tiếng Việt với văn phong mượt mà, tự nhiên và hiển thị chuẩn xác không lỗi dấu.

---

## 🚀 2. Điểm Nhấn Kỹ Thuật

```
+---------------------------------------------------------------------------------------+
|                              KIẾN TRÚC BẢN ĐỊA HÓA NATIVE                             |
+---------------------------------------------------------------------------------------+
|  [Nền tảng Android Native]       --> ARM64-v8a IL2CPP (libil2cpp.so 98.8MB, Unity 3D) |
|  [Hiệu năng di động]            --> Chạy trực tiếp thuần Native, 60 FPS, không giả lập |
|  [Thoại cốt truyện Naninovel]    --> 17 kịch bản, 4.516 câu thoại đã Việt hóa         |
|  [Font hiển thị tiếng Việt]     --> RiiPopkaku_VI (8.546 glyphs hiển thị chuẩn đẹp)  |
|  [Bong bóng thoại & Dynamic Text] --> Runtime Hook: ImoutoVi.cs (Text changed event)  |
|  [Từ điển Master Dictionary]     --> translation_extra.json (2.806 mục dịch)          |
|  [Đóng gói & Chữ ký số]         --> Android APK Signature Scheme V2 + V3              |
+---------------------------------------------------------------------------------------+
```

### Điểm nổi bật:
1. **Bản Android APK thuần Native (Nói không với giả lập):**
   - Không sử dụng lớp bọc Winlator/Wine/Box64 cồng kềnh, loại bỏ hoàn toàn hiện tượng văng ứng dụng hoặc không tương thích chip.
   - Biên dịch trực tiếp C++ Machine Code (`libil2cpp.so`) cho kiến trúc `arm64-v8a`, đạt hiệu suất tối đa 60 FPS và thời lượng pin tối ưu.
   - Dung lượng cài đặt tinh gọn chỉ **~546 MB** (thay vì 2.6 GB - 3 GB khi chạy qua giả lập).
2. **Triệt tiêu hoàn toàn lỗi rỗng dấu & ô vuông:**
   - Thay thế font nhúng bằng **`RiiPopkaku_VI`**, hỗ trợ đầy đủ 100% dải ký tự tiếng Việt có dấu.
3. **Hook động đa luồng qua `ImoutoVi.cs`:**
   - Tự động bắt sự kiện cập nhật văn bản và tra cứu từ điển thời gian thực `translation_extra.json`.

---

## 📥 3. Hướng Dẫn Cài Đặt

### Cách 1: Cài đặt bản Native APK (Dành cho Android)
1. Tải file **`Imouto_Native_Android.apk`** (~546 MB) từ mục [Releases](https://github.com/lvh0210/Imouto-VietHoa/releases/latest).
2. Cài đặt trực tiếp file APK lên điện thoại Android (yêu cầu Android 8.0 trở lên).
3. Mở game từ màn hình chính và trải nghiệm trực tiếp với giao diện điều khiển cảm ứng mượt mà.

### Cách 2: Cài đặt bản Patch cho Máy tính (Windows PC)
Nếu bạn chơi trên máy tính:
1. Tải gói **`Imouto_VietHoa_Update_Patch.zip`** (118 KB) từ mục [Releases](https://github.com/lvh0210/Imouto-VietHoa/releases/latest).
2. Giải nén đè toàn bộ các file bên trong vào thư mục cài game trên máy tính.
3. Chạy file thực thi `.exe` của game để thưởng thức bản dịch tiếng Việt.

---

## 📁 4. Cấu Trúc Thư Mục Mã Nguồn

```
Imouto-VietHoa/
├── Source/
│   └── ImoutoVi.cs              # Mã nguồn C# module Translation Hook runtime
├── Data/
│   ├── translation_extra.json   # Từ điển chuyển ngữ 2.806 mục
│   └── icon.png                 # Biểu tượng gốc sắc nét 256x256 của game
├── Scripts/
│   └── extract_ico.py           # Script trích xuất icon từ PE Resource
├── .gitignore
├── LICENSE                      # Giấy phép MIT
├── CHECKPOINT.md                # Nhật ký trạng thái kỹ thuật
└── README.md
```

---

## 📜 5. Tuyên Bố Miễn Trừ Trách Nhiệm (Disclaimer)

* Bản dịch và các công cụ trong kho mã nguồn này được phát triển cho mục đích học tập, nghiên cứu kỹ thuật và hỗ trợ cộng đồng người chơi Việt ngữ.
* Bản quyền gốc của trò chơi hoàn toàn thuộc về tác giả và nhà phát triển **八雲ミル (Yakumo Milk)**. Hãy ủng hộ nhà phát triển nếu bạn yêu thích tác phẩm!
