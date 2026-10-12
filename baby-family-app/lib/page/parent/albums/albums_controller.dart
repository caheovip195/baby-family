import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/album.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-03 Album: album tự động (trên) + album của nhà mình (dưới), lọc theo
/// bé, tạo album mới.
final albumsControllerProvider =
    ChangeNotifierProvider.autoDispose<AlbumsController>(AlbumsController.new);

class AlbumsController extends BaseNotifier {
  AlbumsController(super.ref) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);

  bool loaded = false;
  bool hasError = false;
  List<Album> albums = const [];
  List<Child> children = const [];

  /// Bé đang lọc (null = Cả nhà).
  String? childId;

  List<Album> get autoAlbums =>
      albums.where((album) => album.isAuto).toList(growable: false);

  /// Album tự tạo, lọc theo bé đang chọn.
  List<Album> get familyAlbums => albums
      .where(
        (album) =>
            !album.isAuto &&
            (childId == null || album.childIds.contains(childId)),
      )
      .toList(growable: false);

  Child? childById(String? id) =>
      children.where((child) => child.id == id).firstOrNull;

  Future<void> load() async {
    hasError = false;
    try {
      final (rows, kids) = await (
        memoryService.albums(),
        childService.children(),
      ).wait;
      if (isDisposed) {
        return;
      }
      albums = rows;
      children = kids.where((child) => !child.isPregnancy).toList();
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void selectChild(String? id) {
    childId = id;
    notifyListeners();
  }

  /// “+ Album mới” — trả về album vừa tạo để mở MEM-03a.
  Future<Album?> createAlbum(String title) async {
    final name = title.trim();
    if (name.isEmpty) {
      return null;
    }
    final result = await callFuture(
      memoryService.createAlbum(title: name, childIds: [?childId]),
    );
    return result.isSuccess ? result.dataOrThrow : null;
  }
}
