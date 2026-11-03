# Build scripts

Full build instructions (prerequisites, flags, troubleshooting) are in
[`docs/building/`](../docs/building/README.md) — one guide per platform.
Quick reference:

| Script | Run on | Output |
|---|---|---|
| `build_linux.sh` | Linux | `dist/*.deb` and/or `dist/*.pkg.tar.zst` |
| `build_windows.ps1` | Windows | `dist/*-windows-x64.zip` |
| `build_macos.sh` | macOS | `dist/*-macos.zip` (unsigned) |

Flutter desktop builds aren't cross-compilable — each script must run
on a machine actually running that target OS.
