import 'package:baby_family/data/dto/onboarding_samples.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// INV-05 — nhập mã mời 8 ký tự (mock: mọi mã đều mở được lời mời).
final inviteCodeControllerProvider =
    ChangeNotifierProvider.autoDispose<InviteCodeController>(
      InviteCodeController.new,
    );

class InviteCodeController extends BaseNotifier {
  InviteCodeController(super.ref) {
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

  /// Mã mẫu: người thân (CIR-WAIT) → mã Bà nội, còn lại → mã bạn đời.
  String get sampleCode {
    return sessionService.current.role == FamilyRole.relative
        ? samples.relativeInviteCode
        : samples.partnerInviteCode;
  }

  /// Thiết kế vẽ trạng thái đang gõ 6/8 ký tự.
  String get initialCode =>
      sampleCode.length > 6 ? sampleCode.substring(0, 6) : sampleCode;

  /// Mã dùng để mở lời mời: mã đã nhập, hoặc mã mẫu khi còn trống.
  String resolve(String typed) =>
      typed.trim().isEmpty ? sampleCode : typed.trim().toUpperCase();
}
