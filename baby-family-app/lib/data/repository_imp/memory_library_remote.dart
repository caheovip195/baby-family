import 'package:baby_family/data/model/memory/album_record.dart';
import 'package:baby_family/data/model/memory/download_url_record.dart';
import 'package:baby_family/data/model/memory/letter_record.dart';
import 'package:baby_family/data/model/memory/memory_prompt_record.dart';
import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:baby_family/data/model/memory/milestone_category_record.dart';
import 'package:baby_family/data/model/memory/monthly_photo_record.dart';
import 'package:baby_family/data/model/memory/perspective_record.dart';
import 'package:baby_family/data/model/recap/weekly_recap_record.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/memory_library_remote.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';

class MemoryLibraryRemoteRepositoryImp extends BaseRepositoryImp
    implements IMemoryLibraryRemoteRepository {
  @override
  Future<List<AlbumRecord>> albums(String familyId) async {
    final rs = await client!.getAlbums(familyId);
    return rs.list?.items ?? const [];
  }

  @override
  Future<AlbumRecord?> createAlbum(String familyId, String name) async {
    final rs = await client!.createAlbum(familyId, {'name': name});
    return rs.album;
  }

  @override
  Future<void> updateAlbum(String albumId, JsonMap patch) =>
      client!.updateAlbum(albumId, patch);

  @override
  Future<void> deleteAlbum(String albumId) => client!.deleteAlbum(albumId);

  @override
  Future<List<MemoryRecord>> albumMemories(String albumId) async {
    final rs = await client!.getAlbumMemories(
      albumId,
      limit: kValueRemoteFeedPageSize,
    );
    return rs.memories;
  }

  @override
  Future<void> addToAlbum(String albumId, List<String> memoryIds) =>
      client!.addAlbumMemories(albumId, {'memoryIds': memoryIds});

  @override
  Future<void> setFavorite(String memoryId, {required bool favorite}) =>
      favorite
      ? client!.addFavorite(memoryId)
      : client!.removeFavorite(memoryId);

  @override
  Future<List<MemoryRecord>> favorites(String familyId) async {
    final rs = await client!.getFavorites(
      familyId,
      limit: kValueRemoteFeedPageSize,
    );
    return rs.memories;
  }

  @override
  Future<List<DownloadUrlRecord>> downloadUrls(String memoryId) async {
    final rs = await client!.getDownloadUrls(memoryId);
    return rs.list?.items ?? const [];
  }

  @override
  Future<List<PerspectiveRecord>> perspectives(String memoryId) async {
    final rs = await client!.getPerspectives(memoryId);
    return rs.list?.items ?? const [];
  }

  @override
  Future<PerspectiveRecord?> putPerspective(
    String memoryId,
    String body,
  ) async {
    final rs = await client!.putPerspective(memoryId, {'body': body});
    return rs.perspective;
  }

  @override
  Future<List<MemoryPromptRecord>> prompts(
    String familyId, {
    String? childId,
  }) async {
    final rs = await client!.getMemoryPrompts(familyId, childId: childId);
    return rs.list?.items ?? const [];
  }

  @override
  Future<void> dismissPrompt(String code, {String? childId}) =>
      client!.dismissMemoryPrompt(code, {'childId': ?childId});

  @override
  Future<List<MilestoneCategoryRecord>> milestoneTemplates({
    String? childId,
  }) async {
    final rs = await client!.getMilestoneTemplates(childId: childId);
    return rs.catalog?.categories ?? const [];
  }

  @override
  Future<List<LetterRecord>> letters(String childId) async {
    final rs = await client!.getChildLetters(childId);
    return rs.letters;
  }

  @override
  Future<List<MemoryRecord>> pendingReview(String familyId) async {
    final rs = await client!.getPendingReview(familyId);
    return rs.memories;
  }

  @override
  Future<void> review(String memoryId, String action, JsonMap body) =>
      client!.reviewMemory(memoryId, action, body);

  @override
  Future<WeeklyRecapRecord?> latestWeeklyRecap(String familyId) async {
    try {
      return (await client!.getLatestWeeklyRecap(familyId)).recap;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<List<MonthlyPhotoRecord>> monthlyPhotos(String childId) async =>
      (await client!.getMonthlyPhotos(childId)).photos;

  @override
  Future<MonthlyPhotoRecord?> setMonthlyPhoto(
    String childId,
    int monthIndex, {
    required String memoryId,
    required String assetId,
  }) async => (await client!.setMonthlyPhoto(childId, monthIndex, {
    'memoryId': memoryId,
    'assetId': assetId,
  })).photo;
}
