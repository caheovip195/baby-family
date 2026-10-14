import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/couple_week.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-14 — Tuần của hai ta [1.1] (Pencil `A7OdH4`, mục 9.8): số lần check-in,
/// lời nhờ được hỗ trợ, lời cảm ơn, nhiệm vụ cùng nhau; một lời cảm ơn nổi
/// bật; những điều đã cùng làm. Không có điểm, không so sánh hai người.
final coupleWeekControllerProvider =
    ChangeNotifierProvider.autoDispose<CoupleWeekController>(
      CoupleWeekController.new,
    );

class CoupleWeekController extends BaseNotifier {
  CoupleWeekController(super.ref) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  bool loaded = false;
  bool hasError = false;
  CoupleWeek? week;
  List<Member> members = const [];

  Member? memberByUser(String? userId) =>
      members.where((member) => member.userId == userId).firstOrNull;

  Future<void> load() async {
    hasError = false;
    try {
      final (value, people) = await (
        usService.coupleWeek(),
        familyService.members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      week = value;
      members = people;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }
}
