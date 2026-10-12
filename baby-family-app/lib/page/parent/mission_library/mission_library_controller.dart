import 'package:baby_family/data/model/care/mission_template.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-04 “Thư viện nhiệm vụ” (mục 7.13.1, không có trong Pencil): danh sách
/// mẫu định sẵn; chọn một mẫu → trả `templateId` về CARE-03.
final missionLibraryControllerProvider =
    ChangeNotifierProvider.autoDispose<MissionLibraryController>(
      MissionLibraryController.new,
    );

class MissionLibraryController extends BaseNotifier {
  MissionLibraryController(super.ref) {
    ref.listen(appLanguageProvider, (_, _) => load());
    load();
  }

  ICareService get careService => ref.read(careServiceProvider);

  List<MissionTemplate>? templates;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    final result = await callFuture(careService.templates());
    if (isDisposed) {
      return;
    }
    hasError = result.isFailure;
    result.ifSuccess((data) => templates = data);
    notifyListeners();
  }
}
