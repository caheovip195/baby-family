import 'package:baby_family/data/model/family/family_settings.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// FAM-07 — Cài đặt gia đình: tên, ảnh bìa, mặc định người xem, duyệt ảnh,
/// Cây gia đình, gợi ý cột mốc, múi giờ, âm lịch. Mỗi thay đổi lưu ngay.
final familySettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<FamilySettingsController>(
      FamilySettingsController.new,
    );

class FamilySettingsController extends BaseNotifier {
  FamilySettingsController(super.ref) {
    load();
  }

  IFamilyService get familyService => ref.read(familyServiceProvider);

  FamilySettings? settings;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final result = await familyService.familySettings();
      if (isDisposed) {
        return;
      }
      settings = result;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  /// Cập nhật cục bộ rồi lưu (mock: thành công ngay).
  Future<void> update(FamilySettings Function(FamilySettings) change) async {
    final current = settings;
    if (current == null) {
      return;
    }
    settings = change(current);
    notifyListeners();
    await familyService.saveFamilySettings(settings!);
  }
}
