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

/// Thư viện ký ức trên server (BF-20261019-002): album, yêu thích, tải bản gốc,
/// góc nhìn thứ hai, gợi ý ghi lại, cột mốc, thư gửi con.
abstract class IMemoryLibraryRemoteRepository extends IBaseRepository {
  Future<List<AlbumRecord>> albums(String familyId);

  Future<AlbumRecord?> createAlbum(String familyId, String name);

  Future<void> updateAlbum(String albumId, JsonMap patch);

  Future<void> deleteAlbum(String albumId);

  Future<List<MemoryRecord>> albumMemories(String albumId);

  Future<void> addToAlbum(String albumId, List<String> memoryIds);

  Future<void> setFavorite(String memoryId, {required bool favorite});

  Future<List<MemoryRecord>> favorites(String familyId);

  Future<List<DownloadUrlRecord>> downloadUrls(String memoryId);

  Future<List<PerspectiveRecord>> perspectives(String memoryId);

  Future<PerspectiveRecord?> putPerspective(String memoryId, String body);

  Future<List<MemoryPromptRecord>> prompts(String familyId, {String? childId});

  Future<void> dismissPrompt(String code, {String? childId});

  Future<List<MilestoneCategoryRecord>> milestoneTemplates({String? childId});

  Future<List<LetterRecord>> letters(String childId);

  /// MEM-19: ảnh người thân đăng đang chờ duyệt.
  Future<List<MemoryRecord>> pendingReview(String familyId);

  /// [action] = `approve` | `reject`.
  Future<void> review(String memoryId, String action, JsonMap body);

  /// REC-02: recap tuần mới nhất; null khi chưa có (404).
  Future<WeeklyRecapRecord?> latestWeeklyRecap(String familyId);

  /// MEM-20: ảnh tháng của bé.
  Future<List<MonthlyPhotoRecord>> monthlyPhotos(String childId);

  /// MEM-21: đặt ký ức [memoryId] (ảnh [assetId]) làm ảnh tháng [monthIndex].
  Future<MonthlyPhotoRecord?> setMonthlyPhoto(
    String childId,
    int monthIndex, {
    required String memoryId,
    required String assetId,
  });
}
