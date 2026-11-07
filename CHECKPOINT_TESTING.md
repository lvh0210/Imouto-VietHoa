# Technical Checkpoint - Môi Trường Giả Lập & ADB Testing

## 1. Thông Tin Công Cụ Đã Cài Đặt
- **Giả lập:** LDPlayer 9 (Android 9 64-bit, ARM64 Translation)
  - **Đường dẫn cài đặt:** `D:\LDPlayer\LDPlayer9\dnplayer.exe`
  - **Công cụ điều khiển tự động:** `D:\LDPlayer\LDPlayer9\ldconsole.exe`
  - **Shortcut Desktop:** Đã tạo `LDPlayer 9.lnk` ngoài màn hình Desktop.
- **Bộ công cụ ADB:** Google Platform-Tools v37.0.2
  - **Đường dẫn:** `D:\VibeCode\Tools\platform-tools\adb.exe`
  - **Biến môi trường:** Đã tích hợp sẵn vào `User PATH`.

## 2. Thông Số Kết Nối & Lệnh Tự Động Hóa
- **Cổng kết nối ADB:**
  ```powershell
  adb connect 127.0.0.1:5555
  ```
- **Lệnh nạp file APK game vào giả lập:**
  ```powershell
  adb install -r "D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project\BuildOutput\Imouto_Native_Signed.apk"
  ```
- **Lệnh mở game & kiểm tra log:**
  ```powershell
  # Chụp ảnh màn hình kiểm tra đồ họa Title/Shaders
  adb exec-out screencap -p D:\VibeCode\Game_VietHoa\test_screen.png

  # Xem lỗi crash / NullRef / Shader Unity
  adb logcat -d -s Unity DEBUG AndroidRuntime
  ```
