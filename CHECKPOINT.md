# CHECKPOINT: Khắc phục triệt để lỗi Mảng Hồng Tím (Live2D & Naninovel Shaders URP)

## 1. Thông tin phiên làm việc
- **Thời gian cập nhật:** 2026-11-22 23:30
- **Phiên bản phát hành:** `v2.0.4`
- **Gói cài đặt:** `D:\Downloads\Imouto_Native_Android.apk` (525.9 MB, Ký số chuẩn V2+V3)
- **Hệ thống điều khiển:** `cli-anything-imouto` (Harness theo chuẩn HKUDS)
- **Thiết bị người dùng test:** OnePlus 7 Pro (Android 12, Rooted)

---

## 2. Nguyên nhân gốc rễ và Biện pháp xử lý triệt để "Mảng Hồng Tím"

### Vấn đề cốt lõi
- Khi bấm "Chơi từ đầu" (New Game), game chuyển cảnh qua Prologue vào Main scene (phòng khách/phòng ngủ).
- Tại đây, mô hình Live2D em gái (`妹`) và giao diện đối thoại / chuyển cảnh Naninovel bị hiển thị thành một **khối đa giác màu hồng tím (#FF00FF)** đặc quánh che toàn bộ màn hình.

### Phân tích nguyên nhân kỹ thuật
1. **Lỗi thiếu gói thư viện `Core.hlsl` của Live2D Shaders:**
   - Phiên bản trước sử dụng `#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"`.
   - Dự án ExportedProject sử dụng các DLL runtime URP trong `Assets/Plugins/` thay vì gói UPM trong `Packages/`. Do đó, đường dẫn gói không tồn tại trên đĩa khiến shader `Live2D Cubism/Unlit` và `Live2D Cubism/Mask` phát sinh lỗi biên dịch nghiêm trọng (`Shader error: Couldn't open include file`).
   - Unity không thể biên dịch binary GLES3/Vulkan (0 internal programs) và buộc phải thay thế bằng `materialErrorPS` (Shader lỗi màu hồng tím đặc).
2. **Naninovel Core Shaders là file rỗng (`//DummyShaderTextExporter`):**
   - Toàn bộ các shader Naninovel trong `Assets/Resources/naninovel/shaders/` (`RevealableTMProText`, `TransitionalTexture`, `TransitionalUI`, `Transparent`, `DepthMask`, `DigitalGlitch`, v.v.) vốn là stub rỗng trích xuất từ AssetRipper không có pass URP và blending, gây lỗi render khi gọi hội thoại hoặc chuyển ảnh nền.

### Giải pháp kỹ thuật đã triển khai (Phiên bản v2.0.4)
1. **Tái cấu trúc Live2D Shaders (`Live2D Cubism/Unlit` & `Live2D Cubism/Mask`):**
   - Chuyển toàn bộ sang chuẩn self-contained Cg/UnityCG (`UnityObjectToClipPos`, `ComputeScreenPos`) đi kèm với Unity Editor (không phụ thuộc vào bất kỳ package ngoài nào).
   - Tích hợp 2 pass render tương thích tối đa URP: `UniversalForward` và `SRPDefaultUnlit`.
   - Hỗ trợ đầy đủ các thuộc tính hòa trộn Live2D: `cubism_MultiplyColor`, `cubism_ScreenColor`, `cubism_ModelOpacity`, cùng tính năng mặt nạ mắt `CUBISM_MASK_ON` và đảo mặt nạ `CUBISM_INVERT_ON`.
   - Kết quả biên dịch: `Live2D Cubism/Unlit` sinh thành công 8 programs GLES3 (4 unique), `Live2D Cubism/Mask` sinh 2 programs GLES3 với **0 lỗi biên dịch**.
2. **Tái cấu trúc 12 Naninovel Shaders:**
   - Xây dựng hoàn chỉnh shader TextMeshPro Distance Field với hiệu ứng gõ chữ `_LineClipRect` và `_CharClipRect` cho `Naninovel/RevealableTMProText` (và các biến thể Extra, RTL).
   - Xây dựng shader chuyển cảnh nền `Naninovel/TransitionalTexture` và `Naninovel/TransitionalUI` hỗ trợ Stencil và UI Clipping.
   - Xây dựng shader `Hidden/Naninovel/Transparent` và `Hidden/Naninovel/DepthMask`.
3. **Đăng ký Always Included Shaders:**
   - Đăng ký toàn bộ 12 GUIDs shader Naninovel và 4 GUIDs Live2D vào `GraphicsSettings.asset` (`m_AlwaysIncludedShaders`) đảm bảo IL2CPP compiler giữ lại đầy đủ binary trên Android.
4. **Biên dịch & Ký số thành công:**
   - `cli-anything-imouto build` hoàn thành với mã thoát 0 (0 error, 0 warning).
   - `cli-anything-imouto sign` hoàn thành ký số APK V1 + V2 + V3, xác thực `verified: True`.
   - Đã xuất bản tệp `D:\Downloads\Imouto_Native_Android.apk` sẵn sàng cho người dùng kiểm thử.

---

## 3. Trạng thái hiện tại
- Đã sẵn sàng phát hành GitHub Release `v2.0.4`.
- Người dùng tự kiểm thử trực tiếp trên thiết bị OnePlus 7 Pro.
