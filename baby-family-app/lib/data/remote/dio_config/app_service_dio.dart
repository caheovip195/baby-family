import 'package:baby_family/utils/helper/flavor_config.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../app_client/app_client.dart';
import '../interceptor/authorization_interceptor.dart';
import '../interceptor/base_interceptor.dart';
import '../interceptor/debug_interceptor.dart';
import '../interceptor/device_interceptor.dart';
import '../interceptor/error_interceptor.dart';
import 'base_dio.dart';

/// Dio của API Baby Family. Media upload/download KHÔNG đi qua đây — dùng
/// presigned URL trực tiếp tới object storage (tài liệu kỹ thuật mục 10).
class AppServiceDio extends BaseDio {
  AppServiceDio(super.url) {
    interceptors.add(DeviceInterceptor());
    interceptors.add(AuthorizationInterceptor());
    if (kDebugMode) {
      interceptors.add(LogInterceptor());
    }
    interceptors.add(ErrorHandleInterceptor());
    interceptors.add(BaseInterceptor());
    httpClientAdapter = IOHttpClientAdapter();
  }

  static AppServiceDio? _instance;

  static AppClient? _appClient;

  static AppServiceDio? getInstance() => _instance;

  static AppClient? get appClient => _appClient;

  static void setAppClient({bool isClear = false}) {
    if (isClear) {
      _instance = null;
      _appClient = null;
    }
    _instance ??= AppServiceDio(FlavorConfig.instance.endPoint);
    _appClient ??= AppClient(_instance!);
  }
}
