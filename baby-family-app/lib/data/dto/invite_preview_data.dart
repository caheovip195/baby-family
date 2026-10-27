import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// INV-01: lời mời + các bé người được mời sẽ thấy ([children]) và các bé đã
/// chào đời không được chia sẻ ([hiddenChildren], “Bà sẽ không thấy: Haru…”).
class InvitePreviewData {
  const InvitePreviewData({
    required this.invite,
    this.children = const [],
    this.hiddenChildren = const [],
    this.state = InvitePreviewState.valid,
    this.currentFamilyName,
    this.currentCallName,
    this.childAccess = const {},
  });

  /// INV-01 (valid) / INV-02 (invalid) / INV-03 (alreadyParent) / INV-04.
  final InvitePreviewState state;

  /// INV-03: gia đình hiện tại của người nhận (“Mama · Nhà Lan”).
  final String? currentFamilyName;
  final String? currentCallName;

  final InviteInfo invite;
  final List<Child> children;
  final List<Child> hiddenChildren;

  /// Lời mời người thân: quyền với từng bé (id bé → quyền + được tải ảnh);
  /// bé không có trong map dùng quyền chung của lời mời.
  final Map<String, ChildAccess> childAccess;
}

/// Quyền người thân với một bé khi xem trước lời mời (INV-01).
typedef ChildAccess = ({RelativePermission permission, bool allowDownload});
