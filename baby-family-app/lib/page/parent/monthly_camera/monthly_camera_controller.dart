import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-21 Chụp ảnh tháng (camera mô phỏng: ảnh mẫu làm khung ngắm, bóng mờ
/// ảnh tháng trước, sticker tháng). Chụp → MEM-05 loại ảnh tháng.
final monthlyCameraControllerProvider =
    ChangeNotifierProvider.autoDispose<MonthlyCameraController>(
      MonthlyCameraController.new,
    );

class MonthlyCameraController extends BaseNotifier {
  MonthlyCameraController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);

  /// Độ mờ bóng ảnh tháng trước (Pencil `opacity 0.28`, nhãn “30%”).
  static const ghostPercent = 30;

  bool loaded = false;
  Child? child;
  int month = 1;
  String? ghostAsset;
  bool ghostOn = true;
  List<String> stickers = const [];

  /// Chỉ số sticker đang chọn; = `stickers.length` → “Không”.
  int sticker = 0;

  Future<void> init(String childId, int? month) async {
    final value = await childService.child(childId);
    final birth = value?.birthDate;
    final target =
        month ??
        (birth == null ? 1 : childAgeInMonths(birth, childService.today) + 1);
    final (photos, labels) = await (
      memoryService.monthlyPhotos(childId),
      memoryService.monthlyStickers(childId, target),
    ).wait;
    if (isDisposed) {
      return;
    }
    child = value;
    this.month = target;
    ghostAsset = photos
        .where((photo) => photo.monthIndex == target - 1)
        .firstOrNull
        ?.asset;
    stickers = labels;
    loaded = true;
    notifyListeners();
  }

  /// Ảnh khung ngắm (camera mô phỏng).
  String? get viewfinder => child?.coverAsset ?? child?.avatarAsset;

  String? get selectedSticker =>
      sticker < stickers.length ? stickers[sticker] : null;

  void toggleGhost() {
    ghostOn = !ghostOn;
    notifyListeners();
  }

  void selectSticker(int index) {
    sticker = index;
    notifyListeners();
  }
}
