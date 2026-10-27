import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Mở trình gọi điện của máy với số [number] (US-13 đường dây hỗ trợ). Không
/// gửi gì lên server, không ghi lịch sử. Trả `false` khi máy không mở được
/// (máy tính bảng không có SIM, môi trường test).
Future<bool> launchPhoneCall(String number) =>
    _launch(Uri(scheme: 'tel', path: number));

/// Mở ứng dụng nhắn tin của máy để tự chọn người nhận (US-13 “Liên hệ một
/// người bạn tin cậy”) — app không biết và không lưu người được liên hệ.
Future<bool> launchMessages() => _launch(Uri(scheme: 'sms'));

/// Mở link tải (SET-08 bản xuất dữ liệu) bằng trình duyệt của máy.
Future<bool> launchExternalUrl(String url) {
  final uri = Uri.tryParse(url);
  return uri == null ? Future.value(false) : _launch(uri);
}

/// Mở bảng chia sẻ hệ thống (Zalo, Messenger…) với [text]; lỗi nền tảng
/// (test, máy không hỗ trợ) bỏ qua. FAM-03/05 gửi link mời người thân.
Future<void> shareText(String text) async {
  try {
    await SharePlus.instance.share(ShareParams(text: text));
  } on Object catch (error) {
    debugPrint('share failed: $error');
  }
}

Future<bool> _launch(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Object {
    return false;
  }
}
