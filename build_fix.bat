@echo off
cd /d "%~dp0"
set "PROJECT_DIR=%~dp0"
set "SHORT_DIR=%PROJECT_DIR:~0,8%"

echo Building Flutter project...
echo Project Directory: %PROJECT_DIR%

flutter clean
flutter pub get
flutter build apk --debug

pause
