import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:share_plus/share_plus.dart';

/// MEM-08 Xem ảnh toàn màn hình: vuốt ngang chuyển ảnh, pinch zoom, vuốt
/// xuống để đóng; Tải về • Chia sẻ • Yêu thích • Thông tin.
final photoViewerControllerProvider = ChangeNotifierProvider.autoDispose
    .family<PhotoViewerController, String>(PhotoViewerController.new);

class PhotoViewerController extends BaseNotifier {
  PhotoViewerController(super.ref, this.memoryId) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  final String memoryId;

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  bool loaded = false;
  bool hasError = false;
  Memory? memory;
  List<Child> children = const [];
  List<Member> members = const [];
  int page = 0;

  List<String> get assets => memory?.mediaAssets ?? const [];

  /// Bé trong ký ức (theo thứ tự ký ức).
  List<Child> get memoryChildren => [
    for (final id in memory?.childIds ?? const <String>[])
      ?children.where((child) => child.id == id).firstOrNull,
  ];

  Member? get author =>
      members.where((member) => member.userId == memory?.authorId).firstOrNull;

  Future<void> load() async {
    hasError = false;
    try {
      final (value, kids, people) = await (
        memoryService.memory(memoryId),
        childService.children(),
        familyService.members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      memory = value;
      children = kids;
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

  /// Trang mở đầu theo `?index=` (kẹp trong số ảnh).
  void setInitialPage(int? index) {
    final count = assets.length;
    page = count == 0 ? 0 : (index ?? 0).clamp(0, count - 1);
  }

  void setPage(int value) {
    page = value;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    await callFuture(
      memoryService.toggleFavorite(memoryId),
      withLoading: false,
    );
    await load();
  }

  /// Chia sẻ ra ngoài (Parent) — chú thích ký ức qua bảng chia sẻ hệ thống.
  Future<void> share() async {
    final text = memory?.body ?? memory?.title;
    if (text == null) {
      return;
    }
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } catch (_) {
      // Bảng chia sẻ không khả dụng (test/simulator) — bỏ qua.
    }
  }
}
