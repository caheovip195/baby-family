import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-05 — Gửi lời cảm ơn (không có trong Pencil, mục 9.8): câu mẫu / viết
/// tự do, sticker, gắn nhiệm vụ (tuỳ chọn), đề nghị đăng khoảnh khắc gia đình.
final thanksComposeControllerProvider =
    ChangeNotifierProvider.autoDispose<ThanksComposeController>(
      ThanksComposeController.new,
    );

class ThanksComposeController extends BaseNotifier {
  ThanksComposeController(super.ref) {
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);

  Member? partner;
  String? sticker;
  bool proposeFamilyMoment = false;

  Future<void> load() async {
    final value = await ref.read(familyServiceProvider).partner();
    if (isDisposed) {
      return;
    }
    partner = value;
    notifyListeners();
  }

  void selectSticker(String value) {
    sticker = sticker == value ? null : value;
    notifyListeners();
  }

  void toggleFamilyMoment(bool value) {
    proposeFamilyMoment = value;
    notifyListeners();
  }

  /// Gửi (luôn đi tiếp — chưa gõ gì thì gửi sticker/câu trống như mock).
  Future<bool> send(String body, {String? missionId}) async {
    try {
      await whileLoading(
        () => usService.sendThanks(
          body: body,
          sticker: sticker,
          missionId: missionId,
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
