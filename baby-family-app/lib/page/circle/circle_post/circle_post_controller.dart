import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/circle/circle_post_draft.dart';
import 'package:baby_family/data/provider/circle.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CIR-04 — Đăng ảnh (người thân có quyền Đóng góp): chọn ảnh, cháu (chỉ
/// cháu được cấp quyền Đóng góp — mục 9.14), ngày chụp, lời nhắn; không
/// chọn người xem (mặc định Cả nhà). Gửi → chờ bố mẹ duyệt (MEM-19) và hiện
/// CIR-04b “Đã gửi!”.
final circlePostControllerProvider =
    ChangeNotifierProvider.autoDispose<CirclePostController>(
      CirclePostController.new,
    );

class CirclePostController extends BaseNotifier {
  CirclePostController(super.ref) {
    Future.microtask(load);
  }

  ICircleService get circleService => ref.read(circleServiceProvider);

  final message = TextEditingController();

  bool loaded = false;
  bool hasError = false;
  List<Child> children = const [];
  List<String> assets = const [];
  final List<String> _removed = [];
  final Set<String> childIds = {};
  DateTime? takenAt;

  /// CIR-04b — bài vừa gửi.
  CirclePostDraft? sent;

  DateTime get today => ref.read(appClockProvider).today;

  bool get canAddPhoto => _removed.isNotEmpty;

  bool get canSend => assets.isNotEmpty && childIds.isNotEmpty;

  List<Child> get selectedChildren => [
    for (final child in children)
      if (childIds.contains(child.id)) child,
  ];

  Future<void> load() async {
    hasError = false;
    toLoading();
    try {
      final (draft, view) = await (
        circleService.postDraft(),
        circleService.view(),
      ).wait;
      if (isDisposed) {
        return;
      }
      final permissions = view?.viewer.childPermissions ?? const {};
      children = [
        for (final child in view?.children ?? const <Child>[])
          if (!child.isPregnancy &&
              permissions[child.id] == RelativePermission.contribute)
            child,
      ];
      assets = [...draft.mediaAssets];
      _removed.clear();
      childIds
        ..clear()
        ..addAll(
          draft.childIds.where((id) => children.any((kid) => kid.id == id)),
        );
      if (childIds.isEmpty && children.length == 1) {
        childIds.add(children.first.id);
      }
      takenAt = draft.takenAt ?? today;
      message.text = draft.message;
      sent = null;
      loaded = true;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    toIdle();
  }

  void removePhoto(String asset) {
    assets = [...assets]..remove(asset);
    _removed.add(asset);
    notifyListeners();
  }

  /// Mock chọn ảnh: lấy lại ảnh vừa bỏ.
  void addPhoto() {
    if (_removed.isEmpty) {
      return;
    }
    assets = [...assets, _removed.removeLast()];
    notifyListeners();
  }

  void toggleChild(String id) {
    if (!childIds.remove(id)) {
      childIds.add(id);
    }
    notifyListeners();
  }

  void setDate(DateTime value) {
    takenAt = value;
    notifyListeners();
  }

  Future<void> submit() async {
    final post = CirclePostDraft(
      mediaAssets: assets,
      childIds: childIds.toList(),
      takenAt: takenAt,
      message: message.text.trim(),
    );
    await circleService.submitPost(post);
    if (isDisposed) {
      return;
    }
    sent = post;
    notifyListeners();
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }
}
