# Build the Windows release and zip it up.
# Run this ON Windows, with Flutter and the "Desktop development with C++"
# Visual Studio workload installed — Flutter cannot cross-compile Windows
# desktop builds from Linux or macOS.
#
# Usage: powershell -ExecutionPolicy Bypass -File scripts\build_windows.ps1

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$PubspecVersion = (Select-String -Path "pubspec.yaml" -Pattern '^version:\s*(\S+)').Matches[0].Groups[1].Value
$Version = $PubspecVersion.Split('+')[0]
$AppName = "myreportbd-desktop"

Write-Host "==> flutter build windows --release"
flutter build windows --release

$BundleDir = Join-Path $Root "build\windows\x64\runner\Release"
$DistDir = Join-Path $Root "dist"
New-Item -ItemType Directory -Force -Path $DistDir | Out-Null

$ZipPath = Join-Path $DistDir "$AppName-$Version-windows-x64.zip"
if (Test-Path $ZipPath) { Remove-Item $ZipPath }

Write-Host "==> Zipping release bundle"
Compress-Archive -Path "$BundleDir\*" -DestinationPath $ZipPath

Write-Host "    -> $ZipPath"
Write-Host "Note: this is an unsigned, portable zip (no installer). Unzip and run myreportbd_desktop.exe."
