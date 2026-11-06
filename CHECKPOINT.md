# Trạng Thái Dự Án (Checkpoint) - HOÀN TẤT 100%

## 1. Thông Tin Chung
* **Dự án:** Bản địa hóa tiếng Việt `妹と過ごす1ヵ月間_Re` (One Month with My Sister _Re)
* **Thư mục dự án:** `D:\VibeCode\Game_VietHoa\Imouto_VietHoa`
* **Tác giả:** `lvh0210`
* **Phiên bản:** v2.0.2 (Khắc Phục Toàn Diện Lỗi Đen Trắng / Khôi Phục Custom Shaders URP & Toon Shading)
* **Ngày cập nhật:** 06/11/2026

## 2. Nhật Ký Phiên Bản (Changelog)
### [v2.0.2] - 06/11/2026 (Hotfix Sửa Lỗi Hiển Thị Đen Trắng / Tái Cấu Trúc Shader URP)
* **Nguyên nhân cốt lõi:** Khi dịch ngược tài nguyên từ bản PC đã đóng gói, AssetRipper không thể trích xuất mã nguồn HLSL nguyên bản mà sinh ra các file Shader giả định (Dummy). Các shader này thiếu thẻ render `LightMode` của Universal Render Pipeline (`UniversalForward`, `SRPDefaultUnlit`, `Universal2D`), khiến URP Forward Renderer bỏ qua hoàn toàn các đối tượng 3D và 2D Sprite. Đồng thời các shader nhân vật `KToon` và `MaterialError` trả về cứng màu trắng tinh `float4(1.0, 1.0, 1.0, 1.0)`, dẫn tới hiện tượng toàn bộ game chỉ hiển thị màn hình đen (màu camera) cùng chữ UI màu trắng.
* **Tái thiết kế toàn diện 79 Custom Shaders:**
  - **Khôi phục Shader 2D Sprite (`Universal Render Pipeline/2D/Sprite-Lit-Default`, `AllIn1SpriteShader`):** Bổ sung 3 Pass (`UniversalForward`, `Universal2D`, `SRPDefaultUnlit`), chế độ `Blend SrcAlpha OneMinusSrcAlpha`, `ZWrite Off`, `Cull Off`, lấy mẫu `_MainTex` kết hợp `_Color` và `_RendererColor`. Toàn bộ hình nền Title (`title_background.png`) và các logo 2D hiển thị màu sắc rực rỡ, sắc nét.
  - **Khôi phục Shader Nhân vật KToon (`KToon/KToon`, `KToon Transparent`, `KToon Eye`, `KToonSS`, `KToonSSHand`):** Triển khai thuật toán Toon Shading Half-Lambert + Ramp smoothstep kết hợp shadow/highlight tinting, lấy mẫu chuẩn xác `_BaseMap * _BaseColor * _Color`, hiển thị đầy đủ chi tiết da, tóc, quần áo và khuôn mặt nhân vật nữ chính.
  - **Khôi phục Shader lilToon (`Hidden/lilToonOutline`, `lilToon`, `Hidden/lilToonTransparent`, `Hidden/lilToonCutout`):** Bổ sung pass `UniversalForward` và `SRPDefaultUnlit` cho hơn 40 vật liệu phụ kiện, trang phục và hiệu ứng viền.
  - **Khôi phục URP Core Lit & Unlit (`Universal Render Pipeline/Lit`, `Unlit`, `Particles`):** Cung cấp đường truyền render chuẩn xác cho toàn bộ bối cảnh phòng ngủ, nội thất và vật dụng.
  - **Khôi phục Shader Blit & Post-Processing (`Hidden/Universal/CoreBlit`, `Blit`, `FinalPost`, `UberPost`):** Viết lại cơ chế pass-through kết xuất texture toàn màn hình (`_BlitTexture` / `_MainTex`), loại bỏ hoàn toàn hiện tượng bộ đệm bị đè màu trắng khi blit ra màn hình thiết bị.
  - **Bảo vệ chống cháy sáng (Anti-Bloom Whiteout):** Chuyển đổi các hiệu ứng hậu kỳ phụ trợ (Bloom, MotionBlur, DoF) về trạng thái an toàn `float4(0.0, 0.0, 0.0, 0.0)` tránh làm chói lóa màn hình di động.
* **Đóng gói APK v2.0.2:** Biên dịch lại mã máy C++ IL2CPP ARM64, tích hợp toàn bộ shader mới, ký số chuẩn V2 + V3 bằng apksigner.

### [v2.0.1] - 06/11/2026 (Hotfix Sửa Lỗi Đen Màn Hình Native Android)
* **Khóa cứng Graphics API OpenGL ES 3:** Vô hiệu hóa Vulkan mặc định trên Unity 2022.3 Android để loại bỏ hoàn toàn lỗi swapchain/subpass gây đen màn hình trên các chip đồ họa ARM Mali, Qualcomm Adreno và PowerVR.
* **Sửa xung đột Camera Depth Naninovel:** Xử lý triệt để việc `NaniCamera` (depth 0, ClearFlags Solid Color Black) che phủ đè lên `Main Camera` (depth -1) trong Title scene. Tự động tắt camera nền và nâng depth của Main Camera lên 10.
* **Sửa URP CameraStack Null Reference Exception:** Kiểm tra `uICamera != null` và tránh trùng lặp trước khi thêm vào `UniversalAdditionalCameraData.cameraStack`, ngăn ngừa ngắt quãng pipeline render đồ họa của URP ở mỗi khung hình.
* **Cơ chế Failsafe tự động giải phóng rèm đen:** Bổ sung `ForceDismissBlackScreen()` với timeout 1.0s - 2.0s trong `SceneMaster` và `TitleSceneManager`, bảo đảm rèm đen luôn tự động biến mất kể cả khi animation làm mờ DOTween bị hoãn.
* **Cập nhật ImoutoVi:** Hỗ trợ nạp đồng bộ từ điển từ `Resources/translation_extra.json` ngay khi khởi động.

### [v2.0.0] - 06/11/2026 (Bản Native Android Thuần)
* **Chuyển đổi Native ARM64 IL2CPP:** Loại bỏ hoàn toàn lớp bọc giả lập Winlator/Wine/Box64. Biên dịch trực tiếp mã nguồn Unity C# sang Native C++ Machine Code (`libil2cpp.so` 98.84 MB) cho kiến trúc di động `arm64-v8a`.
* **Hiệu năng & Trải nghiệm:** Chạy mượt mà 60 FPS, không hao pin, không bị văng app (crash), tích hợp sẵn điều khiển cảm ứng.
* **Tối ưu dung lượng:** Giảm dung lượng cài đặt từ 711 MB (giả lập) xuống còn **546 MB** (Native tối ưu).
* **Chữ ký số hợp lệ:** Ký số chuẩn Android APK Signature Scheme V2 + V3, tương thích tuyệt đối từ Android 8.0 Oreo đến Android 15/16.

### [v1.0.0] - 05/11/2026 (Lưu trữ lịch sử)
* Bản dịch tiếng Việt 100% cho 17 kịch bản Naninovel (4.516 câu thoại) và 2.806 mục từ điển runtime.
* Cung cấp gói bản vá cập nhật cho PC Windows (`Imouto_VietHoa_Update_Patch.zip`).

## 3. Liên Kết GitHub Chính Thức
* **Repository:** https://github.com/lvh0210/Imouto-VietHoa
* **Bản phát hành Releases mới nhất:** https://github.com/lvh0210/Imouto-VietHoa/releases/latest
* **Tải trực tiếp APK Native Android:** `Imouto_Native_Android.apk` (~546 MB)
* **Tải trực tiếp Patch PC:** `Imouto_VietHoa_Update_Patch.zip` (118 KB)
