import 'package:baby_family/utils/extension/l10n.dart';
import 'package:flutter/material.dart';

/// Thông báo nhẹ, không chặn thao tác (theme `snackBarTheme` floating).
/// Thay snack bar đang hiện để các lần chạm liên tiếp không xếp hàng.
void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// “Sắp ra mắt” cho lối vào chưa có màn hình (US-06/07/08/14/15…).
void showComingSoonSnackBar(BuildContext context) =>
    showAppSnackBar(context, context.l10n.commonComingSoon);
