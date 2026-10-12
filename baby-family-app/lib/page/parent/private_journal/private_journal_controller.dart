import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/couple_settings.dart';
import 'package:baby_family/data/model/us/journal_entry.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-07 “Nhật ký riêng” (mục 9.8, Pencil `L5Opmj`): danh sách trang (ngày,
/// đoạn đầu, cảm xúc), khoá Face ID (tuỳ chọn), viết trang mới, “Chia sẻ đoạn
/// này với bạn đời” (xem trước chính xác). Chỉ của tôi — không bao giờ của
/// bạn đời.
final privateJournalControllerProvider =
    ChangeNotifierProvider.autoDispose<PrivateJournalController>(
      PrivateJournalController.new,
    );

class PrivateJournalController extends BaseNotifier {
  PrivateJournalController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);

  bool loaded = false;
  bool hasError = false;
  List<JournalEntry> entries = const [];
  CoupleSettings settings = const CoupleSettings();
  Member? partner;

  String get partnerCallName => partner?.callName ?? '';

  /// Trang mới nhất chưa chia sẻ — nơi hiện “Chia sẻ đoạn này với bạn đời”.
  String? get shareableId {
    final first = entries.firstOrNull;
    return first == null || first.sharedExcerpt ? null : first.id;
  }

  Future<void> load() async {
    hasError = false;
    try {
      final loadedEntries = await usService.journal();
      final loadedSettings = await usService.coupleSettings();
      final loadedPartner = await ref.read(familyServiceProvider).partner();
      if (isDisposed) {
        return;
      }
      entries = loadedEntries;
      settings = loadedSettings;
      partner = loadedPartner;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  Future<void> setFaceIdLock(bool value) async {
    settings = settings.copyWith(journalFaceIdLock: value);
    notifyListeners();
    await usService.saveCoupleSettings(settings);
  }

  Future<void> share(String entryId) async {
    await usService.shareJournalExcerpt(entryId);
    await load();
  }

  /// Lưu trang mới (không chặn — tiêu đề trống vẫn lưu).
  Future<void> addEntry({
    required JournalMood mood,
    required String title,
    required String body,
  }) async {
    await callFuture(
      usService.addJournalEntry(mood: mood, title: title, body: body),
    );
    await load();
  }
}
