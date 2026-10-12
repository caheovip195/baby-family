import 'package:baby_family/data/dto/account_settings_summary.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/family_settings.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Gia đình, thành viên, gói (FAM-01/03, SUB-01/07, SET-01).
abstract class IFamilyService extends IBaseService {
  Future<Family?> currentFamily();

  /// Thành viên đang hoạt động/đang chờ của gia đình hiện tại
  /// (Papa & Mama trước, người thân sau).
  Future<List<Member>> members();

  /// Thành viên ứng với người đang đăng nhập.
  Future<Member?> me();

  /// Bạn đời (Parent còn lại) — null khi gia đình đang chờ bạn đời.
  Future<Member?> partner();

  /// Gói bán trên Store (House/Family) với giá đã định dạng.
  Future<List<PlanOffer>> planOffers();

  /// SUB-01/07 (mock): mua gói thành công ngay, hết hạn → dùng tiếp.
  Future<void> purchasePlan(PlanState plan);

  Future<void> updateFamily({String? name, int? coverIndex});

  /// FAM-03: tạo lời mời người thân. Dùng thử không mời được người thân (C-07)
  /// — màn FAM-01 hiển thị khoá; service vẫn trả lời mời để luồng không kẹt.
  Future<InviteInfo> createRelativeInvite({
    required RelativeRelation relation,
    required String callName,
    List<String> childIds = const [],
    bool canComment = true,
    bool canPost = false,
  });

  Future<List<InviteInfo>> pendingInvites();

  Future<void> updateMember(
    String memberId, {
    String? callName,
    List<String>? grantedChildIds,
    bool? canComment,
    bool? canPost,
  });

  Future<void> removeRelative(String memberId);

  /// SET-01: lượt AI còn lại, khoá ứng dụng.
  Future<AccountSettingsSummary> settingsSummary();

  /// SET-01 “Giới thiệu”: phiên bản app đang chạy (null nếu không đọc được).
  Future<String?> appVersion();

  // --- Batch 2 (FAM-04, FAM-07) ---

  /// FAM-04: một thành viên theo id (người thân kèm quyền theo từng bé).
  Future<Member?> member(String memberId);

  /// FAM-04: đặt quyền với một bé; null = ngừng chia sẻ bé đó.
  Future<void> setChildPermission(
    String memberId,
    String childId,
    RelativePermission? permission,
  );

  /// FAM-04: tải ảnh về máy / tắt thông báo / tạm dừng quyền xem.
  Future<void> updateRelative(
    String memberId, {
    bool? allowDownload,
    bool? notificationsMuted,
    bool? paused,
  });

  /// FAM-07.
  Future<FamilySettings> familySettings();

  Future<void> saveFamilySettings(FamilySettings settings);
}
