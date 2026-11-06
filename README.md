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
|  [Đồ họa & Hiển thị]             --> Khóa cứng OpenGL ES 3 (Khắc phục đen màn Vulkan) |
|  [Bộ đổ bóng Universal Pipeline]--> 79 Custom Shaders tái thiết kế (KToon, URP, 2D)   |
|  [Hiệu năng di động]            --> Chạy trực tiếp thuần Native, 60 FPS, không giả lập |
|  [Thoại cốt truyện Naninovel]    --> 17 kịch bản, 4.516 câu thoại đã Việt hóa         |
|  [Font hiển thị tiếng Việt]     --> RiiPopkaku_VI (8.546 glyphs hiển thị chuẩn đẹp)  |
|  [Bong bóng thoại & Dynamic Text] --> Runtime Hook: ImoutoVi.cs (Text changed event)  |
|  [Từ điển Master Dictionary]     --> translation_extra.json (2.806 mục dịch)          |
|  [Đóng gói & Chữ ký số]         --> Android APK Signature Scheme V2 + V3              |
+---------------------------------------------------------------------------------------+
```

### Điểm nổi bật & Cập nhật v2.0.2 (Sửa Lỗi Hiển Thị Đen Trắng / Khôi Phục Custom Shaders):
1. **Khắc phục triệt để lỗi hiển thị đen trắng (Monochrome / Wireframe Fix):**
   - **Tái cấu trúc 79 Custom Shaders của URP:** Khắc phục lỗi toàn bộ shader bị decompile thành dummy thiếu các thẻ pass `LightMode` (`UniversalForward`, `SRPDefaultUnlit`, `Universal2D`), phục hồi 100% đối tượng đồ họa bị URP UniversalRenderer bỏ qua.
   - **Khôi phục Shader 2D Sprite:** Bổ sung cấu trúc 3 Pass, hỗ trợ `Blend SrcAlpha OneMinusSrcAlpha`, lấy mẫu `_MainTex` kết hợp `_Color` và `_RendererColor` cùng `_Flip.xy`. Toàn bộ hình nền Title (`title_background.png`) và các logo 2D hiển thị màu sắc rực rỡ, sắc nét.
   - **Khôi phục Shader Nhân vật KToon:** Triển khai thuật toán Toon Shading Half-Lambert + Ramp smoothstep kết hợp shadow/highlight tinting, lấy mẫu chuẩn xác `_BaseMap * _BaseColor * _Color`, phục hồi trọn vẹn chi tiết da, tóc, quần áo và khuôn mặt nhân vật nữ chính.
   - **Khôi phục Blit & Post-Processing:** Viết lại cơ chế pass-through texture toàn màn hình (`_BlitTexture` / `_MainTex`), loại bỏ hoàn toàn hiện tượng bộ đệm bị đè màu trắng khi blit ra màn hình thiết bị.
2. **Khắc phục lỗi đen màn hình (v2.0.1):**
   - **Graphics API OpenGL ES 3:** Khóa cứng GLES3 tương thích tuyệt đối với chip ARM Mali, Qualcomm Adreno và PowerVR.
   - **Xung đột Camera Depth:** Nâng depth Main Camera Title lên 10, vô hiệu hóa camera nền Naninovel.
   - **Failsafe tự động mở rèm đen:** Bổ sung cơ chế giải phóng rèm đen tự động sau 1.0s - 2.0s nạp cảnh.
3. **Bản Android APK thuần Native (Nói không với giả lập):**
   - Không sử dụng lớp bọc Winlator/Wine/Box64 cồng kềnh, loại bỏ hoàn toàn hiện tượng văng ứng dụng hoặc không tương thích chip.
   - Biên dịch trực tiếp C++ Machine Code (`libil2cpp.so`) cho kiến trúc `arm64-v8a`, đạt hiệu suất tối đa 60 FPS và thời lượng pin tối ưu.
   - Dung lượng cài đặt tinh gọn chỉ **~546 MB** (thay vì 2.6 GB - 3 GB khi chạy qua giả lập).
4. **Triệt tiêu hoàn toàn lỗi rỗng dấu & ô vuông:**
   - Thay thế font nhúng bằng **`RiiPopkaku_VI`**, hỗ trợ đầy đủ 100% dải ký tự tiếng Việt có dấu.
5. **Hook động đa luồng qua `ImoutoVi.cs`:**
   - Nạp đồng bộ từ điển từ `Resources/translation_extra.json` và tra cứu sự kiện văn bản theo thời gian thực.

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
│   ├── ImoutoVi.cs              # Mã nguồn C# module Translation Hook runtime
│   └── Patches/                 # Các bản vá C# khắc phục lỗi đồ họa & render mobile
│       ├── Shaders/             # 79 Custom Shaders URP (KToon, Sprite, Lit, Unlit, Blit)
│       ├── InitializeNaninovelEngine.cs # Sửa lỗi CameraStack NullRef & Camera Depth
│       ├── SceneMaster.cs               # Bổ sung failsafe tự động mở rèm đen
│       ├── TitleSceneManager.cs         # Cưỡng bức hiển thị Main Camera Title
│       ├── StartupInitializer.cs        # Nạp tài nguyên khởi động Addressables
│       └── Builder.cs                   # Automation script build Android IL2CPP
├── Data/
│   ├── translation_extra.json   # Từ điển chuyển ngữ 2.806 mục
│   └── icon.png                 # Biểu tượng gốc sắc nét 256x256 của game
├── Scripts/
│   ├── sign_apk.bat             # Script ký số APK (v1, v2, v3) tự động
│   ├── fix_all_shaders.ps1      # Tái tạo và nâng cấp shader URP / KToon / 2D
│   ├── fix_blit_shaders.ps1     # Khôi phục fullscreen texture blit
│   └── fix_post_effects.ps1     # Chống cháy sáng post-effects
├── .gitignore
├── LICENSE                      # Giấy phép MIT
├── CHECKPOINT.md                # Nhật ký trạng thái kỹ thuật
└── README.md
```

---

## 📜 5. Tuyên Bố Miễn Trừ Trách Nhiệm (Disclaimer)

* Bản dịch và các công cụ trong kho mã nguồn này được phát triển cho mục đích học tập, nghiên cứu kỹ thuật và hỗ trợ cộng đồng người chơi Việt ngữ.
* Bản quyền gốc của trò chơi hoàn toàn thuộc về tác giả và nhà phát triển **八雲ミル (Yakumo Milk)**. Hãy ủng hộ nhà phát triển nếu bạn yêu thích tác phẩm!
