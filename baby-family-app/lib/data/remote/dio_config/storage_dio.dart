import 'package:dio/io.dart';

import 'base_dio.dart';

/// Dio tải bytes lên presigned URL của object storage (tài liệu kỹ thuật
/// 10.2). Không có interceptor xác thực: URL đã được server ký, gửi kèm
/// Authorization sẽ làm hỏng chữ ký.
class StorageDio extends BaseDio {
  StorageDio() : super('') {
    httpClientAdapter = IOHttpClientAdapter();
    options = options.copyWith(
      sendTimeout: const Duration(minutes: 5),
      headers: const <String, dynamic>{},
    );
  }

  static final StorageDio instance = StorageDio();
}
