import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/album.dart';
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

/// MEM-03a Chi tiết album: bìa, tên, số ký ức, khoảng ngày, bé, người tạo,
/// lưới; menu Đổi tên • Đổi bìa • Thêm ký ức • Xoá album (giữ ký ức).
final albumDetailControllerProvider = ChangeNotifierProvider.autoDispose
    .family<AlbumDetailController, String>(AlbumDetailController.new);

class AlbumDetailController extends BaseNotifier {
  AlbumDetailController(super.ref, this.albumId) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  final String albumId;

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  bool loaded = false;
  bool hasError = false;
  Album? album;
  List<Child> children = const [];
  List<Member> members = const [];

  /// Bé gắn với album (theo thứ tự album).
  List<Child> get albumChildren => [
    for (final id in album?.childIds ?? const <String>[])
      ?children.where((child) => child.id == id).firstOrNull,
  ];

  /// Người tạo album (album tự động: null).
  Member? get creator => members
      .where((member) => member.userId == album?.createdByUserId)
      .firstOrNull;

  Future<void> load() async {
    hasError = false;
    try {
      final (value, kids, people) = await (
        memoryService.album(albumId),
        childService.children(),
        familyService.members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      album = value;
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

  Future<void> rename(String title) async {
    await callFuture(memoryService.renameAlbum(albumId, title));
    await load();
  }

  Future<void> changeCover(String asset) async {
    await callFuture(memoryService.changeAlbumCover(albumId, asset));
    await load();
  }

  /// Xoá album — ký ức trong album vẫn được giữ (BR MEM-03a).
  Future<bool> delete() async {
    final result = await callFuture(memoryService.deleteAlbum(albumId));
    return result.isSuccess;
  }
}
