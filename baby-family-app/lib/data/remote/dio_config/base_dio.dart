import 'package:dio/dio.dart';

abstract class BaseDio with DioMixin {
  BaseDio(String url) {
    options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      baseUrl: url,
      headers: {'accept': 'application/json'},
    );
  }
}
