# Trạng Thái Dự Án (Checkpoint) - HOÀN TẤT 100%

## 1. Thông Tin Chung
* **Dự án:** Bản địa hóa tiếng Việt `妹と過ごす1ヵ月間_Re` (One Month with My Sister _Re)
* **Thư mục dự án:** `D:\VibeCode\Game_VietHoa\Imouto_VietHoa`
* **Tác giả:** `lvh0210`
* **Phiên bản:** v1.0.1 (Bản hoàn thiện & Hotfix Chữ Ký Số Android v2+v3)
* **Ngày cập nhật:** 05/11/2026

## 2. Nhật Ký Phiên Bản (Changelog)
### [v1.0.1] - 05/11/2026
* **Hotfix Chữ Ký Số APK Android:** Khắc phục triệt để lỗi cài đặt `INSTALL_PARSE_FAILED_NO_CERTIFICATES` (thông báo gói không hợp lệ / thiếu chứng chỉ nhà phát triển) trên các thiết bị Android 11+ (OriginOS/Vivo, HyperOS, OneUI).
* **Nâng cấp Signing Scheme:** Chuyển đổi toàn diện từ JAR signature v1 sang **APK Signature Scheme v2 & v3** (`SDK 28-2147483647`).
* **Loại bỏ thuộc tính S/MIME:** Triệt tiêu hoàn toàn xung đột OID `SMIMECapability` (`tag -96`) trong nhân Java/AOSP.

### [v1.0.0] - 05/11/2026
* Hoàn thiện 2.806 mục dịch tiếng Việt trong `Data/translation_extra.json`.
* Phát triển module IL Hook `Source/ImoutoVi.cs` xử lý runtime TextMeshPro.
* Đóng gói bản cài đặt APK độc lập và bản vá patch 118 KB.

## 3. Liên Kết GitHub Chính Thức
* **Repository:** https://github.com/lvh0210/Imouto-VietHoa
* **Bản phát hành Releases v1.0.1 (Mới nhất):** https://github.com/lvh0210/Imouto-VietHoa/releases/tag/v1.0.1
* **Tải trực tiếp APK Android v1.0.1:** https://github.com/lvh0210/Imouto-VietHoa/releases/download/v1.0.1/Imouto_Re_VietHoa.apk
* **Tải trực tiếp Patch (PC/Winlator):** https://github.com/lvh0210/Imouto-VietHoa/releases/download/v1.0.1/Imouto_VietHoa_Update_Patch.zip
