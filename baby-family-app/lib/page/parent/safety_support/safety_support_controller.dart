import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/safety_hotline.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/helper/external_launcher.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-13 — Hỗ trợ an toàn (Pencil `SeTnA`, mục 7.17.3, luôn miễn phí): số
/// khẩn cấp từ catalog (113/115/111), gọi trực tiếp bằng trình gọi của máy,
/// “Thoát nhanh” về Trang chủ. Màn này **chỉ đọc**: không ghi vào phiên Cầu
/// nối, không gửi thông báo hay bất cứ dữ liệu nào cho bạn đời.
final safetySupportControllerProvider =
    ChangeNotifierProvider.autoDispose<SafetySupportController>(
      SafetySupportController.new,
    );

class SafetySupportController extends BaseNotifier {
  SafetySupportController(super.ref) {
    ref.listen(appLanguageProvider, (_, _) => load());
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  bool loaded = false;
  bool hasError = false;
  List<SafetyHotline> hotlines = const [];
  Member? partner;

  Future<void> load() async {
    hasError = false;
    try {
      final (lines, other) = await (
        usService.safetyHotlines(),
        familyService.partner(),
      ).wait;
      if (isDisposed) {
        return;
      }
      hotlines = lines;
      partner = other;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  Future<bool> call(SafetyHotline hotline) => launchPhoneCall(hotline.number);

  Future<bool> contactTrustedPerson() => launchMessages();
}
