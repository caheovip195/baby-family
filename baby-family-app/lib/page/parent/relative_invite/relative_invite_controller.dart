import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/external_launcher.dart';
import 'package:hooks_riverpod/legacy.dart';

/// FAM-03 — Mời người thân: quan hệ, tên gọi, bé được theo dõi, quyền.
/// Luồng mock đi thẳng: “Tạo lời mời” luôn tạo được lời mời (không chặn).
final relativeInviteControllerProvider =
    ChangeNotifierProvider.autoDispose<RelativeInviteController>(
      RelativeInviteController.new,
    );

class RelativeInviteController extends BaseNotifier {
  RelativeInviteController(super.ref) {
    load();
  }

  IFamilyService get familyService => ref.read(familyServiceProvider);

  Family? family;
  List<Child> children = const [];
  final Set<String> selectedChildIds = {};
  bool canView = true;
  bool canComment = true;
  bool canPost = false;

  Future<void> load() async {
    final results = await Future.wait([
      familyService.currentFamily(),
      ref.read(childServiceProvider).children(),
    ]);
    if (isDisposed) {
      return;
    }
    family = results[0] as Family?;
    children = results[1]! as List<Child>;
    selectedChildIds
      ..clear()
      ..addAll(children.map((child) => child.id));
    notifyListeners();
  }

  void toggleChild(String id) {
    if (!selectedChildIds.remove(id)) {
      selectedChildIds.add(id);
    }
    notifyListeners();
  }

  void setCanView(bool value) {
    canView = value;
    notifyListeners();
  }

  void setCanComment(bool value) {
    canComment = value;
    notifyListeners();
  }

  void setCanPost(bool value) {
    canPost = value;
    notifyListeners();
  }

  Future<InviteInfo?> createInvite({
    required RelativeRelation relation,
    required String callName,
  }) async {
    InviteInfo? invite;
    await whileLoading(() async {
      invite = await familyService.createRelativeInvite(
        relation: relation,
        callName: callName.trim(),
        childIds: [
          for (final child in children)
            if (selectedChildIds.contains(child.id)) child.id,
        ],
        canComment: canComment,
        canPost: canPost,
      );
    });
    return invite;
  }

  /// Tên các bé được chọn (ghép vào tin nhắn mời).
  List<String> get selectedChildNames => [
    for (final child in children)
      if (selectedChildIds.contains(child.id)) child.name,
  ];

  /// FAM-03 “Gửi”: bảng chia sẻ hệ thống với tin nhắn soạn sẵn + link
  /// (BF-20261026-004 — trước đây chỉ hiện snackbar, không gửi được).
  Future<void> share(String message) => shareText(message);
}
