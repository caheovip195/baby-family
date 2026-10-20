import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:share_plus/share_plus.dart';

/// ONB-07 — mời bạn đời (bắt buộc, không có “Để sau”). Chia sẻ/sao chép xong
/// → ONB-WAIT.
final onboardingInvitePartnerControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingInvitePartnerController>(
      OnboardingInvitePartnerController.new,
    );

class OnboardingInvitePartnerController extends BaseNotifier {
  OnboardingInvitePartnerController(super.ref) {
    load();
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  InviteInfo? invite;

  /// “Tôi xác nhận lần cuối khi {Papa} tham gia” — mặc định bật (9.2).
  bool requireApproval = true;

  /// Thời lượng dùng thử (ngày) theo trial policy của catalog; giá trị mặc
  /// định tới khi tải xong (BF-20261013-005).
  int trialDays = kValueDefaultTrialDuration.inDays;

  String get partnerCallName {
    final value = invite?.callName;
    if (value != null && value.isNotEmpty) {
      return value;
    }
    final role = sessionService.current.role ?? FamilyRole.mother;
    return role.partnerRole == FamilyRole.father
        ? kValueDefaultCallNameFather
        : kValueDefaultCallNameMother;
  }

  Future<void> load() async {
    final (value, duration) = await (
      sessionService.partnerInvite(),
      ref.read(familyServiceProvider).trialDuration(),
    ).wait;
    if (isDisposed) {
      return;
    }
    invite = value;
    trialDays = duration.inDays;
    notifyListeners();
  }

  void toggleApproval(bool value) {
    requireApproval = value;
    notifyListeners();
  }

  /// Đánh dấu đã gửi và trả về link mời.
  Future<String> markSent() async {
    await sessionService.markPartnerInviteSent(
      requireApproval: requireApproval,
    );
    final value = await sessionService.partnerInvite();
    if (!isDisposed && value != null) {
      invite = value;
    }
    return value?.link ?? '';
  }

  /// Mở bảng chia sẻ hệ thống (Zalo, Messenger…); bỏ qua lỗi nền tảng.
  Future<void> share(String message) async {
    await whileLoading(() async {
      try {
        await SharePlus.instance.share(ShareParams(text: message));
      } on Object catch (error) {
        debugPrint('share invite failed: $error');
      }
    });
  }
}
