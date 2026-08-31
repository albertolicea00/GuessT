# Contributing

## Setup

1. Install Flutter (stable channel).
2. `make get` — runs `flutter pub get`, which also regenerates
   `lib/l10n/generated/app_localizations.dart` from the ARB files
   (`generate: true` is set in `pubspec.yaml`).
3. `make run`

If `pub get` complains about the `intl` version: run `flutter pub add
intl` and let it pick the version matching your SDK. Flutter pins an
exact `intl` version per release, so a hand-set constraint in
`pubspec.yaml` can drift out of sync after a Flutter upgrade.

On macOS, if `flutter run`/`flutter test` fail with "The Dart compiler
exited unexpectedly": Gatekeeper likely quarantined the freshly
downloaded SDK binaries. Fix with:
```
xattr -dr com.apple.quarantine "$(dirname "$(dirname "$(which flutter)")")"/../cache
```
or more simply, locate your Flutter SDK root (`flutter --version` or
`which flutter`) and run `xattr -dr com.apple.quarantine <sdk-root>/bin/cache`.

## Makefile

A `Makefile` wraps the common commands — run `make help` for the full
list, or `make` with no target for the same.

| Target | Does |
| --- | --- |
| `make get` | `flutter pub get` |
| `make l10n` | regenerate localization code from `lib/l10n/*.arb` |
| `make analyze` | `flutter analyze` |
| `make test` | `flutter test` |
| `make format` | `dart format lib test` |
| `make check` | `get` + `analyze` + `test` — run before committing |
| `make doctor` | `flutter doctor -v` |
| `make devices` | list available run targets |
| `make clean` | `flutter clean` |
| `make run` / `run-ios` / `run-android` / `run-macos` / `run-web` | launch on a given target |
| `make build-apk` / `build-appbundle` / `build-ios` / `build-macos` / `build-web` | release builds |

## Conventions

- Relative imports only within `lib/` — no `package:guesst/...` imports.
- No UI string literals in screens or widgets. Every user-facing string
  goes through `AppLocalizations.of(context)!`, sourced from
  `lib/l10n/app_en.arb` (English is the template/source of truth —
  translate into the other `app_<code>.arb` files from there).
- Game content (category names, word lists) stays out of the ARB
  files — it lives in `lib/data/word_data_<lang>.dart`.
- No comments except where a non-obvious constraint needs explaining
  (see `tilt_controller.dart` for the pattern).

## Common tasks

### Add a game mode

1. Add a `GameModeId` value + `GameModeConfig` entry in
   `lib/models/game_mode.dart`.
2. Add `mode<Name>Name` / `Tagline` / `Description` keys to
   `app_en.arb` and `app_es.arb`.
3. Add the matching `case` in `lib/models/game_mode_text.dart`.

### Add a word category

1. Add a `WordCategoryMeta` entry in `lib/data/categories.dart`.
2. Add its name and words to every `word_data_<lang>.dart` file.
   English is required; other languages fall back to English for
   anything they're missing.

### Add a language

1. Copy `app_en.arb` to `app_<code>.arb` and translate every value
   (keep placeholders like `{count}` and plural syntax intact).
2. Create `word_data_<code>.dart` with category names and word lists.
3. Register both new maps in `lib/data/word_repository.dart`.
4. `flutter pub get` picks up the new locale automatically.

### ARB file syntax

`app_en.arb` / `app_es.arb` are plain JSON — every value line except a
file's last one needs a trailing comma, or `flutter gen-l10n` fails to
parse the file and the build breaks. Validate before committing:

```
python3 -c "import json; json.load(open('lib/l10n/app_en.arb'))"
```

## Before calling a change done

Run `make check` (`pub get` + `analyze` + `test`). Don't assume a
change compiles just because it reads correctly.
