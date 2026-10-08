// Placeholder — chạy `flutterfire configure` để sinh file thật cho flavor này
// (staging: firebase_options_stg.dart, product: firebase_options_pro.dart).
// Khi chưa cấu hình, `_setupFirebase` bắt lỗi và app vẫn chạy (không có push,
// không có Crashlytics).
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase chưa được cấu hình. Chạy `flutterfire configure`.',
    );
  }
}
