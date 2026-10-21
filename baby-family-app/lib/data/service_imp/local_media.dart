import 'package:baby_family/data/repository/gallery.dart';
import 'package:baby_family/data/repository/local_media_index.dart';
import 'package:baby_family/data/service/local_media.dart';
import 'package:baby_family/utils/helper/app_clock.dart';

/// Khớp asset server với ảnh/video trong thư viện máy:
/// 1. Chỉ mục đã lưu (assetId → id thư viện) còn hiệu lực → dùng ngay.
/// 2. Ứng viên cùng khoá metadata (loại · kích thước · thời lượng), thu hẹp
///    bằng thời điểm chụp (±2 giây) → băm SHA-256 file gốc (có cache) và so với
///    `source.sha256` của server.
/// 3. Không trùng SHA (picker đã đổi định dạng, vd HEIC → JPEG) → chỉ chấp
///    nhận khi đúng một ứng viên cùng khoá và cùng thời điểm chụp.
/// Không bao giờ so theo tên file. Chưa khớp thì thử lại sau [_retryAfter].
class LocalMediaServiceImp implements ILocalMediaService {
  LocalMediaServiceImp(this._gallery, this._index, this._clock);

  final IGalleryRepository _gallery;
  final ILocalMediaIndexRepository _index;
  final AppClock _clock;

  static const _maxHashesPerAsset = 10;
  static const _captureTolerance = Duration(seconds: 2);
  static const _retryAfter = Duration(days: 1);
  static const _galleryTtl = Duration(minutes: 10);

  Map<String, List<GalleryItem>>? _byKey;
  DateTime? _scannedAt;

  @override
  Future<void> enable() async {
    await _gallery.requestAccess();
  }

  @override
  Future<Map<String, String>> resolve(List<RemoteMediaRef> refs) async {
    if (refs.isEmpty || !await _gallery.hasAccess()) {
      return const {};
    }
    final index = await _index.load();
    final assets = Map<String, dynamic>.from(
      (index['assets'] as Map?) ?? const {},
    );
    final hashes = Map<String, dynamic>.from(
      (index['hashes'] as Map?) ?? const {},
    );
    final misses = Map<String, dynamic>.from(
      (index['misses'] as Map?) ?? const {},
    );
    final now = _clock.now();
    final result = <String, String>{};
    var changed = false;

    for (final ref in refs) {
      final known = assets[ref.assetId] as String?;
      if (known != null) {
        final path = await _gallery.filePath(known);
        if (path != null) {
          result[ref.assetId] = path;
          continue;
        }
        // Ảnh đã bị xoá khỏi thư viện: quay lại ảnh server.
        assets.remove(ref.assetId);
        changed = true;
      }
      final missedAt = DateTime.tryParse('${misses[ref.assetId] ?? ''}');
      if (missedAt != null && now.difference(missedAt) < _retryAfter) {
        continue;
      }
      final match = await _match(ref, hashes);
      changed = true;
      if (match == null) {
        misses[ref.assetId] = now.toIso8601String();
        continue;
      }
      misses.remove(ref.assetId);
      final path = await _gallery.filePath(match);
      if (path != null) {
        assets[ref.assetId] = match;
        result[ref.assetId] = path;
      }
    }
    if (changed) {
      await _index.save({'assets': assets, 'hashes': hashes, 'misses': misses});
    }
    return result;
  }

  Future<String?> _match(
    RemoteMediaRef ref,
    Map<String, dynamic> hashes,
  ) async {
    final byKey = await _galleryByKey();
    var candidates = byKey[ref.key] ?? const <GalleryItem>[];
    final capturedAt = ref.capturedAt;
    if (capturedAt != null) {
      candidates = [
        for (final item in candidates)
          if (item.createdAt.difference(capturedAt).abs() <= _captureTolerance)
            item,
      ];
    }
    for (final item in candidates.take(_maxHashesPerAsset)) {
      var hash = hashes[item.id] as String?;
      hash ??= await _gallery.sha256Of(item.id);
      if (hash == null) {
        continue;
      }
      hashes[item.id] = hash;
      if (hash == ref.sha256) {
        return item.id;
      }
    }
    // Bản picker đã đổi định dạng nên SHA khác: chỉ nhận khi duy nhất một ảnh
    // cùng khoá và cùng thời điểm chụp.
    if (capturedAt != null && candidates.length == 1) {
      return candidates.single.id;
    }
    return null;
  }

  Future<Map<String, List<GalleryItem>>> _galleryByKey() async {
    final scanned = _scannedAt;
    final cached = _byKey;
    if (cached != null &&
        scanned != null &&
        _clock.now().difference(scanned) < _galleryTtl) {
      return cached;
    }
    final byKey = <String, List<GalleryItem>>{};
    for (final item in await _gallery.items()) {
      (byKey[item.key] ??= []).add(item);
    }
    _byKey = byKey;
    _scannedAt = _clock.now();
    return byKey;
  }
}

/// Bản mẫu (không server): không có asset server để khớp.
class NoLocalMediaService implements ILocalMediaService {
  const NoLocalMediaService();

  @override
  Future<void> enable() async {}

  @override
  Future<Map<String, String>> resolve(List<RemoteMediaRef> refs) async =>
      const {};
}
