import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LogInterceptor extends QueuedInterceptorsWrapper {
  final _logger = Logger();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      'DIO ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}',
    );
    _logger.e('Error Type: ${err.type}');
    _logger.e('Error Message: ${err.message}');

    // QUAN TRỌNG: Log toàn bộ response data để xem server trả về gì
    if (err.response != null) {
      _logger.e('Response Status: ${err.response?.statusCode}');
      _logger.e(
        'Response Data: ${err.response?.data}',
      ); // Dòng này sẽ cho bạn biết lỗi là gì
    }
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('REQUEST: ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d(
      'RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
    );
    handler.next(response);
  }
}
