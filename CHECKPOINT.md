# CHECKPOINT: Khắc phục triệt để lỗi chuyển cảnh, Live2D Render URP & Touch Controls

## 1. Thông tin phiên làm việc
- **Thời gian cập nhật:** 2026-11-22
- **Thiết bị kiểm thử:** OnePlus 7 Pro (Android 12, Rooted, Serial: `c1b6357c`)
- **Gói cài đặt:** `D:\Downloads\Imouto_Native_Android.apk` (Ký số chuẩn V2+V3)
- **Hệ thống điều khiển:** `cli-anything-imouto` (Harness theo chuẩn HKUDS)

---

## 2. Các vấn đề cốt lõi đã được phát hiện & triệt tiêu

### Vấn đề 1: Đen màn khi bấm "Chơi từ đầu" (Black Screen)
- **Nguyên nhân 1 (URP Camera Stacking):** Naninovel cameras (`Camera` và `UICamera`) không nằm trong `cameraStack` của Base Camera trong Universal Render Pipeline, làm ghi đè framebuffer đen.
  - *Đã xử lý:* Triển khai `SceneMaster.SetupURPCameraStack()` tự động cấu hình Base/Overlay camera stack trong URP.
- **Nguyên nhân 2 (DOTween Inactive Object Freeze):** `FadeIn` gọi `ForceDismissBlackScreen()` khi bắt đầu sequence khiến GameObject `black` bị `SetActive(false)`. DOTween không thể chạy tween trên object bị disable khiến `AsyncWaitForCompletion()` treo vô hạn ở dòng 4 của Prologue.
  - *Đã xử lý:* Tách biệt logic fade, chỉ ẩn và hủy raycast khi sequence hoàn tất.
- **Nguyên nhân 3 (Live2D P/Invoke Core Mismatch):** Live2D Cubism 5.x đổi tên `csmGetDrawableRenderOrders` thành `csmGetRenderOrders`.
  - *Đã xử lý:* Dùng Mono.Cecil patch trực tiếp `Live2D.Cubism.dll`.

### Vấn đề 2: Lỗi Shader Live2D hiển thị khối tím/hồng (Magenta Polygon Artifact)
- **Nguyên nhân:** Toàn bộ shader `Live2D Cubism/Unlit` và `Live2D Cubism/Mask` trong dự án ban đầu chỉ là file giả lập (`//DummyShaderTextExporter`), không tương thích Universal Render Pipeline (URP). Trên OpenGL ES 3 / Vulkan của Android, các shader này thiếu `Core.hlsl` và `TransformObjectToHClip`, dẫn đến lỗi shader compilation và Unity vẽ màu tím (#FF00FF).
- **Đã xử lý:** 
  - Tái cấu trúc hoàn toàn `Live2D Cubism/Unlit` và `Live2D Cubism/Mask` chuẩn URP HLSL:
    - Nhúng `Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl`
    - Áp dụng `TransformObjectToHClip` và `CBUFFER_START(UnityPerMaterial)`
    - Hỗ trợ đầy đủ `CUBISM_MASK_ON` và `CUBISM_INVERT_ON` cho mặt nạ cắt mắt/mi
    - Đồng bộ mã shader vào cả 3 vị trí: `Resources/live2d/cubism/shaders/unlit.shader`, `Assets/Shader/Live2D Cubism_Unlit.shader`, và `Assets/Shader/Live2D Cubism_Unlit_0.shader`.
  - Đăng ký 4 shader Live2D vào `Always Included Shaders` trong `ProjectSettings/GraphicsSettings.asset` để ngăn Unity tước bỏ (strip) khi build APK.

### Vấn đề 3: Phím cảm ứng trên Mobile / ADB (Touch Responsiveness)
- **Nguyên nhân:** `UIButtonMaster.cs` chỉ gán `isPointerInside = true` khi nhận sự kiện `OnPointerEnter` (vốn là sự kiện rê chuột của PC). Trên màn hình cảm ứng điện thoại, ngón tay chạm trực tiếp (`PointerDown`), khiến `isPointerInside` giữ giá trị false và sự kiện `OnPointerUp` hủy bỏ `MouseClick()`.
- **Đã xử lý:** Cập nhật `OnPointerDown` tự động kích hoạt `isPointerInside = true` và cho phép `OnPointerUp` thực thi `MouseClick()` ngay khi có `actionFlag`.

---

## 3. Trạng thái hiện tại
- Đang thực hiện biên dịch gia tăng Unity IL2CPP APK bằng `cli-anything-imouto build`.
- Tiếp tục tự động ký số và triển khai trực tiếp vào OnePlus 7 Pro.
