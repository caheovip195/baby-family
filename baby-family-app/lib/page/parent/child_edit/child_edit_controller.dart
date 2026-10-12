import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/child/child_profile.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CHD-02 “Sửa hồ sơ bé” (mục 9.6, Pencil `nX7EO`): tên, tên ở nhà, ngày/giờ
/// sinh (+ âm lịch, cảnh báo tính lại tuổi), cho người thân thấy giờ sinh,
/// màu nhận diện (8 màu), câu chuyện tên + ai đặt, sở thích. Lưu luôn đi tiếp.
final childEditControllerProvider =
    ChangeNotifierProvider.autoDispose<ChildEditController>(
      ChildEditController.new,
    );

class ChildEditController extends BaseNotifier {
  ChildEditController(super.ref) {
    today = ref.read(todayProvider);
  }

  IChildService get childService => ref.read(childServiceProvider);

  late DateTime today;
  bool loaded = false;
  bool hasError = false;
  late Child child;
  late ChildProfile profile;
  List<Child> siblings = const [];
  List<Member> parents = const [];

  /// Người đặt tên có thể chọn: Bố/Mẹ + người đã ghi trong hồ sơ.
  List<String> get namerOptions => {
    for (final parent in parents) parent.callName,
    ...profile.nameGivenBy,
  }.toList();

  Future<void> init(String childId) async {
    try {
      final loadedChild = await childService.child(childId);
      final loadedProfile = await childService.profile(childId);
      final all = await childService.children();
      final family = ref.read(familyServiceProvider);
      final me = await family.me();
      final partner = await family.partner();
      if (isDisposed) {
        return;
      }
      if (loadedChild == null) {
        hasError = true;
      } else {
        child = loadedChild;
        profile = loadedProfile ?? ChildProfile(childId: childId);
        siblings = [
          for (final item in all)
            if (item.id != childId) item,
        ];
        parents = [?me, ?partner];
      }
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  /// Bé khác (đã chào đời) đang dùng màu [index] (gợi ý dưới bảng màu; thai
  /// kỳ dùng màu Papa & Mama nên không tính).
  Child? siblingWithColor(int index) {
    for (final sibling in siblings) {
      if (!sibling.isPregnancy && sibling.colorIndex == index) {
        return sibling;
      }
    }
    return null;
  }

  void setFullName(String value) =>
      profile = profile.copyWith(fullName: value.trim());

  void setNickname(String value) => child = child.copyWith(name: value.trim());

  void setNameStory(String value) =>
      profile = profile.copyWith(nameStory: value.trim());

  void setFavoriteFood(String value) =>
      profile = profile.copyWith(favoriteFood: value.trim());

  void setFavoriteToy(String value) =>
      profile = profile.copyWith(favoriteToy: value.trim());

  void setFavoriteSong(String value) =>
      profile = profile.copyWith(favoriteSong: value.trim());

  void setDate(DateTime date) {
    child = child.isPregnancy
        ? child.copyWith(dueDate: date)
        : child.copyWith(birthDate: date);
    notifyListeners();
  }

  void setBirthTime(String value) {
    child = child.copyWith(birthTime: value);
    notifyListeners();
  }

  void setShowBirthTime(bool value) {
    profile = profile.copyWith(showBirthTimeToRelatives: value);
    notifyListeners();
  }

  void setColor(int index) {
    child = child.copyWith(colorIndex: index);
    notifyListeners();
  }

  void toggleNamer(String name) {
    final names = [...profile.nameGivenBy];
    names.contains(name) ? names.remove(name) : names.add(name);
    profile = profile.copyWith(nameGivenBy: names);
    notifyListeners();
  }

  Future<bool> save() async {
    final result = await callFuture(
      Future.wait([
        childService.updateChild(child),
        childService.saveProfile(profile),
      ]),
    );
    return result.isSuccess;
  }
}
