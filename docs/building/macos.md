# Building for macOS

Must run **on macOS** — Flutter cannot cross-compile a macOS desktop
build from Linux or Windows. Produces a zipped, unsigned `.app`.

## Prerequisites

### Xcode command-line tools

```bash
xcode-select --install
```

A full Xcode install from the App Store is needed too (not just the
command-line tools) for desktop builds — the command above alone covers
`clang`/`make`, but `flutter doctor` will tell you if Xcode itself is
still missing.

### Flutter SDK

```bash
git clone --depth 1 -b stable https://github.com/flutter/flutter.git ~/flutter
export PATH="$HOME/flutter/bin:$PATH"   # add to your shell profile (~/.zshrc) to persist
flutter doctor
```

(Alternatively: `brew install --cask flutter` if you use Homebrew.)

Run `flutter doctor` and resolve anything it flags (accepting the Xcode
license with `sudo xcodebuild -license` is a common one-time step).

## Build

```bash
flutter doctor
chmod +x scripts/build_macos.sh   # if not already executable
scripts/build_macos.sh
```

Output: `dist/myreportbd-desktop-<version>-macos.zip`

The unpackaged `.app` is also left at
`build/macos/Build/Products/Release/*.app` if you want to run or
inspect it directly.

## Installing / running the result

Unzip and drag the `.app` into `/Applications` (or just double-click it
in place). Because it's unsigned and not notarized, Gatekeeper will
refuse to open it with a normal double-click the first time — right-click
the app → **Open** → **Open** again in the confirmation dialog. After
that first approval it opens normally.

## Signing and notarization (not set up here)

This build is unsigned. For wider distribution (so users don't hit the
Gatekeeper warning at all), you'd need:

1. An Apple Developer account ($99/year).
2. A "Developer ID Application" certificate in your keychain.
3. `codesign --deep --force --sign "Developer ID Application: ..." YourApp.app`
4. Notarizing via `xcrun notarytool submit` and stapling the ticket with
   `xcrun stapler staple`.

None of that is wired into `build_macos.sh` — it's a plain unsigned
build intended for local testing or distribution to people willing to
click through the Gatekeeper prompt.

## Troubleshooting

- **`flutter doctor` shows a Xcode license error** — run
  `sudo xcodebuild -license` and accept it.
- **"No .app bundle found" from the script** — check the `flutter build
  macos --release` step above it actually succeeded; a failed build
  won't produce anything under `build/macos/Build/Products/Release/`.
- **Gatekeeper still blocks it after right-click → Open** — go to
  **System Settings → Privacy & Security** and look for an "Open
  Anyway" button near the bottom of that page.
