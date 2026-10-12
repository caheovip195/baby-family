import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/invite_info.dart';

/// INV-01: lời mời + các bé người được mời sẽ thấy ([children]) và các bé đã
/// chào đời không được chia sẻ ([hiddenChildren], “Bà sẽ không thấy: Haru…”).
class InvitePreviewData {
  const InvitePreviewData({
    required this.invite,
    this.children = const [],
    this.hiddenChildren = const [],
  });

  final InviteInfo invite;
  final List<Child> children;
  final List<Child> hiddenChildren;
}
