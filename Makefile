FLUTTER ?= flutter
DART ?= dart

.PHONY: help get l10n analyze test format doctor devices clean \
        run run-ios run-android run-macos run-web \
        build-apk build-appbundle build-ios build-macos build-web \
        check

help:
	@echo "GuessT — available targets:"
	@echo "  get             flutter pub get (also regenerates lib/l10n/generated)"
	@echo "  l10n            regenerate localization code from lib/l10n/*.arb"
	@echo "  analyze         flutter analyze"
	@echo "  test            flutter test"
	@echo "  format          dart format lib test"
	@echo "  check           get + analyze + test (run before committing)"
	@echo "  doctor          flutter doctor -v"
	@echo "  devices         list available run targets"
	@echo "  clean           flutter clean"
	@echo ""
	@echo "  run             flutter run (prompts for device if more than one)"
	@echo "  run-ios         run on a connected/simulated iOS device"
	@echo "  run-android     run on a connected/emulated Android device"
	@echo "  run-macos       run as a macOS desktop app"
	@echo "  run-web         run in Chrome"
	@echo ""
	@echo "  build-apk       release Android APK"
	@echo "  build-appbundle release Android App Bundle (Play Store)"
	@echo "  build-ios       release iOS build (requires signing setup)"
	@echo "  build-macos     release macOS app"
	@echo "  build-web       release web build"

get:
	$(FLUTTER) pub get

l10n:
	$(FLUTTER) gen-l10n

analyze:
	$(FLUTTER) analyze

test:
	$(FLUTTER) test

format:
	$(DART) format lib test

check: get analyze test

doctor:
	$(FLUTTER) doctor -v

devices:
	$(FLUTTER) devices

clean:
	$(FLUTTER) clean

run:
	$(FLUTTER) run

run-ios:
	$(FLUTTER) run -d ios

run-android:
	$(FLUTTER) run -d android

run-macos:
	$(FLUTTER) run -d macos

run-web:
	$(FLUTTER) run -d chrome

build-apk:
	$(FLUTTER) build apk --release

build-appbundle:
	$(FLUTTER) build appbundle --release

build-ios:
	$(FLUTTER) build ios --release

build-macos:
	$(FLUTTER) build macos --release

build-web:
	$(FLUTTER) build web --release
