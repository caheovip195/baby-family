import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/gallery.dart';
import 'package:baby_family/data/repository/local_media_index.dart';
import 'package:baby_family/data/service/local_media.dart';
import 'package:baby_family/data/service_imp/local_media.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGallery implements IGalleryRepository {
  bool access = true;
  final items_ = <GalleryItem>[];
  final hashes = <String, String>{};
  final deleted = <String>{};
  final hashed = <String>[];
  int scans = 0;

  @override
  Future<bool> hasAccess() async => access;

  @override
  Future<bool> requestAccess() async => access = true;

  @override
  Future<List<GalleryItem>> items({int limit = 5000}) async {
    scans++;
    return items_;
  }

  @override
  Future<String?> sha256Of(String id) async {
    hashed.add(id);
    return hashes[id];
  }

  @override
  Future<String?> filePath(String id) async =>
      deleted.contains(id) ? null : '/gallery/$id';
}

class _FakeIndex implements ILocalMediaIndexRepository {
  JsonMap stored = {};
  int saves = 0;

  @override
  Future<JsonMap> load() async => stored;

  @override
  Future<void> save(JsonMap index) async {
    saves++;
    stored = index;
  }
}

void main() {
  final shot = DateTime.utc(2026, 10, 1, 8);
  const key = 'IMAGE|3024x4032|0';
  late _FakeGallery gallery;
  late _FakeIndex index;
  late LocalMediaServiceImp service;

  RemoteMediaRef ref(String sha, {DateTime? at}) =>
      RemoteMediaRef(assetId: 'asset-1', sha256: sha, key: key, capturedAt: at);

  setUp(() {
    gallery = _FakeGallery();
    index = _FakeIndex();
    service = LocalMediaServiceImp(
      gallery,
      index,
      AppClock.fixed(DateTime.utc(2026, 10, 21), frozen: true),
    );
  });

  test('matches the gallery original by SHA-256, not by file name', () async {
    gallery.items_.addAll([
      GalleryItem(id: 'a', key: key, createdAt: shot),
      GalleryItem(id: 'b', key: key, createdAt: shot),
    ]);
    gallery.hashes.addAll({'a': 'other', 'b': 'sha-1'});

    expect(await service.resolve([ref('sha-1', at: shot)]), {
      'asset-1': '/gallery/b',
    });
    expect((index.stored['assets'] as Map)['asset-1'], 'b');
  });

  test('a known match is reused without scanning or hashing again', () async {
    index.stored = {
      'assets': {'asset-1': 'b'},
    };
    expect(await service.resolve([ref('sha-1')]), {'asset-1': '/gallery/b'});
    expect(gallery.scans, 0);
    expect(gallery.hashed, isEmpty);
  });

  test('falls back to the server when the gallery copy was deleted', () async {
    index.stored = {
      'assets': {'asset-1': 'b'},
    };
    gallery.deleted.add('b');
    expect(await service.resolve([ref('sha-1')]), isEmpty);
    expect((index.stored['assets'] as Map).containsKey('asset-1'), isFalse);
  });

  test('capture time narrows candidates before hashing', () async {
    gallery.items_.addAll([
      GalleryItem(
        id: 'far',
        key: key,
        createdAt: shot.add(const Duration(hours: 1)),
      ),
      GalleryItem(
        id: 'near',
        key: key,
        createdAt: shot.add(const Duration(seconds: 1)),
      ),
    ]);
    gallery.hashes.addAll({'far': 'sha-1', 'near': 'sha-1'});
    expect(await service.resolve([ref('sha-1', at: shot)]), {
      'asset-1': '/gallery/near',
    });
    expect(gallery.hashed, ['near']);
  });

  test('a converted copy (SHA differs) matches only when unique by key and '
      'capture time', () async {
    gallery.items_.add(GalleryItem(id: 'heic', key: key, createdAt: shot));
    gallery.hashes['heic'] = 'heic-bytes';
    expect(await service.resolve([ref('jpeg-bytes', at: shot)]), {
      'asset-1': '/gallery/heic',
    });

    final twin = LocalMediaServiceImp(
      gallery..items_.add(GalleryItem(id: 'burst', key: key, createdAt: shot)),
      _FakeIndex(),
      AppClock.fixed(DateTime.utc(2026, 10, 21), frozen: true),
    );
    expect(await twin.resolve([ref('jpeg-bytes', at: shot)]), isEmpty);
  });

  test('a miss is not retried within a day; no access does nothing', () async {
    expect(await service.resolve([ref('sha-1')]), isEmpty);
    final saves = index.saves;
    expect(await service.resolve([ref('sha-1')]), isEmpty);
    expect(index.saves, saves);

    gallery.access = false;
    gallery.items_.add(GalleryItem(id: 'x', key: key, createdAt: shot));
    expect(await service.resolve([ref('sha-1')]), isEmpty);
  });
}
