import 'package:baby_family/data/model/settings/blocked_person.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-13 — Người bị chặn: danh sách người đang chặn (người thân ở gia đình
/// khác…) và “Bỏ chặn”. Papa/Mama không chặn nhau (ghi chú cuối màn).
final blockedPeopleControllerProvider =
    ChangeNotifierProvider.autoDispose<BlockedPeopleController>(
      BlockedPeopleController.new,
    );

class BlockedPeopleController extends BaseNotifier {
  BlockedPeopleController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  List<BlockedPerson>? people;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final value = await settingsService.blockedPeople();
      if (isDisposed) {
        return;
      }
      people = value;
    } on Object {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  Future<void> unblock(BlockedPerson person) async {
    people = [
      for (final item in people ?? const <BlockedPerson>[])
        if (item.id != person.id) item,
    ];
    notifyListeners();
    await settingsService.unblock(person.id);
  }
}
