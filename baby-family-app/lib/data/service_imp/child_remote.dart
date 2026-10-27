import 'package:baby_family/data/dto/fetal_size.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/child/child_archive_info.dart';
import 'package:baby_family/data/model/child/child_profile.dart';
import 'package:baby_family/data/model/memory/child_memory_stats.dart';
import 'package:baby_family/data/model/memory/week_summary.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository/pregnancy_remote.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/repository/subject.dart';
import 'package:baby_family/data/service_imp/child.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/data/service_imp/offline_read.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

/// Bé & thai kỳ qua server thật (ONB-04/05, CHD-*, PREG-*; tài liệu kỹ thuật
/// 11.3). Tạo/sửa gọi API trước, thành công mới ghi vào kho trên máy với id của
/// server. Danh sách khi mở app lấy từ `bootstrap.subjects`
/// ([SessionRemoteServiceImp]). Lưu trữ/xoá/sắp xếp, ảnh đại diện/ảnh bìa, số
/// đếm hồ sơ và kích thước thai theo tuần qua server (BF-20261019-001).
class ChildRemoteServiceImp extends ChildServiceImp {
  /// Bản đọc gần nhất cho màn phụ khi mất mạng (BF-20261026-007).
  final _reads = OfflineReads();

  ChildRemoteServiceImp(
    ISessionRepository sessionRepository,
    AppClock clock,
    this._children,
    IMemoryRepository memoryRepository,
    this._subjects,
    this._pregnancies,
    this._uploader,
  ) : super(sessionRepository, clock, _children, memoryRepository);

  final IChildRepository _children;
  final ISubjectRepository _subjects;
  final IPregnancyRemoteRepository _pregnancies;
  final MediaUploader _uploader;

  bool get _hasServerFamily =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] != null;

  static final _day = DateFormat('yyyy-MM-dd');

  String get _serverFamilyId {
    final id = sessionRepository.session()[kValueSessionKeyServerFamilyId];
    if (id is! String) {
      throw StateError('No server family for this session');
    }
    return id;
  }

  /// Màu bé trên server là 1…8, trên máy là chỉ số 0… của `kChildPalette`.
  static int serverColor(int localColor) => localColor % 8 + 1;

  static String serverGender(ChildGender gender) => switch (gender) {
    ChildGender.boy => 'MALE',
    ChildGender.girl => 'FEMALE',
    ChildGender.unknown => 'UNSPECIFIED',
  };

  /// BF-20261023-001: id từ route không được mở bé mẫu thuộc gia đình khác.
  @override
  Future<Child?> child(String id) async {
    final result = await super.child(id);
    return _hasServerFamily && result?.familyId != familyId ? null : result;
  }

  /// BF-20261023-001: hồ sơ chỉ đọc cho bé thuộc gia đình đang hoạt động.
  @override
  Future<ChildProfile?> profile(String childId) async {
    await ready();
    if (_hasServerFamily && await child(childId) == null) {
      return null;
    }
    return super.profile(childId);
  }

  /// BF-20261023-001: không dùng tác động lưu trữ mẫu cho id ngoài gia đình.
  @override
  Future<ChildArchiveInfo> archiveInfo(String childId) async {
    await ready();
    if (_hasServerFamily && await child(childId) == null) {
      return ChildArchiveInfo(childId: childId);
    }
    return super.archiveInfo(childId);
  }

  @override
  Future<Child> addChild({
    required String name,
    DateTime? birthDate,
    ChildGender gender = ChildGender.unknown,
    String? avatarAsset,
  }) async {
    await ready();
    final color = _children.children(familyId).length;
    final birth = birthDate ?? today;
    final record = await _subjects.createChild(_serverFamilyId, {
      'name': name.trim(),
      'birthDate': _day.format(birth),
      'gender': serverGender(gender),
      'colorIndex': serverColor(color),
    });
    return Child.fromJson(
      _children.addChild({
        'id': ?record?.id,
        'familyId': familyId,
        'name': name.trim(),
        'kind': ChildKind.baby.name,
        'birthDate': birth.toIso8601String(),
        'colorIndex': color,
        'gender': gender.name,
        'avatarAsset': ?avatarAsset,
      }),
    );
  }

  @override
  Future<Child> addPregnancy({
    required String name,
    DateTime? dueDate,
    int babyCount = 1,
  }) async {
    await ready();
    final rows = _children.children(familyId);
    final due = dueDate ?? dueDateFromWeek(20, today);
    final record = await _subjects.createPregnancy(_serverFamilyId, {
      'nickname': name.trim(),
      'dueDate': _day.format(due),
      'expectedCount': babyCount,
    });
    return Child.fromJson(
      _children.addChild({
        'id': ?record?.id,
        'familyId': familyId,
        'name': name.trim(),
        'kind': ChildKind.pregnancy.name,
        'dueDate': due.toIso8601String(),
        'colorIndex': rows.length,
        'carrierUserId': myUserId,
        'pregnancyOrder': record?.seqNo ?? rows.length + 1,
        'babyCount': record?.expectedCount ?? babyCount,
      }),
    );
  }

  @override
  Future<void> updateChild(Child child) async {
    final current = await this.child(child.id);
    if (current != null) {
      if (child.isPregnancy) {
        final patch = {
          if (child.name != current.name) 'nickname': child.name.trim(),
          if (child.dueDate != current.dueDate && child.dueDate != null)
            'dueDate': _day.format(child.dueDate!),
          if (child.babyCount != current.babyCount)
            'expectedCount': child.babyCount,
        };
        if (patch.isNotEmpty) {
          await _subjects.updatePregnancy(_serverFamilyId, child.id, patch);
        }
      } else {
        final patch = {
          if (child.name != current.name) 'name': child.name.trim(),
          if (child.birthDate != current.birthDate && child.birthDate != null)
            'birthDate': _day.format(child.birthDate!),
          if (child.gender != current.gender)
            'gender': serverGender(child.gender),
          if (child.colorIndex != current.colorIndex)
            'colorIndex': serverColor(child.colorIndex),
        };
        if (patch.isNotEmpty) {
          await _subjects.updateChild(_serverFamilyId, child.id, patch);
        }
      }
    }
    if (current != null && !child.isPregnancy) {
      await _syncImage(child.id, child.avatarAsset, current.avatarAsset, true);
      await _syncImage(child.id, child.coverAsset, current.coverAsset, false);
    }
    await super.updateChild(child);
  }

  /// Ảnh mới chọn từ máy → tải lên (AVATAR/COVER) rồi gắn cho bé; gỡ ảnh → null.
  /// Ảnh mẫu đi kèm app (`assets/…`) không tải lên.
  Future<void> _syncImage(
    String childId,
    String? next,
    String? previous,
    bool avatar,
  ) async {
    if (next == previous) {
      return;
    }
    String? assetId;
    if (next != null) {
      if (next.startsWith('assets/')) {
        return;
      }
      assetId = await _uploader.uploadImage(
        _serverFamilyId,
        next,
        purpose: avatar ? 'AVATAR' : 'COVER',
      );
    }
    if (avatar) {
      await _subjects.setChildAvatar(childId, assetId);
    } else {
      await _subjects.setChildCover(childId, assetId);
    }
  }

  /// CHD-01: số ký ức/cột mốc từ server (chỉ những gì tôi xem được); giọng nói
  /// và câu nói đếm trên bản phản chiếu.
  @override
  Future<ChildMemoryStats> stats(String childId) async {
    await ready();
    // BF-20261023-001: id ngoài gia đình không được đọc nền thống kê mẫu.
    final subject = await child(childId);
    if (_hasServerFamily && subject == null) {
      return ChildMemoryStats(childId: childId);
    }
    final local = await super.stats(childId);
    // Thai kỳ không có `profile-stats` (chỉ cho bé): gọi sẽ 404 làm hỏng cả
    // màn hành trình thai kỳ (BF-20261026-001).
    if (subject?.kind == ChildKind.pregnancy) {
      return local;
    }
    final remote = await whenOnline(
      () => _subjects.childStats(childId),
      what: 'thống kê bé',
    );
    if (remote == null) {
      return local;
    }
    return local.copyWith(
      memories: remote.memoryCount,
      firsts: remote.milestoneCount,
    );
  }

  /// PREG-01: kích thước thai tuần này từ server (đã dịch; tắt nội dung kích
  /// thước → null).
  @override
  Future<FetalSize?> fetalSize(String pregnancyId) async {
    final journey = await _reads.read([
      'journey',
      pregnancyId,
    ], () => _pregnancies.journey(pregnancyId));
    final size = journey?.week?.size;
    final week = journey?.week?.number ?? journey?.currentWeek;
    if (size == null || week == null) {
      return null;
    }
    return FetalSize(
      week: week,
      emoji: size.emoji ?? '',
      fruit: size.label ?? '',
      lengthCm: (size.lengthCm ?? 0).round(),
    );
  }

  @override
  Future<void> archiveChild(String childId) async {
    await _subjects.archiveChild(childId);
    await super.archiveChild(childId);
  }

  @override
  Future<void> restoreChild(String childId) async {
    await _subjects.restoreChild(childId);
    await super.restoreChild(childId);
  }

  /// Server yêu cầu nhập lại đúng tên bé và bé đã lưu trữ đủ 7 ngày.
  @override
  Future<void> deleteChild(String childId) async {
    final current = await child(childId);
    await _subjects.deleteChild(childId, confirmName: current?.name ?? '');
    await super.deleteChild(childId);
  }

  /// CHD-03: server chỉ nhận các bé đã chào đời đang hoạt động.
  @override
  Future<void> reorderChildren(List<String> childIds) async {
    final active = {
      for (final row in _children.children(familyId))
        if (row['kind'] != ChildKind.pregnancy.name && row['archived'] != true)
          row['id'] as String,
    };
    await _subjects.reorderChildren(_serverFamilyId, [
      for (final id in childIds)
        if (active.contains(id)) id,
    ]);
    await super.reorderChildren(childIds);
  }

  /// Gia đình thật không cộng số liệu/ảnh mẫu của fixture (BF-20261022-006).
  @override
  JsonMap? get weekBaseline => null;

  /// HOME-01 “Tuần này”: số khoảnh khắc và lần đầu từ server (đúng quyền
  /// xem); câu nói và ảnh nhỏ từ ký ức đã đồng bộ. Lỗi mạng giữ số trên máy.
  @override
  Future<WeekSummary> weekSummary() async {
    final local = await super.weekSummary();
    final serverFamilyId =
        sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;
    if (serverFamilyId == null) {
      return local;
    }
    try {
      final stats = await _subjects.weekStats(serverFamilyId);
      return stats == null
          ? local
          : local.copyWith(
              moments: stats.memoryCount,
              firsts: stats.milestoneCount,
            );
    } on DioException catch (error) {
      Logger().w('Không đọc được số liệu tuần: ${error.message}');
      return local;
    }
  }
}
