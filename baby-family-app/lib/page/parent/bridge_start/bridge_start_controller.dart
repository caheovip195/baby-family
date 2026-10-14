import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/bridge_option.dart';
import 'package:baby_family/data/model/us/bridge_session.dart';
import 'package:baby_family/data/model/us/bridge_share.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-08 — Cầu nối: giai đoạn riêng tư (Pencil `Is4I7` = bước 3/5, mục
/// 7.17.1): 1 cảm xúc → 2 chủ đề (tuỳ chọn) → 3 nhu cầu + nháp riêng → 4 làm
/// gì với nội dung (Giữ riêng / Viết lại US-09 / Chọn ý chia sẻ) → 5 xem trước
/// chính xác rồi “Gửi lời mời”. Không gì được gửi trước bước 5; nháp riêng
/// không bao giờ được gửi (BR-030). “Mình cảm thấy không an toàn” → US-13.
final bridgeStartControllerProvider =
    ChangeNotifierProvider.autoDispose<BridgeStartController>(
      BridgeStartController.new,
    );

class BridgeStartController extends BaseNotifier {
  BridgeStartController(super.ref) {
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  bool loaded = false;
  bool hasError = false;
  bool sending = false;

  /// Bước hiện tại 1…[kValueBridgeWizardSteps].
  int step = 1;

  BridgeSession? draft;
  Member? me;
  Member? partner;
  List<BridgeOption> feelingOptions = const [];
  List<BridgeOption> needOptions = const [];

  /// Chủ đề đã dịch, “Chăm {child}” tách theo từng bé (mục 7.17.1 bước 3).
  List<String> topicOptions = const [];

  Set<String> feelings = {};
  Set<String> needs = {};
  String? topic;
  String privateNote = '';
  String message = '';

  /// Bước 5: các ý đang chọn chia sẻ (mặc định tất cả ý đã chọn).
  Set<String> sharedFeelings = {};
  Set<String> sharedNeeds = {};

  String get partnerName => partner?.callName ?? '';

  String titleOf(List<BridgeOption> options, String code) =>
      options.where((option) => option.code == code).firstOrNull?.title ?? code;

  List<BridgeOption> selected(List<BridgeOption> options, Set<String> codes) =>
      options.where((option) => codes.contains(option.code)).toList();

  Future<void> load() async {
    hasError = false;
    try {
      final (saved, mine, other, feels, wants, topics, kids) = await (
        usService.bridgeDraft(),
        familyService.me(),
        familyService.partner(),
        usService.bridgeOptions('feelings'),
        usService.bridgeOptions('needs'),
        usService.bridgeOptions('topics'),
        ref.read(childServiceProvider).children(),
      ).wait;
      if (isDisposed) {
        return;
      }
      me = mine;
      partner = other;
      feelingOptions = feels;
      needOptions = wants;
      topicOptions = [
        for (final option in topics)
          if (option.title.contains('{child}'))
            for (final child in kids.where((kid) => !kid.isPregnancy))
              option.title.replaceAll('{child}', child.name)
          else
            option.title,
      ];
      draft = saved;
      final share = saved?.shares
          .where((item) => item.userId == mine?.userId)
          .firstOrNull;
      step = (saved?.wizardStep ?? 1).clamp(1, kValueBridgeWizardSteps);
      feelings = {...?share?.feelings};
      needs = {...?share?.needs};
      topic = share?.topic;
      message = share?.message ?? '';
      privateNote = saved?.privateNote ?? '';
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void toggleFeeling(String code) {
    if (!feelings.remove(code)) {
      feelings.add(code);
    }
    notifyListeners();
  }

  void toggleNeed(String code) {
    if (!needs.remove(code)) {
      needs.add(code);
    }
    notifyListeners();
  }

  void selectTopic(String value) {
    topic = topic == value ? null : value;
    notifyListeners();
  }

  void setPrivateNote(String value) => privateNote = value;

  void setMessage(String value) {
    message = value;
    notifyListeners();
  }

  void toggleShared(Set<String> shared, String code) {
    if (!shared.remove(code)) {
      shared.add(code);
    }
    notifyListeners();
  }

  void goTo(int value) {
    step = value.clamp(1, kValueBridgeWizardSteps);
    if (step == kValueBridgeWizardSteps) {
      sharedFeelings = {...feelings};
      sharedNeeds = {...needs};
    }
    notifyListeners();
    _saveDraft();
  }

  void next() => goTo(step + 1);

  /// Nút back của thanh trên: lùi một bước; `false` ở bước 1 (rời màn).
  bool back() {
    if (step <= 1) {
      return false;
    }
    goTo(step - 1);
    return true;
  }

  /// Câu đã viết lại ở US-09 → lời nhắn chia sẻ, sang bước xem trước.
  void useRewrite(String text) {
    message = text;
    goTo(kValueBridgeWizardSteps);
  }

  BridgeSession _composeDraft({
    List<String>? shareFeelings,
    List<String>? shareNeeds,
  }) {
    final userId = me?.userId ?? '';
    final base =
        draft ??
        BridgeSession(
          id: 'br-${ref.read(appClockProvider).now().microsecondsSinceEpoch}',
          initiatorUserId: userId,
        );
    return base.copyWith(
      status: BridgeStatus.draft,
      wizardStep: step,
      privateNote: privateNote,
      shares: [
        BridgeShare(
          userId: userId,
          feelings: shareFeelings ?? feelings.toList(),
          needs: shareNeeds ?? needs.toList(),
          topic: topic,
          message: message.trim().isEmpty ? null : message.trim(),
        ),
      ],
    );
  }

  /// Lưu nháp riêng (chỉ người bắt đầu thấy) — “Dừng lại”, đổi bước, Giữ riêng.
  Future<void> _saveDraft() async {
    final value = _composeDraft();
    draft = value;
    try {
      await usService.saveBridgeDraft(value);
    } catch (_) {
      // Nháp chỉ là tiện ích; lỗi lưu không chặn người dùng.
    }
  }

  Future<void> keepPrivate() => _saveDraft();

  /// Bước 5 “Gửi lời mời”: chỉ gửi các ý đã chọn chia sẻ + lời nhắn (đã xem
  /// trước); trả về phiên chung để mở US-11 (phiên đang diễn ra của hai người
  /// nếu có, nếu không là phiên vừa mời).
  Future<String?> send() async {
    if (sending) {
      return null;
    }
    sending = true;
    notifyListeners();
    try {
      final value = _composeDraft(
        shareFeelings: feelings.where(sharedFeelings.contains).toList(),
        shareNeeds: needs.where(sharedNeeds.contains).toList(),
      );
      await usService.saveBridgeDraft(value);
      await usService.sendBridgeInvite(value.id);
      final sessions = await usService.bridgeSessions();
      final live = sessions
          .where(
            (session) =>
                session.status == BridgeStatus.active ||
                session.status == BridgeStatus.nextStep,
          )
          .firstOrNull;
      return live?.id ?? value.id;
    } catch (_) {
      return null;
    } finally {
      if (!isDisposed) {
        sending = false;
        notifyListeners();
      }
    }
  }
}
