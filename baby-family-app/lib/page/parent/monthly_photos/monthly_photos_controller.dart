import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/monthly_photo.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-20 Con lớn từng tháng: lưới 12 ô/năm (ảnh tháng chính — BR-072).
final monthlyPhotosControllerProvider =
    ChangeNotifierProvider.autoDispose<MonthlyPhotosController>(
      MonthlyPhotosController.new,
    );

class MonthlyPhotosController extends BaseNotifier {
  MonthlyPhotosController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
  }

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);

  String? childId;
  bool loaded = false;
  List<Child> children = const [];
  Map<int, MonthlyPhoto> photos = const {};

  /// Chip đang chọn: 0 … [yearCount] − 1 = năm thứ (index + 1), [yearCount] =
  /// Thai kỳ. Mặc định là năm của tháng sắp chụp (story v2: Haru năm thứ hai).
  int album = 0;
  bool _albumTouched = false;

  /// Số năm có ảnh tháng (12 ô/năm) tới tháng sắp chụp.
  int get yearCount => ((nextMonth - 1) ~/ 12) + 1;

  bool get pregnancyAlbum => album >= yearCount;

  /// Tháng đầu của năm đang xem (1, 13, 25…).
  int get firstMonth => album * 12 + 1;

  DateTime get today => childService.today;
  Child? get child =>
      children.where((value) => value.id == childId).firstOrNull;

  /// Số tháng tròn sắp tới (ô camera): Haru 5 tháng 6 ngày → 6.
  int get nextMonth {
    final birth = child?.birthDate;
    return birth == null ? 1 : childAgeInMonths(birth, today) + 1;
  }

  /// Số ngày tới ngày tròn [nextMonth] tháng.
  int get daysToNext {
    final birth = child?.birthDate;
    return birth == null
        ? 0
        : daysUntil(childMonthDate(birth, nextMonth), today).clamp(0, 999);
  }

  Future<void> init(String id) async {
    childId = id;
    await load();
  }

  Future<void> load() async {
    final id = childId;
    if (id == null) {
      return;
    }
    final (kids, items) = await (
      childService.children(),
      memoryService.monthlyPhotos(id),
    ).wait;
    if (isDisposed) {
      return;
    }
    children = kids.where((value) => !value.isPregnancy).toList();
    photos = {for (final item in items) item.monthIndex: item};
    if (!_albumTouched) {
      album = yearCount - 1;
    }
    loaded = true;
    notifyListeners();
  }

  void selectChild(String? id) {
    if (id == null || id == childId) {
      return;
    }
    childId = id;
    _albumTouched = false;
    load();
  }

  void selectAlbum(int value) {
    _albumTouched = true;
    album = value;
    notifyListeners();
  }
}
