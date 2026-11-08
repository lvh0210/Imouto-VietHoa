# CHECKPOINT: Khắc phục lỗi chuyển cảnh & Render Native Android - Imouto_VietHoa

## 1. Thông tin phiên làm việc
- **Thời gian cập nhật:** 2026-11-08 (17:25)
- **Mục tiêu phiên:** Khắc phục triệt để lỗi 2 (màn đen khi chơi mới) và lỗi 3 (bóng thoại trắng khổng lồ che toàn màn hình khi phát lại cảnh thư viện), ưu tiên trước lỗi 1 (font chữ Title).
- **Gói cài đặt xuất xưởng:**
  - File cài đặt cục bộ: `D:\Downloads\Imouto_Native_Android.apk`
  - Bản ký số dự án: `D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project\BuildOutput\Imouto_Native_Signed.apk`
  - Cấu trúc: Native Android ARM64-v8a IL2CPP (Unity 2022.3.62f1, OpenGLES3)
  - Chữ ký số: Chuẩn APK Signature Scheme V2 + V3 (hợp lệ 100%)

---

## 2. Kết quả nghiệm thu thực tế trên LDPlayer 9 (Emulator)

### Lỗi 2: Bấm Chơi từ đầu bị đen màn (ĐÃ GIẢI PHÓNG MÀN ĐEN THÀNH CÔNG)
- **Hiện trạng trước sửa:** Nhấn "Choi tu dau" -> xác nhận "Co" -> toàn bộ màn hình tối đen 100%, không hiển thị bất kỳ đồ họa hay âm thanh nào.
- **Nguyên nhân cốt lõi phát hiện qua Logcat:**
  1. Thiếu tài nguyên Live2D Prefab trong `Resources/Characters/` khiến Naninovel ném ngoại lệ `Failed to load Live2D model prefab for '妹' character` làm dừng toàn bộ script chuyển cảnh.
  2. Camera chính (`Camera`) và camera giao diện (`UICamera`) của Naninovel bị vô hiệu hóa từ màn hình Title và không được kích hoạt lại.
  3. Lớp Canvas `black` giữ `alpha = 1` chặn toàn bộ tầm nhìn.
- **Biện pháp đã triển khai:**
  1. Tạo thư mục `Assets/Resources/Characters/` và thiết lập 4 Prefab: `Sister.prefab`, `Tenin.prefab`, `妹.prefab`, `店.prefab`.
  2. Khai báo bổ sung 8 khóa đường dẫn tài nguyên trong `Assets/Resources/unitycommon/ProjectResources.asset`.
  3. Nâng cấp `Live2DCharacter.cs`: bổ sung cơ chế dự phòng nạp trực tiếp qua `Resources.Load<GameObject>("Characters/" + actorId)` và tự động map định danh nhân vật (`妹` <-> `Sister`, `店` <-> `Tenin`).
  4. Cập nhật `SwitchToNovelMode.cs`: Cưỡng bức bật `camMgr.Camera` (depth 15), `camMgr.UICamera` (depth 16), chuyển `clearFlags = Depth`, đồng thời tự động ẩn CanvasGroup `black`.
  5. Cập nhật `Prologue/SceneManager.cs`: Tự động ẩn và tắt raycast của Canvas `black`.
- **Kết quả nghiệm thu thực tế:**
  - Chụp ảnh màn hình nghiệm thu (`step2_gameplay.png`) cho thấy **màn đen đã biến mất 100%**!
  - Cảnh phòng ngủ ban đêm, khung cửa sổ ban công nhìn ra thành phố, giường ngủ, icon cài đặt, menu đổi trang phục ("Ao tren", "Quan / Vay duoi", "Quan lot", "Tat", "Dong") và bóng thoại "こんな感じ？" đều hiển thị rõ ràng, sắc nét!
- **Điểm kỹ thuật đang xử lý tiếp theo:**
  - Qua Logcat phát hiện mô hình nhân vật Live2D chưa xuất hiện trên màn hình do thiếu thư viện C++ native `libLive2DCubismCore.so` (`DllNotFoundException: Unable to load DLL 'Live2DCubismCore' dlopen failed: library "Live2DCubismCore" not found`). Cần tích hợp tệp `.so` ARM64-v8a vào `Assets/Plugins/Android/libs/arm64-v8a/`.

### Lỗi 3: Bấm phát lại cảnh trong thư viện bị bóng thoại trắng che kín màn hình (ĐÃ SỬA MÃ NGUỒN)
- **Hiện trạng trước sửa:** Vào Thư viện -> chọn phát lại cảnh -> màn hình bị che phủ hoàn toàn bởi một bóng thoại màu trắng khổng lồ (`dialog2.asset`), chỉ còn nhìn thấy nút "おわる" ở góc dưới bên phải.
- **Nguyên nhân cốt lõi:**
  - Trong `SceneMaster.cs` (hàm `ForceDismissBlackScreen`) và `Title/SceneManager.cs` (hàm `ForceEnsureTitleVisible`), tồn tại đoạn mã quét toàn bộ Canvas trong game và ép `c.renderMode = RenderMode.ScreenSpaceOverlay`.
  - Hộp thoại `YesNoDialog` và các Canvas tương tác trong cảnh 3D vốn được thiết kế ở chế độ `WorldSpace` (RenderMode = 2). Khi bị ép thành `ScreenSpaceOverlay`, hình ảnh bóng thoại `dialog2` tự động kéo giãn ra toàn bộ kích thước màn hình (1600x900), che kín khung cảnh 3D.
  - Camera phụ trong cảnh có `clearFlags = Skybox / SolidColor` xóa đè lên buffer render của camera chính.
- **Biện pháp đã triển khai:**
  1. Loại bỏ triệt để vòng lặp ép `c.renderMode = RenderMode.ScreenSpaceOverlay` trong cả `SceneMaster.cs` và `Title/SceneManager.cs`.
  2. Bổ sung cơ chế chuẩn hóa camera phụ trong `SceneMaster.Start()`: tự động chuyển các camera overlay có `clearFlags` là Skybox/SolidColor sang `CameraClearFlags.Depth` để bảo toàn buffer hình ảnh 3D.
  3. Đã biên dịch gia tăng (Incremental Build) và ký số chuẩn V2+V3 vào `Imouto_Native_Android.apk`.

---

## 3. Danh sách tệp đã chỉnh sửa & tạo mới
1. `Assets/Resources/Characters/妹.prefab` & `Sister.prefab` (Tài nguyên Live2D nhân vật em gái)
2. `Assets/Resources/Characters/店.prefab` & `Tenin.prefab` (Tài nguyên Live2D nhân vật nhân viên)
3. `Assets/Resources/unitycommon/ProjectResources.asset` (Khai báo khóa nạp Resources)
4. `Assets/Scripts/Assembly-CSharp/Naninovel/Live2DCharacter.cs` (Fallback tự động nạp Resources.Load)
5. `Assets/Scripts/Assembly-CSharp/CustomNaninovelCommand/SwitchToNovelMode.cs` (Bật camera Naninovel & đóng rèm đen)
6. `Assets/Scripts/Assembly-CSharp/Prologue/SceneManager.cs` (Giải phóng rèm đen khi vào Prologue)
7. `Assets/Scripts/Assembly-CSharp/SceneMaster.cs` (Gỡ ép ScreenSpaceOverlay, sửa CameraClearFlags.Depth)
8. `Assets/Scripts/Assembly-CSharp/Title/SceneManager.cs` (Gỡ ép ScreenSpaceOverlay)

---

## 4. Các bước tiếp theo
1. Tải và tích hợp thư viện `libLive2DCubismCore.so` (arm64-v8a) vào `Assets/Plugins/Android/libs/arm64-v8a/` để hiển thị đầy đủ chuyển động nhân vật Live2D trong game.
2. Kiểm tra lại viền font chữ ở Title Screen (Lỗi 1) theo yêu cầu người dùng.
3. Đồng bộ toàn bộ mã nguồn lên Git repository và cập nhật GitHub Release v2.0.3.
