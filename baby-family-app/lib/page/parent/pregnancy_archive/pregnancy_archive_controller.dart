import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/pregnancy.dart';
import 'package:baby_family/data/service/pregnancy.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// PREG-06 — Lưu trữ hành trình (nhạy cảm, mục 7.5): “Tạm dừng hành trình”
/// hoặc “Hành trình này đã dừng lại”; tuỳ chọn chuyển ký ức về Papa & Mama;
/// không thông báo cho người thân.
final pregnancyArchiveControllerProvider =
    ChangeNotifierProvider.autoDispose<PregnancyArchiveController>(
      PregnancyArchiveController.new,
    );

class PregnancyArchiveController extends BaseNotifier {
  PregnancyArchiveController(super.ref);

  IPregnancyService get pregnancyService => ref.read(pregnancyServiceProvider);

  String? _pregnancyId;
  Child? child;

  /// Lựa chọn đang chọn như thiết kế: “Hành trình này đã dừng lại”.
  bool ended = true;

  /// “Chỉ Papa & Mama xem các ký ức này” — bật như thiết kế.
  bool parentsOnly = true;

  void init(String pregnancyId) {
    if (_pregnancyId == pregnancyId) {
      return;
    }
    _pregnancyId = pregnancyId;
    _load(pregnancyId);
  }

  Future<void> _load(String pregnancyId) async {
    final value = await ref.read(childServiceProvider).child(pregnancyId);
    if (isDisposed) {
      return;
    }
    child = value;
    notifyListeners();
  }

  void choose({required bool ended}) {
    this.ended = ended;
    notifyListeners();
  }

  void toggleParentsOnly(bool value) {
    parentsOnly = value;
    notifyListeners();
  }

  /// Lưu trữ rồi bỏ chọn thai kỳ ở Trang chủ (về “Cả nhà”).
  Future<void> confirm() async {
    final pregnancyId = _pregnancyId;
    if (pregnancyId == null) {
      return;
    }
    await whileLoading(() async {
      await pregnancyService.archive(pregnancyId, parentsOnly: parentsOnly);
      if (isDisposed) {
        return;
      }
      final subject = ref.read(selectedSubjectProvider.notifier);
      if (ref.read(selectedSubjectProvider) == pregnancyId) {
        subject.select(null);
      }
    });
  }
}
