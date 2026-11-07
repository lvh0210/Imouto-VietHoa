# CHECKPOINT DỰ ÁN VIỆT HÓA IMOUTO (NATIVE ANDROID PORT)

- **Cập nhật lần cuối:** 2026-11-07T20:03:00+07:00
- **Trạng thái:** Đã hoàn thành vá Shader CoreBlit 25-Pass, Rebuild và ký số Native APK thành công 100%. Đã cài đặt và chạy thử nghiệm trên giả lập LDPlayer 9. Lỗi render loop URP đã triệt tiêu hoàn toàn. Đang xử lý mắt xích cuối cùng: Fallback Font Asset của TextMeshPro.

---

## 1. MỤC TIÊU & PHẠM VI DỰ ÁN
- **Tên dự án:** Imouto Localization & Native Android Port.
- **Thư mục dự án:** `D:\VibeCode\Game_VietHoa\Imouto_VietHoa` & `D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project`.
- **Mục tiêu:** Chuyển đổi và tối ưu hóa game Unity 2022.3.62f1 sang Native Android APK (ARM64 IL2CPP thuần), tích hợp trọn vẹn bản dịch tiếng Việt, loại bỏ toàn bộ lỗi render màn đen.

---

## 2. KẾT QUẢ VỪA ĐẠT ĐƯỢC
- [x] **Vá Shader URP CoreBlit hoàn chỉnh:**
  - Viết lại `Hidden_Universal_CoreBlit.shader`, `Hidden_Universal_CoreBlitColorAndDepth.shader`, `Hidden_Universal_BlitHDROverlay.shader`, `Hidden_Universal Render Pipeline_Blit.shader`.
  - Hỗ trợ đầy đủ 25 Pass theo chuẩn URP (bao gồm `BilinearDebugDraw`, `NearestDebugDraw`, `VertTriangle`, `VertQuad`).
  - Đã sao chép vào `Source/Patches/Shaders` của Git repo.
- [x] **Biên dịch & Ký số thành công:**
  - Unity Batchmode build thành công với Exit Code 0.
  - Ký số chuẩn V2 + V3 bằng `apksigner 34.0.0` thành công.
  - Tệp APK: `D:\Downloads\Imouto_Native_Android.apk` (~546 MB).
- [x] **Cài đặt & Khởi chạy trên LDPlayer 9:**
  - ADB nạp thành công APK vào `emulator-5554`.
  - Trích xuất Logcat xác nhận: **Lỗi URP CoreBlit Render Loop đã biến mất hoàn toàn 100%!**

---

## 3. PHÁT HIỆN MẮT XÍCH CUỐI CÙNG & HƯỚNG XỬ LÝ (NEXT STEPS)
- **Vấn đề:** Trong Logcat xuất hiện lỗi `NullReferenceException` tại `TMPro.TMP_FontAsset.TryAddCharacterInternal` khi `TMProLocalize` nạp các chuỗi tiếng Việt.
- **Nguyên nhân gốc rễ:** Tệp font asset chính của game `japaneseFont.asset` đang chứa bảng tham chiếu fallback:
  `m_FallbackFontAssetTable: - {fileID: 11400000, guid: 61a121c25085c494f819668e5591b8a7}`
  Khi một ký tự tiếng Việt không nằm trong font tĩnh, TMP tự động tìm sang font fallback này (vốn ở chế độ Dynamic nhưng không có file TTF runtime tương ứng trong bản port) dẫn đến văng NullReference và làm gián đoạn luồng dựng Canvas.
- **Giải pháp:**
  1. Xóa liên kết fallback bị lỗi hoặc trỏ `m_FallbackFontAssetTable` về danh sách trống `[]` (hoặc font đã nạp sẵn).
  2. Bổ sung bộ lọc an toàn trong `SanitizeFont` của `ImoutoVi.cs` để chuẩn hóa các ký tự có dấu, ngăn chặn gọi `TryAddCharacterInternal`.
  3. Rebuild nhanh lại APK và chụp ảnh màn hình Title scene hiển thị đầy đủ hình ảnh.

---

## 4. HƯỚNG DẪN TIẾP TỤC
- Để tiếp tục ngay, bạn chỉ cần gửi tin nhắn: **`tiếp`** hoặc **`tiếp tục`**.
