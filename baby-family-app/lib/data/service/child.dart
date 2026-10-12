import 'package:baby_family/data/dto/fetal_size.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/child/child_archive_info.dart';
import 'package:baby_family/data/model/child/child_profile.dart';
import 'package:baby_family/data/model/memory/chapter_summary.dart';
import 'package:baby_family/data/model/memory/child_memory_stats.dart';
import 'package:baby_family/data/model/memory/week_summary.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Hồ sơ bé & thai kỳ (ONB-05a/b, SW-01, FAM-01, HOME-02/03).
abstract class IChildService extends IBaseService {
  /// “Hôm nay” của dữ liệu (mock: 07/10/2026) — truyền cho `child_age.dart`.
  DateTime get today;

  /// Các bé + thai kỳ theo thứ tự tạo (bỏ thai kỳ đã lưu trữ nếu
  /// [includeArchived] = false).
  Future<List<Child>> children({bool includeArchived = false});

  Future<Child?> child(String id);

  /// ONB-05b / “Thêm con”.
  Future<Child> addChild({
    required String name,
    DateTime? birthDate,
    ChildGender gender = ChildGender.unknown,
    String? avatarAsset,
  });

  /// ONB-05a / “Thêm thai kỳ”.
  Future<Child> addPregnancy({
    required String name,
    DateTime? dueDate,
    int babyCount = 1,
  });

  Future<void> updateChild(Child child);

  /// Số ký ức/lần đầu/ghi âm/câu nói của bé (MEM-01 header, HOME-02).
  Future<ChildMemoryStats> stats(String childId);

  /// Chương theo tháng tuổi, mới nhất trước (MEM-01).
  Future<List<ChapterSummary>> chapters(String childId);

  /// “Tuần này của nhà mình” (HOME-01).
  Future<WeekSummary> weekSummary();

  /// Kích thước thai tham khảo của tuần hiện tại (HOME-03); null khi chưa có
  /// dữ liệu cho tuần thai này.
  Future<FetalSize?> fetalSize(String pregnancyId);

  // --- Batch 2 (CHD-01…04) ---

  /// CHD-01/02: hồ sơ chi tiết (tên khai sinh, câu chuyện tên, sở thích…).
  Future<ChildProfile?> profile(String childId);

  Future<void> saveProfile(ChildProfile profile);

  /// CHD-03: hồ sơ đã lưu trữ.
  Future<List<Child>> archivedChildren();

  Future<void> archiveChild(String childId);

  Future<void> restoreChild(String childId);

  /// CHD-03: sắp xếp thứ tự hiển thị (kéo thả).
  Future<void> reorderChildren(List<String> childIds);

  // --- Batch 3 (CHD-05) ---

  /// Tác động khi lưu trữ / xoá vĩnh viễn; `deletableFrom` = lưu trữ + 7 ngày.
  Future<ChildArchiveInfo> archiveInfo(String childId);

  /// CHD-05b: xoá vĩnh viễn (chỉ khi đã lưu trữ đủ 7 ngày — mock không chặn).
  Future<void> deleteChild(String childId);
}
