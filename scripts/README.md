# Build scripts

Flutter desktop builds are **not cross-compilable** — each script must run
on a machine running that target OS (with Flutter installed there). There
is no way to produce a Windows `.exe` or macOS `.app` from this Linux dev
machine.

| Script | Run on | Requires | Produces |
|---|---|---|---|
| `build_linux.sh` | Linux | Flutter, GTK3 dev libs; `dpkg-deb` for `.deb`, `makepkg` for Arch pkg | `dist/*.deb` and/or `dist/*.pkg.tar.zst` |
| `build_windows.ps1` | Windows | Flutter, Visual Studio "Desktop development with C++" workload | `dist/*-windows-x64.zip` |
| `build_macos.sh` | macOS | Flutter, Xcode command-line tools | `dist/*-macos.zip` (unsigned) |

All outputs land in `dist/` at the project root.

```bash
# Linux — auto-detects dpkg-deb / makepkg, or force with flags:
scripts/build_linux.sh
scripts/build_linux.sh --deb
scripts/build_linux.sh --arch
scripts/build_linux.sh --all
```

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File scripts\build_windows.ps1
```

```bash
# macOS
scripts/build_macos.sh
```

The macOS build is unsigned and not notarized — fine for local testing,
but will trigger Gatekeeper warnings for other users. Codesigning and
notarization need an Apple Developer account and aren't set up here.
