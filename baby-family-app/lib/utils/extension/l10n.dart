import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension L10nContextExt on BuildContext {
  /// `context.l10n.commonContinue` — mọi chuỗi hiển thị phải lấy từ đây.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Mã ngôn ngữ đang hiển thị (`vi`, `en`) — dùng cho `DateFormat`,
  /// `NumberFormat`.
  String get localeName => AppLocalizations.of(this).localeName;
}
