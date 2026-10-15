import 'package:baby_family/data/dto/invite_preview_data.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/legacy.dart';

/// INV-01 — xem lời mời: biến thể bạn đời (gTSrl, chọn tên gọi) hoặc người
/// thân (BSCuD, quyền với từng bé). “Tham gia” khi chưa đăng nhập → lưu lời
/// mời chờ rồi đăng nhập (AUTH-01…04 áp dụng); đã đăng nhập → áp dụng ngay.
/// Batch 3: các trạng thái INV-02/03/04 theo `InvitePreviewData.state`.
final invitePreviewControllerProvider = ChangeNotifierProvider.autoDispose
    .family<InvitePreviewController, String?>(InvitePreviewController.new);

class InvitePreviewController extends BaseNotifier {
  InvitePreviewController(super.ref, this.code) {
    load();
  }

  final String? code;

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  /// Phiên sau thao tác — view điều hướng bằng `routeForSession`.
  AppSession get session => ref.read(sessionServiceProvider).current;

  DateTime get today => ref.read(todayProvider);

  InvitePreviewData? data;

  /// INV-02 — lời mời không còn hiệu lực.
  bool invalid = false;
  String callName = '';

  /// Thời lượng dùng thử (ngày) theo trial policy của catalog; giá trị mặc
  /// định tới khi tải xong (BF-20261013-005).
  int trialDays = kValueDefaultTrialDuration.inDays;

  bool get isPartner => data?.invite.kind == InviteKind.partner;

  /// INV-01 hợp lệ / INV-02 không còn hiệu lực / INV-03 đang là Bố/Mẹ ở gia
  /// đình khác / INV-04 đã nhận — chờ xác nhận.
  InvitePreviewState get state => invalid
      ? InvitePreviewState.invalid
      : data?.state ?? InvitePreviewState.valid;

  /// Vai trò của người đang xem ở gia đình hiện tại (INV-03 “Mama · Nhà Lan”).
  FamilyRole? get myRole => session.role;

  bool get signedIn =>
      session.state != SessionState.signedOut &&
      session.state != SessionState.needsProfile;

  Future<void> load() async {
    final InvitePreviewData value;
    try {
      value = await sessionService.previewInvite(code ?? '');
    } on StateError {
      if (!isDisposed) {
        invalid = true;
        notifyListeners();
      }
      return;
    }
    final duration = await ref.read(familyServiceProvider).trialDuration();
    if (isDisposed) {
      return;
    }
    data = value;
    trialDays = duration.inDays;
    final invited = value.invite.callName;
    callName = invited != null && invited.isNotEmpty
        ? invited
        : value.invite.role == FamilyRole.mother
        ? kValueDefaultCallNameMother
        : kValueDefaultCallNameFather;
    notifyListeners();
  }

  void changeCallName(String value) {
    callName = value;
    notifyListeners();
  }

  Future<void> accept() async {
    final invite = data?.invite;
    await whileLoading(() async {
      await sessionService.acceptInvite(
        invite?.code ?? code ?? '',
        callName: isPartner && callName.trim().isNotEmpty
            ? callName.trim()
            : null,
      );
    });
  }

  Future<void> decline() async {
    await sessionService.declineInvite();
  }
}
