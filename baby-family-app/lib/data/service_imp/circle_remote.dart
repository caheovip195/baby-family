import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/model/circle/circle_post_draft.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository/notification.dart';
import 'package:baby_family/data/repository/onboarding.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/data/service_imp/circle.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';

/// App của người thân qua server (BF-20261019-005): CIR-01…06, CIR-05, SET-10.
///
/// Ký ức đọc từ bảng tin server (đã lọc theo quyền Circle) qua
/// [IMemoryService] bản server rồi dùng lại logic hiển thị của
/// [CircleServiceImp]; lời chúc / thả tim / đăng ảnh đi qua API ký ức. Tư cách
/// người thân (đang chờ, tạm dừng, bé được cấp quyền) phản chiếu từ
/// `GET /v1/me/circles` khi phiên đồng bộ ([ISessionService.restore]).
/// Tuỳ chọn thông báo/bản tin (CIR-06) còn trên máy.
class CircleRemoteServiceImp extends CircleServiceImp {
  CircleRemoteServiceImp(
    ISessionRepository sessionRepository,
    AppClock clock,
    IFamilyRepository familyRepository,
    IChildRepository childRepository,
    this._store,
    INotificationRepository notificationRepository,
    this._memories,
    this._onboarding,
    this._session,
  ) : super(
        sessionRepository,
        clock,
        familyRepository,
        childRepository,
        _store,
        notificationRepository,
      );

  final IMemoryRepository _store;
  final IMemoryService _memories;
  final IOnboardingRepository _onboarding;
  final ISessionService _session;

  DateTime? _checkedAt;

  String? get _serverFamilyId =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;

  /// CIR-05: tư cách người thân (tạm dừng, bé được cấp quyền) đọc lại tối đa
  /// mỗi [kValueRemoteFeedRefreshInterval] — Bố/Mẹ đổi quyền hoặc gói hết hạn
  /// thì màn đang mở biết ngay ở lần tải sau.
  Future<void> _refreshMembership() async {
    final checked = _checkedAt;
    if (checked != null &&
        now.difference(checked) < kValueRemoteFeedRefreshInterval) {
      return;
    }
    _checkedAt = now;
    await _session.restore();
  }

  @override
  Future<CircleView?> view({String? childId}) async {
    await _refreshMembership();
    if (_serverFamilyId != null &&
        _session.current.state == SessionState.circleActive) {
      // Bảng tin server → kho trên máy (lỗi mạng giữ dữ liệu đang có).
      await _memories.memories(childId: childId);
    }
    final current = await super.view(childId: childId);
    if (current == null) {
      return null;
    }
    // Ảnh tôi gửi đang chờ Bố/Mẹ duyệt (MEM-19) chưa hiện cho cả nhà.
    return CircleView(
      family: current.family,
      viewer: current.viewer,
      children: current.children,
      memories: [
        for (final memory in current.memories)
          if (_store.memory(memory.id)?['remoteStatus'] != _pendingReview)
            memory,
      ],
    );
  }

  @override
  Future<MemoryComment?> sendWish(String memoryId, String body) async {
    if (_serverFamilyId == null) {
      return super.sendWish(memoryId, body);
    }
    final viewer = (await super.view())?.viewer;
    if (viewer == null || !viewer.canComment) {
      return null;
    }
    return _memories.addComment(memoryId, body);
  }

  @override
  Future<List<MemoryComment>> wishes(String memoryId) => _serverFamilyId == null
      ? super.wishes(memoryId)
      : _memories.comments(memoryId);

  @override
  Future<void> toggleHeart(String memoryId) => _serverFamilyId == null
      ? super.toggleHeart(memoryId)
      : _memories.react(memoryId, kValueHeartReaction);

  /// CIR-04: tải ảnh (MEMORY) + tạo khoảnh khắc `FAMILY`; server đưa vào
  /// hàng chờ duyệt và báo Bố/Mẹ (MEM-19).
  @override
  Future<void> submitPost(CirclePostDraft post) async {
    if (_serverFamilyId == null) {
      return super.submitPost(post);
    }
    await _memories.create(
      kind: MemoryKind.photo,
      childIds: post.childIds,
      body: post.message.trim().isEmpty ? null : post.message.trim(),
      mediaAssets: post.mediaAssets,
      occurredAt: post.takenAt,
    );
  }

  @override
  Future<CirclePostDraft> postDraft() async {
    if (_serverFamilyId == null) {
      return super.postDraft();
    }
    // Bản server không điền sẵn ảnh mẫu.
    return const CirclePostDraft();
  }

  /// SET-10: rời gia đình trên server rồi về CIR-WAIT. Gỡ nội dung đã đăng
  /// ([removeContent]) chưa có API — nội dung được giữ cho gia đình.
  @override
  Future<void> leaveFamily({bool removeContent = false}) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId != null) {
      await _onboarding.leaveCircle(serverFamilyId);
      sessionRepository.patchSession({kValueSessionKeyServerFamilyId: null});
    }
    await super.leaveFamily(removeContent: removeContent);
  }

  static const _pendingReview = 'PENDING_REVIEW';
}
