import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/external_launcher.dart';
import 'package:hooks_riverpod/legacy.dart';

/// FAM-05 — Lời mời người thân đang chờ / đã hết hạn: gửi lại link, thu hồi,
/// tạo lời mời mới (14 ngày). Số chỗ = người thân đang tham gia + lời mời
/// đang chờ (tối đa theo gói).
final pendingInvitesControllerProvider =
    ChangeNotifierProvider.autoDispose<PendingInvitesController>(
      PendingInvitesController.new,
    );

class PendingInvitesController extends BaseNotifier {
  PendingInvitesController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  IFamilyService get familyService => ref.read(familyServiceProvider);

  List<InviteInfo>? invites;
  List<Member> members = const [];
  List<Child> children = const [];
  Family? family;
  bool hasError = false;

  DateTime get today => ref.read(todayProvider);

  List<InviteInfo> get pending => [
    for (final invite in invites ?? const <InviteInfo>[])
      if (invite.status == 'open' || invite.status == 'pendingApproval') invite,
  ];

  List<InviteInfo> get expired => [
    for (final invite in invites ?? const <InviteInfo>[])
      if (invite.status == 'expired') invite,
  ];

  int get activeRelatives => members
      .where(
        (m) => m.role == FamilyRole.relative && m.status == MemberStatus.active,
      )
      .length;

  int get slotsMax => family?.plan.relativeSlotsMax ?? 0;

  String callNameOf(FamilyRole role) =>
      members.where((m) => m.role == role).firstOrNull?.callName ?? '';

  List<String> childNames(InviteInfo invite) => [
    for (final child in children)
      if (invite.grantedChildIds.contains(child.id)) child.name,
  ];

  Future<void> load() async {
    hasError = false;
    try {
      final results = await Future.wait<Object?>([
        familyService.relativeInvites(),
        familyService.members(),
        ref.read(childServiceProvider).children(),
        familyService.currentFamily(),
      ]);
      if (isDisposed) {
        return;
      }
      invites = results[0]! as List<InviteInfo>;
      members = results[1]! as List<Member>;
      children = results[2]! as List<Child>;
      family = results[3] as Family?;
    } on Object {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  /// FAM-05 “Gửi lại link”: mở lại bảng chia sẻ với [message] (server không
  /// tự gửi cho người thân — BF-20261026-004), rồi ghi lần gửi.
  Future<void> resend(InviteInfo invite, String message) async {
    if (invite.code.isNotEmpty) {
      await shareText(message);
    }
    await familyService.resendInvite(invite.id);
  }

  Future<void> revoke(InviteInfo invite) async {
    await familyService.revokeInvite(invite.id);
    await load();
  }

  Future<void> renew(InviteInfo invite) async {
    await familyService.renewInvite(invite.id);
    await load();
  }
}
