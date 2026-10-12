import 'package:baby_family/data/dto/birth_draft.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/pregnancy.dart';
import 'package:baby_family/data/service/pregnancy.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// PREG-05 — Bé đã chào đời (mục 7.6, 9.5): B1 số bé → B2 thông tin từng bé
/// (wpICu) → B3–B4 thẻ chào mừng + báo tin (wQZI7) → Trang chủ chọn bé mới.
final birthControllerProvider =
    ChangeNotifierProvider.autoDispose<BirthController>(BirthController.new);

class BirthController extends BaseNotifier {
  BirthController(super.ref);

  IPregnancyService get pregnancyService => ref.read(pregnancyServiceProvider);

  /// Số bước của thanh tiến độ (B1…B5).
  static const stepCount = 5;

  /// Số bé tối đa (7.5: 1–4).
  static const maxBabies = 4;

  String? _pregnancyId;
  Child? pregnancy;
  Family? family;
  List<Child> siblings = const [];
  List<Member> relatives = const [];
  BirthDraft _template = const BirthDraft();

  /// 1 = B1 số bé, 2 = B2 thông tin bé [babyIndex], 3 = B3–B4.
  int step = 1;
  int babyCount = 1;
  int babyIndex = 0;
  List<BirthDraft> babies = const [];
  Set<String> announceTo = {};
  bool hasError = false;

  BirthDraft get currentBaby => babies[babyIndex];

  BirthDraft get firstBaby => babies.first;

  bool get isLoaded => pregnancy != null && babies.isNotEmpty;

  void init(String pregnancyId) {
    if (_pregnancyId == pregnancyId) {
      return;
    }
    _pregnancyId = pregnancyId;
    load();
  }

  Future<void> load() async {
    final pregnancyId = _pregnancyId;
    if (pregnancyId == null) {
      return;
    }
    toLoading();
    try {
      final childService = ref.read(childServiceProvider);
      final familyService = ref.read(familyServiceProvider);
      final results = await Future.wait<Object?>([
        childService.child(pregnancyId),
        childService.children(),
        familyService.currentFamily(),
        familyService.members(),
        pregnancyService.birthDraft(pregnancyId),
      ]);
      if (isDisposed) {
        return;
      }
      pregnancy = results[0] as Child?;
      siblings = (results[1]! as List<Child>)
          .where((child) => child.id != pregnancyId && !child.isPregnancy)
          .toList();
      family = results[2] as Family?;
      relatives = (results[3]! as List<Member>)
          .where((member) => member.role == FamilyRole.relative)
          .toList();
      announceTo = {for (final member in relatives) member.id};
      _template = results[4]! as BirthDraft;
      babyCount = pregnancy?.babyCount.clamp(1, maxBabies) ?? 1;
      babies = List.filled(babyCount, _template);
      hasError = pregnancy == null;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    toIdle();
    notifyListeners();
  }

  void selectBabyCount(int value) {
    babyCount = value;
    babies = [
      for (var index = 0; index < value; index++)
        index < babies.length
            ? babies[index]
            : _template.copyWith(name: '', nickname: ''),
    ];
    notifyListeners();
  }

  void updateBaby(BirthDraft value) {
    babies = [...babies]..[babyIndex] = value;
    notifyListeners();
  }

  /// B2 “Ảnh đầu tiên của bé” — mock: dùng ảnh mẫu của bản nháp.
  void pickFirstPhoto() {
    final sample = currentBaby.samplePhotoAsset;
    if (sample != null) {
      updateBaby(currentBaby.copyWith(photoAsset: sample));
    }
  }

  void toggleAnnounce(String memberId) {
    announceTo.contains(memberId)
        ? announceTo.remove(memberId)
        : announceTo.add(memberId);
    notifyListeners();
  }

  /// Tiến một bước; trả `false` khi đã ở bước cuối.
  void next() {
    if (step == 1) {
      step = 2;
      babyIndex = 0;
    } else if (step == 2 && babyIndex < babyCount - 1) {
      babyIndex++;
    } else {
      step = 3;
    }
    notifyListeners();
  }

  /// Lùi một bước; trả `false` khi đang ở B1 (thoát màn).
  bool back() {
    if (step == 1) {
      return false;
    }
    if (step == 3) {
      step = 2;
      babyIndex = babyCount - 1;
    } else if (babyIndex > 0) {
      babyIndex--;
    } else {
      step = 1;
    }
    notifyListeners();
    return true;
  }

  /// B5: thai kỳ thành bé đầu tiên, các bé còn lại thêm mới; chọn bé đầu ở
  /// Trang chủ. Trả id bé đầu tiên.
  Future<String?> complete(DateTime today) async {
    final pregnancyId = _pregnancyId;
    if (pregnancyId == null) {
      return null;
    }
    return whileLoading(() async {
      final first = firstBaby;
      final baby = await pregnancyService.convertToBaby(
        pregnancyId,
        name: first.name.trim().isEmpty ? (pregnancy?.name ?? '') : first.name,
        nickname: first.nickname,
        avatarAsset: first.welcomePhoto,
        birthDate: first.birthDate ?? today,
        birthTime: first.birthTime,
        gender: first.gender,
        weightKg: first.weightKg,
        heightCm: first.heightCm,
      );
      final childService = ref.read(childServiceProvider);
      for (final other in babies.skip(1)) {
        await childService.addChild(
          name: other.name.trim().isEmpty ? baby.name : other.name,
          birthDate: other.birthDate ?? first.birthDate ?? today,
          gender: other.gender,
          avatarAsset: other.photoAsset,
        );
      }
      if (!isDisposed) {
        ref.read(selectedSubjectProvider.notifier).select(baby.id);
      }
      return baby.id;
    });
  }
}
