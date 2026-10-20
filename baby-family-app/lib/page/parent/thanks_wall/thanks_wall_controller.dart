import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/thanks.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-06 “Bức tường cảm ơn” (mục 9.8, Pencil `ihnhh`): thẻ giấy note hai màu
/// (của tôi / của bạn đời), lọc theo tháng, thả tim. Chỉ Papa & Mama thấy.
final thanksWallControllerProvider =
    ChangeNotifierProvider.autoDispose<ThanksWallController>(
      ThanksWallController.new,
    );

class ThanksWallController extends BaseNotifier {
  ThanksWallController(super.ref) {
    final today = ref.read(todayProvider);
    months = [
      for (var i = 0; i < monthChipCount; i++)
        DateTime(today.year, today.month - i),
    ];
    month = months.first;
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);

  /// Số chip tháng gần nhất trước “Tất cả” (Pencil: Tháng 10 · 9 · 8).
  static const monthChipCount = 3;

  late List<DateTime> months;

  /// Tháng đang lọc; null = tất cả.
  DateTime? month;
  bool loaded = false;
  bool hasError = false;
  List<Thanks> thanks = const [];
  Member? me;
  Member? partner;

  String? get myUserId => me?.userId;

  bool isMine(Thanks item) => item.fromUserId == myUserId;

  Future<void> load() async {
    hasError = false;
    try {
      final loadedThanks = await usService.thanksWall(month: month);
      final family = ref.read(familyServiceProvider);
      final loadedMe = await family.me();
      final loadedPartner = await family.partner();
      if (isDisposed) {
        return;
      }
      thanks = loadedThanks;
      me = loadedMe;
      partner = loadedPartner;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void selectMonth(DateTime? value) {
    month = value;
    load();
  }

  Future<void> toggleHeart(Thanks item) async {
    await usService.toggleThanksHeart(item.id);
    await load();
  }

  /// Lời cảm ơn bạn đời gửi tôi kèm đề nghị đăng lên gia đình.
  bool awaitsMyShareDecision(Thanks item) =>
      item.shareRequested && item.toUserId == myUserId;

  /// Duyệt / để riêng đề nghị đăng; `false` khi lỗi (view báo lại).
  Future<bool> respondShare(Thanks item, {required bool approve}) async {
    try {
      await usService.respondThanksShare(item.id, approve: approve);
    } on Object {
      return false;
    }
    await load();
    return true;
  }
}
