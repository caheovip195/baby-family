FVM := fvm
FLUTTER := $(FVM) flutter
DART := $(FVM) dart

.PHONY: setup get clean force runner l10n w format analyze test check \
	stg-run pro-run stg-apk pro-apk pro-aab stg-ipa pro-ipa icon

## Cài đúng Flutter của project (.fvmrc) và tải package
setup:
	dart pub global activate fvm
	$(FVM) install
	$(FLUTTER) pub get

get:
	$(FLUTTER) pub get

clean:
	$(FLUTTER) clean
	$(FLUTTER) pub get

## Dọn sạch cache iOS + Flutter (plugin iOS dùng Swift Package Manager, không CocoaPods)
force:
	rm -rf ~/Library/Developer/Xcode/DerivedData/ || true
	$(FLUTTER) clean
	$(FLUTTER) pub get

## Sinh code: freezed, json_serializable, retrofit, auto_route, flutter_gen
runner:
	$(DART) run build_runner build

## Sinh AppLocalizations từ lib/l10n/arb (l10n.yaml)
l10n:
	$(FLUTTER) gen-l10n

w:
	$(DART) run build_runner watch

format:
	$(DART) format lib test

analyze:
	$(FLUTTER) analyze

test:
	$(FLUTTER) test

## Chạy trước khi tạo MR
check: l10n format analyze test

## --- Chạy debug ---
stg-run:
	$(FLUTTER) run --debug -t lib/main_dev.dart --flavor staging

pro-run:
	$(FLUTTER) run --debug -t lib/main_pro.dart --flavor product

## --- Build release ---
stg-apk:
	$(FLUTTER) build apk --release -t lib/main_dev.dart --flavor staging --obfuscate --split-debug-info=build/symbols/staging

pro-apk:
	$(FLUTTER) build apk --release -t lib/main_pro.dart --flavor product --obfuscate --split-debug-info=build/symbols/product

pro-aab:
	$(FLUTTER) build appbundle --release -t lib/main_pro.dart --flavor product --obfuscate --split-debug-info=build/symbols/product

stg-ipa:
	$(FLUTTER) build ipa --release -t lib/main_dev.dart --flavor staging --obfuscate --split-debug-info=build/symbols/staging

pro-ipa:
	$(FLUTTER) build ipa --release -t lib/main_pro.dart --flavor product --obfuscate --split-debug-info=build/symbols/product

## Icon & splash (cấu hình trong pubspec khi có ảnh assets/images/app_icon.png)
icon:
	$(DART) run flutter_launcher_icons
	$(DART) run flutter_native_splash:create
