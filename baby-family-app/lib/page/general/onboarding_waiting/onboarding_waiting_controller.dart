import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:share_plus/share_plus.dart';

/// ONB-WAIT — chờ bạn đời: trạng thái lời mời, gửi lại, hiện QR, huỷ gia đình.
/// Bản mock: “Mô phỏng bạn đời tham gia” → ONB-ACT.
final onboardingWaitingControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingWaitingController>(
      OnboardingWaitingController.new,
    );

class OnboardingWaitingController extends BaseNotifier {
  OnboardingWaitingController(super.ref) {
    load();
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  Family? family;
  InviteInfo? invite;

  /// Thời lượng dùng thử (ngày) theo trial policy của catalog; giá trị mặc
  /// định tới khi tải xong (BF-20261013-005).
  int trialDays = kValueDefaultTrialDuration.inDays;

  DateTime get now => ref.read(appClockProvider).now();

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

  /// Số ngày còn lại của lời mời (làm tròn xuống), null nếu chưa có hạn.
  int? get daysLeft {
    final expiresAt = invite?.expiresAt;
    if (expiresAt == null) {
      return null;
    }
    final days = expiresAt.difference(now).inDays;
    return days < 0 ? 0 : days;
  }

  Future<void> load() async {
    final familyService = ref.read(familyServiceProvider);
    final (currentFamily, partnerInvite, duration) = await (
      familyService.currentFamily(),
      sessionService.partnerInvite(),
      familyService.trialDuration(),
    ).wait;
    if (isDisposed) {
      return;
    }
    family = currentFamily;
    invite = partnerInvite;
    trialDays = duration.inDays;
    notifyListeners();
  }

  /// “Gửi lại lời mời”: đánh dấu đã gửi + mở bảng chia sẻ.
  Future<void> resend(String Function(String code, String link) message) async {
    await whileLoading(() async {
      await sessionService.markPartnerInviteSent();
      final value = await sessionService.partnerInvite();
      if (value != null) {
        invite = value;
        try {
          await SharePlus.instance.share(
            ShareParams(text: message(value.code, value.link ?? '')),
          );
        } on Object catch (error) {
          debugPrint('share invite failed: $error');
        }
      }
    });
  }

  Future<void> simulateJoined() async {
    await whileLoading(() async {
      await sessionService.simulatePartnerJoined();
    });
  }

  Future<void> cancelFamily() async {
    await whileLoading(() async {
      await sessionService.cancelFamily();
    });
  }
}
