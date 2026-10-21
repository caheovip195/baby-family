import 'package:baby_family/data/dto/media_source.dart';
import 'package:baby_family/data/repository/gallery.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:crypto/crypto.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryRepositoryImp extends BaseRepositoryImp
    implements IGalleryRepository {
  @override
  Future<bool> hasAccess() async => (await PhotoManager.getPermissionState(
    requestOption: const PermissionRequestOption(),
  )).hasAccess;

  @override
  Future<bool> requestAccess() async =>
      (await PhotoManager.requestPermissionExtend()).hasAccess;

  @override
  Future<List<GalleryItem>> items({int limit = 5000}) async {
    final assets = await PhotoManager.getAssetListRange(start: 0, end: limit);
    return [
      for (final asset in assets)
        if (asset.type == AssetType.image || asset.type == AssetType.video)
          GalleryItem(
            id: asset.id,
            createdAt: asset.createDateTime,
            key: MediaSource.keyOf(
              kind: asset.type == AssetType.video ? 'VIDEO' : 'IMAGE',
              width: asset.width,
              height: asset.height,
              durationMs: asset.type == AssetType.video
                  ? asset.duration * 1000
                  : null,
            ),
          ),
    ];
  }

  @override
  Future<String?> sha256Of(String id) async {
    final file = await (await AssetEntity.fromId(id))?.originFile;
    if (file == null) {
      return null;
    }
    return (await sha256.bind(file.openRead()).first).toString();
  }

  @override
  Future<String?> filePath(String id) async =>
      (await (await AssetEntity.fromId(id))?.file)?.path;
}
