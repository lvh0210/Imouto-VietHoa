# Trạng Thái Dự Án (Checkpoint) - HOÀN TẤT 100%

## 1. Thông Tin Chung
* **Dự án:** Bản địa hóa tiếng Việt `妹と過ごす1ヵ月間_Re` (One Month with My Sister _Re)
* **Thư mục dự án:** `D:\VibeCode\Game_VietHoa\Imouto_VietHoa`
* **Tác giả:** `lvh0210`
* **Phiên bản:** v2.0.1 (Hotfix Khắc Phục Đen Màn Hình Android & Windows PC)
* **Ngày cập nhật:** 06/11/2026

## 2. Nhật Ký Phiên Bản (Changelog)
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
