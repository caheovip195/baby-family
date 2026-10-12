import 'package:baby_family/data/dto/onboarding_samples.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:share_plus/share_plus.dart';

/// CIR-WAIT — người thân chưa có lời mời: nhập mã, quét QR, nhờ con mời, hoặc
/// quay lại chọn vai trò Papa/Mama.
final circleWaitingControllerProvider =
    ChangeNotifierProvider.autoDispose<CircleWaitingController>(
      CircleWaitingController.new,
    );

class CircleWaitingController extends BaseNotifier {
  CircleWaitingController(super.ref) {
    loadSamples();
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  /// Giá trị mẫu điền sẵn (tải sau khi mock store sẵn sàng).
  OnboardingSamples samples = const OnboardingSamples();
  bool samplesLoaded = false;

  Future<void> loadSamples() async {
    final value = await sessionService.samples();
    if (isDisposed) {
      return;
    }
    samples = value;
    samplesLoaded = true;
    notifyListeners();
  }

  /// Mã người thân mẫu (giả lập quét QR).
  String get sampleCode => samples.relativeInviteCode;

  /// “Nhờ con mời mình” — bảng chia sẻ với tin nhắn soạn sẵn.
  Future<void> askChild(String message) async {
    try {
      await SharePlus.instance.share(ShareParams(text: message));
    } on Object catch (error) {
      debugPrint('share ask-invite failed: $error');
    }
  }

  /// “Tôi là Papa/Mama của bé” → chọn lại vai trò (ONB-03).
  Future<void> switchRole() async {
    await whileLoading(sessionService.cancelFamily);
  }
}
