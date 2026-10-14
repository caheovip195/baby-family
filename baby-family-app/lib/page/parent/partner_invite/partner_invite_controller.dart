import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:share_plus/share_plus.dart';

/// FAM-02 — Mời bạn đời (sau khi bạn đời rời — seed `partnerLeft`): mã mời
/// mới, chọn vai trò, xem trước những gì người nhận thấy, xác nhận lần cuối,
/// chia sẻ / sao chép / thu hồi lời mời.
final partnerInviteControllerProvider =
    ChangeNotifierProvider.autoDispose<PartnerInviteController>(
      PartnerInviteController.new,
    );

class PartnerInviteController extends BaseNotifier {
  PartnerInviteController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  IFamilyService get familyService => ref.read(familyServiceProvider);

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  InviteInfo? invite;
  Family? family;
  Member? me;
  List<Child> children = const [];
  FamilyRole role = FamilyRole.father;
  bool requireApproval = true;
  bool loaded = false;
  bool hasError = false;

  /// Tên gọi mặc định của bạn đời đã rời (“Papa đã rời Nhà Lan…”).
  String get leftPartnerCallName =>
      (me?.role ?? FamilyRole.mother).partnerRole == FamilyRole.mother
      ? kValueDefaultCallNameMother
      : kValueDefaultCallNameFather;

  bool get partnerLeft => family?.partnerLeftAt != null;

  Future<void> load() async {
    hasError = false;
    try {
      final results = await Future.wait<Object?>([
        sessionService.partnerInvite(),
        familyService.currentFamily(),
        familyService.me(),
        ref.read(childServiceProvider).children(),
      ]);
      if (isDisposed) {
        return;
      }
      final value = results[0] as InviteInfo?;
      if (!loaded && value != null) {
        role = value.role == FamilyRole.mother
            ? FamilyRole.mother
            : FamilyRole.father;
        requireApproval = value.requiresApproval;
      }
      invite = value;
      family = results[1] as Family?;
      me = results[2] as Member?;
      children = results[3]! as List<Child>;
      loaded = true;
    } on Object {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  void selectRole(FamilyRole value) {
    role = value;
    notifyListeners();
  }

  void toggleApproval(bool value) {
    requireApproval = value;
    notifyListeners();
  }

  /// Đánh dấu đã gửi và trả về link mời.
  Future<String> markSent() async {
    await sessionService.markPartnerInviteSent();
    final value = await sessionService.partnerInvite();
    return value?.link ?? invite?.link ?? '';
  }

  /// Mở bảng chia sẻ hệ thống (Zalo, Messenger…); bỏ qua lỗi nền tảng.
  Future<void> share(String message) async {
    await whileLoading(() async {
      try {
        await SharePlus.instance.share(ShareParams(text: message));
      } on Object catch (error) {
        debugPrint('share partner invite failed: $error');
      }
    });
  }

  Future<void> revoke() async {
    final value = invite;
    if (value == null) {
      return;
    }
    await familyService.revokeInvite(value.id);
  }
}
