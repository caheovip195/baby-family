import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _channel = MethodChannel('dev.fluttercommunity.plus/share');

/// Ghi lại nội dung gửi tới bảng chia sẻ hệ thống (share_plus) trong test.
List<String> captureShares() {
  final shared = <String>[];
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(_channel, (call) async {
    final args = call.arguments;
    if (args is Map && args['text'] is String) {
      shared.add(args['text'] as String);
    }
    return 'dev.fluttercommunity.plus/share/success';
  });
  addTearDown(() => messenger.setMockMethodCallHandler(_channel, null));
  return shared;
}
