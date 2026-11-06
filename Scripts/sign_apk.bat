@echo off
set "JAVA_HOME=D:\Unity\Editor\2022.3.62f1\Editor\Data\PlaybackEngines\AndroidPlayer\OpenJDK"
set "PATH=%JAVA_HOME%\bin;%PATH%"
set "APKSIGNER=D:\Unity\Editor\2022.3.62f1\Editor\Data\PlaybackEngines\AndroidPlayer\SDK\build-tools\34.0.0\apksigner.bat"
set "KEYSTORE=C:\Users\LvH\.android\debug.keystore"
set "IN_APK=D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project\BuildOutput\Imouto_Native_Unsigned.apk"
set "OUT_APK=D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project\BuildOutput\Imouto_Native_Signed.apk"

echo [1/3] Signing APK with debug keystore...
call "%APKSIGNER%" sign --ks "%KEYSTORE%" --ks-pass pass:android --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true --out "%OUT_APK%" "%IN_APK%"
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Signing failed!
    exit /b 1
)

echo [2/3] Verifying APK signature...
call "%APKSIGNER%" verify -v "%OUT_APK%"
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Verification failed!
    exit /b 1
)

echo [3/3] Copying to D:\Downloads\Imouto_Native_Android.apk...
copy /y "%OUT_APK%" "D:\Downloads\Imouto_Native_Android.apk"
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Copy to Downloads failed!
    exit /b 1
)

echo === SIGNING COMPLETE AND VERIFIED! ===
