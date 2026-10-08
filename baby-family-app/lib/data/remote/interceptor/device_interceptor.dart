import 'package:baby_family/data/remote/request_options.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:baby_family/utils/helper/device.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// Header chung (tài liệu kỹ thuật 11.1): `X-Request-Id`, `X-Platform`,
/// `X-App-Version`, `Accept-Language`; `X-Device-Id` khi method
/// Retrofit gắn `RequestOptionsExtra.deviceReq`.
class DeviceInterceptor extends QueuedInterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final device = DeviceFactory().deviceInfo;
    final headers = options.headers;
    headers['X-Request-Id'] = const Uuid().v4();
    headers['X-Platform'] = device.deviceType?.name;
    headers['X-App-Version'] = device.appVersion;
    // TODO(team): gửi `X-Timezone` dạng IANA (Asia/Ho_Chi_Minh) khi thêm
    // package lấy timezone thiết bị.
    // Server trả message lỗi / nội dung catalog theo ngôn ngữ này.
    headers['Accept-Language'] = currentAppLanguage().code;
    if (options.extra[RequestOptionsExtra.deviceReq] == true) {
      headers['X-Device-Id'] = device.deviceId;
    }
    options.headers = headers;
    handler.next(options);
  }
}
