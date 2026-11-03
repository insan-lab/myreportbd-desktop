# Building for Linux

Produces a `.deb` (Debian/Ubuntu and derivatives) and/or an Arch package
(`.pkg.tar.zst`), via `scripts/build_linux.sh`.

## Prerequisites

### Flutter SDK

```bash
git clone --depth 1 -b stable https://github.com/flutter/flutter.git ~/flutter
export PATH="$HOME/flutter/bin:$PATH"   # add to your shell profile to persist
flutter doctor
```

### Debian / Ubuntu and derivatives

```bash
sudo apt-get update && sudo apt-get install -y \
  clang cmake ninja-build pkg-config libgtk-3-dev \
  liblzma-dev libstdc++-12-dev
```

`dpkg-deb` is already part of the base system — nothing extra needed to
produce the `.deb`.

### Arch and derivatives

```bash
sudo pacman -S --needed base-devel clang cmake ninja pkgconf gtk3
```

`makepkg` comes with `base-devel`.

## Build

```bash
flutter doctor        # confirm the Linux toolchain shows a green check
scripts/build_linux.sh
```

With no flags, the script packages for whichever of `dpkg-deb` /
`makepkg` is present on the machine you're running it on. Force one or
both explicitly:

```bash
scripts/build_linux.sh --deb     # only .deb
scripts/build_linux.sh --arch    # only Arch package
scripts/build_linux.sh --all     # both (needs both tools installed)
```

Output lands in `dist/`:

- `dist/myreportbd-desktop_<version>_amd64.deb`
- `dist/myreportbd-desktop-<version>-*.pkg.tar.zst`

The unpackaged release bundle is also left at
`build/linux/x64/release/bundle/` if you just want to run it directly
(`./build/linux/x64/release/bundle/myreportbd_desktop`).

## Installing the result

```bash
# Debian/Ubuntu
sudo dpkg -i dist/myreportbd-desktop_*_amd64.deb
# or: sudo apt-get install ./dist/myreportbd-desktop_*_amd64.deb (resolves deps automatically)

# Arch
sudo pacman -U dist/myreportbd-desktop-*.pkg.tar.zst
```

Both install to `/opt/myreportbd-desktop/` with a `myreportbd-desktop`
launcher symlinked into `/usr/bin/` and a desktop entry so it shows up
in your application menu.

## Troubleshooting

- **`flutter doctor` shows Linux toolchain errors** — you're missing one
  of `clang`/`cmake`/`ninja`; install via the commands above for your
  distro.
- **`dpkg-deb: command not found`** on a non-Debian system — expected;
  use `--arch` instead, or build on a Debian-based machine.
- **`makepkg: command not found`** on a non-Arch system — expected; use
  `--deb` instead, or build on an Arch-based machine.
- **GTK runtime errors at launch on a fresh machine** — the `.deb`
  declares `Depends: libgtk-3-0, libsqlite3-0` so a package-manager
  install pulls them in; a bare `build/linux/.../bundle` run requires
  those libraries to already be present on the system.
