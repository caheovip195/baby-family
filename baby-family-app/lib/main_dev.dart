import 'dart:async';

import 'package:baby_family/data/remote/dio_config/app_service_dio.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:baby_family/utils/helper/application_directory.dart';
import 'package:baby_family/utils/helper/device.dart';
import 'package:baby_family/utils/helper/error_report_policy.dart';
import 'package:baby_family/utils/helper/flavor_config.dart';
import 'package:baby_family/utils/helper/local_store.dart';
import 'package:baby_family/utils/widget/startup_error_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'firebase_options/firebase_options_stg.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final startupError = await _initial();
      runApp(
        startupError == null
            ? const ProviderScope(child: RootApp())
            : StartupErrorApp(message: startupError),
      );
    },
    (error, stackTrace) {
      Logger().e(
        'Uncaught application error',
        error: error,
        stackTrace: stackTrace,
      );
      unawaited(_recordFirebaseError(error, stackTrace, fatal: true));
    },
  );
}

/// Khởi tạo app. Trả về `null` nếu thành công, hoặc mô tả lỗi để hiển thị lên
/// màn [StartupErrorApp] thay cho màn trắng.
Future<String?> _initial() async {
  try {
    FlavorConfig.of(Flavor.dev);
    await ApplicationDirectory().init();
    await LocalStore().init();
    await DeviceFactory().init();
    for (final language in AppLanguage.values) {
      await initializeDateFormatting(language.code);
    }
    Intl.defaultLocale = currentAppLanguage().code;
    AppServiceDio.setAppClient();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await _setupFirebase();
    return null;
  } catch (error, stackTrace) {
    Logger().e(
      'App initialization failed',
      error: error,
      stackTrace: stackTrace,
    );
    unawaited(_recordFirebaseError(error, stackTrace, fatal: true));
    return '${error.runtimeType}: $error';
  }
}

Future<void> _setupFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      unawaited(
        _recordFirebaseError(details.exception, details.stack, fatal: true),
      );
    };
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      unawaited(_recordFirebaseError(error, stackTrace, fatal: true));
      return true;
    };
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      !kDebugMode,
    );
    // Xin quyền thông báo KHÔNG ở đây — xin đúng lúc ở ONB-10
    // (tài liệu nghiệp vụ 9.2).
  } catch (error, stackTrace) {
    Logger().w(
      'Firebase initialization skipped',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

Future<void> _recordFirebaseError(
  Object error,
  StackTrace? stackTrace, {
  required bool fatal,
}) async {
  try {
    if (Firebase.apps.isEmpty) {
      return;
    }
    // Lỗi mạng/plugin đã biết vẫn ghi nhận nhưng ở mức non-fatal.
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: fatal && isFatalAppError(error),
    );
  } catch (_) {}
}
