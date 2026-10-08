part of '../enum.dart';

enum Flavor {
  dev(endPoint: 'https://api-staging.babyfamily.vn'),
  pro(endPoint: 'https://api.babyfamily.vn');

  const Flavor({required this.endPoint});

  /// Base URL của API chính (đường dẫn `/v1/...` nằm ở `Api`).
  final String endPoint;
}
