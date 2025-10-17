# PowerShell script to build Flutter project with spaces in path
$projectPath = "C:\Users\Waqas AKhtar\OneDrive\Desktop\FA Tech\training_request"

Write-Host "Navigating to project directory..."
Set-Location -Path $projectPath

Write-Host "Cleaning Flutter project..."
flutter clean

Write-Host "Getting dependencies..."
flutter pub get

Write-Host "Building APK..."
flutter build apk --debug

Write-Host "Build completed!"
Read-Host "Press Enter to continue"
