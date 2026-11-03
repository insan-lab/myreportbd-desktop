# Building for Windows

Must run **on Windows** — Flutter cannot cross-compile a Windows desktop
build from Linux or macOS. Produces a portable `.zip`.

## Prerequisites

### Flutter SDK

1. Download the Flutter SDK zip from https://docs.flutter.dev/get-started/install/windows
   and extract it somewhere like `C:\src\flutter`.
2. Add `C:\src\flutter\bin` to your `PATH`.
3. Run `flutter doctor` in a new terminal to confirm it's picked up.

### Visual Studio

Install [Visual Studio](https://visualstudio.microsoft.com/downloads/)
(the free Community edition is fine) with the **"Desktop development
with C++"** workload selected. This provides the MSVC toolchain Flutter
needs for Windows builds.

Run `flutter doctor` again afterwards — the "Visual Studio" check should
go green.

## Build

From PowerShell, in the project root:

```powershell
flutter doctor
powershell -ExecutionPolicy Bypass -File scripts\build_windows.ps1
```

Output: `dist\myreportbd-desktop-<version>-windows-x64.zip`

The unpackaged release build is also left at
`build\windows\x64\runner\Release\` if you want to run it directly
(`myreportbd_desktop.exe` in that folder).

## Installing / running the result

Unzip `dist\myreportbd-desktop-*-windows-x64.zip` anywhere and run
`myreportbd_desktop.exe` from inside the extracted folder — it's a
portable build, there's no installer and nothing is written outside
that folder except the app's own SQLite database (in the user's
`%APPDATA%` via `sqflite_common_ffi`'s default database path).

## Notes

- This zip is **unsigned**. Windows SmartScreen may warn on first run
  ("Windows protected your PC") — click "More info" → "Run anyway".
  Code-signing would need a certificate, which isn't set up here.
- There's no MSI/EXE installer here, just a portable zip. If you need a
  proper installer later, look at
  [Inno Setup](https://jrsoftware.org/isinfo.php) or the
  [`msix`](https://pub.dev/packages/msix) Flutter package — neither is
  wired up in this project yet.

## Troubleshooting

- **`flutter doctor` complains about Visual Studio** — make sure the
  "Desktop development with C++" workload (not just the IDE) is
  installed; open the Visual Studio Installer and modify your
  installation if needed.
- **`Compress-Archive` errors about long paths** — rare, but if it
  happens, build from a shorter path (e.g. `C:\dev\myreportbd` instead
  of a deeply nested folder).
