# Building MyReportBD for each platform

Flutter desktop builds are **not cross-compilable** — you must build on
the actual target OS. There's no way to produce a Windows `.exe` or
macOS `.app` from a Linux machine, or a Linux package from Windows, etc.

| Platform | Guide | Script | Output |
|---|---|---|---|
| Linux (Debian/Arch) | [linux.md](linux.md) | `scripts/build_linux.sh` | `.deb` and/or `.pkg.tar.zst` |
| Windows | [windows.md](windows.md) | `scripts/build_windows.ps1` | `.zip` (portable) |
| macOS | [macos.md](macos.md) | `scripts/build_macos.sh` | `.zip` (unsigned `.app`) |

All scripts write their output to `dist/` at the project root and leave
the raw, unpackaged build under `build/<platform>/...` as well.

In short, for whichever platform you're on:

```bash
flutter doctor        # confirm that platform's toolchain is green
scripts/build_<platform>.*
```

See the per-platform guide for the exact prerequisites and
troubleshooting notes.
