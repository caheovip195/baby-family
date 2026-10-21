import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/user_cancelled.dart';
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

/// Chạy thao tác gọi server; lỗi → snack bar theo [actionErrorMessage].
/// Trả `true` khi thành công để view quyết định có điều hướng tiếp không.
Future<bool> runWithErrorSnackBar(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
    return true;
  } on UserCancelled {
    return false;
  } on Object catch (error) {
    if (context.mounted) {
      showAppSnackBar(context, actionErrorMessage(error));
    }
    return false;
  }
}
