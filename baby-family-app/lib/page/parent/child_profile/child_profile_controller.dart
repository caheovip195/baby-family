import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/child/child_profile.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CHD-01 “Hồ sơ bé” (mục 9.6, Pencil `AR7Mw`): ảnh bìa + avatar, tên, tên
/// khai sinh, tuổi, ngày sinh (dương + âm), giờ sinh, thai kỳ gốc, câu chuyện
/// tên, sở thích, thống kê nhẹ, người thân được chia sẻ; Sửa → CHD-02; Lưu
/// trữ (CHD-05).
final childProfileControllerProvider =
    ChangeNotifierProvider.autoDispose<ChildProfileController>(
      ChildProfileController.new,
    );

class ChildProfileController extends BaseNotifier {
  ChildProfileController(super.ref) {
    today = ref.read(todayProvider);
    ref.listen(mockRevisionProvider, (_, _) => load());
  }

  IChildService get childService => ref.read(childServiceProvider);

  late DateTime today;
  String? childId;
  bool loaded = false;
  bool hasError = false;
  Child? child;
  ChildProfile? profile;

  Future<void> init(String id) async {
    childId = id;
    await load();
  }

  Future<void> load() async {
    final id = childId;
    if (id == null) {
      return;
    }
    hasError = false;
    try {
      final loadedChild = await childService.child(id);
      final loadedProfile = await childService.profile(id);
      if (isDisposed) {
        return;
      }
      child = loadedChild;
      profile = loadedProfile ?? ChildProfile(childId: id);
      hasError = loadedChild == null;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }
}
