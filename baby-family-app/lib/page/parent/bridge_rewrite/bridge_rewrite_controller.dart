import 'package:baby_family/data/model/us/rewrite_option.dart';
import 'package:baby_family/data/model/us/rewrite_suggestion.dart';
import 'package:baby_family/data/provider/ai.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/ai.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-09 — Viết lại nhẹ nhàng [AI 1.2] (Pencil `cRWCh`, mục 7.18): câu gốc →
/// 3 phiên bản Trung tính / Ấm áp / Ngắn gọn → sửa → dùng. Không gửi gì tự
/// động: màn trả câu đã chọn về US-08 (hoặc câu gốc).
final bridgeRewriteControllerProvider =
    ChangeNotifierProvider.autoDispose<BridgeRewriteController>(
      BridgeRewriteController.new,
    );

/// Kết quả AI cho câu có dấu hiệu không an toàn: mở màn hỗ trợ (US-13).
class RewriteNeedsSafety implements Exception {
  const RewriteNeedsSafety();
}

class BridgeRewriteController extends BaseNotifier {
  BridgeRewriteController(super.ref) {
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);
  IAiService get aiService => ref.read(aiServiceProvider);

  bool loaded = false;
  bool hasError = false;
  RewriteSuggestion? suggestion;
  bool _fromAi = false;

  /// Lượt AI của ba phiên bản đang hiện (để “Báo cáo nội dung AI”).
  String? aiInvocationId;

  /// Báo cáo các phiên bản AI đang hiện; bản mẫu (không có lượt) bỏ qua.
  Future<void> reportAi() async {
    final id = aiInvocationId;
    final options = suggestion?.options ?? const [];
    if (id == null) {
      return;
    }
    await aiService.report(
      invocationId: id,
      text: [for (final option in options) option.text].join('\n'),
    );
  }

  RewriteTone tone = RewriteTone.neutral;

  /// Nội dung ô “Sửa trước khi dùng”.
  String edited = '';

  /// Tăng mỗi khi chọn phiên bản khác để ô sửa nạp lại nội dung.
  int revision = 0;

  Future<void> load() async {
    hasError = false;
    try {
      final value = await usService.rewriteSuggestion();
      if (isDisposed) {
        return;
      }
      // Bản AI (câu gốc từ US-08) đã nạp: không ghi đè bằng bản mẫu.
      if (_fromAi) {
        return;
      }
      suggestion = value;
      tone = value?.selected ?? RewriteTone.neutral;
      edited = value?.edited ?? _textOf(tone);
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  String _textOf(RewriteTone value) =>
      suggestion?.options
          .where((option) => option.tone == value)
          .firstOrNull
          ?.text ??
      '';

  /// AI 1.2 (BF-20261028-010): ba phiên bản từ câu gốc [original]. Ném
  /// [AiConsentRequired] (lần đầu) / [RewriteNeedsSafety] cho màn xử lý.
  Future<void> loadAi(String original) async {
    _fromAi = true;
    hasError = false;
    loaded = false;
    notifyListeners();
    try {
      final draft = await aiService.rewrite(original);
      if (isDisposed) {
        return;
      }
      if (draft.safety) {
        throw const RewriteNeedsSafety();
      }
      aiInvocationId = draft.invocationId;
      suggestion = RewriteSuggestion(
        original: original,
        options: [
          for (final (tone, text) in [
            (RewriteTone.neutral, draft.neutral),
            (RewriteTone.warm, draft.warm),
            (RewriteTone.short, draft.short),
          ])
            if (text != null && text.trim().isNotEmpty)
              RewriteOption(tone: tone, text: text),
        ],
      );
      tone = suggestion!.options.firstOrNull?.tone ?? RewriteTone.neutral;
      edited = _textOf(tone);
      revision++;
    } on AiConsentRequired {
      rethrow;
    } on RewriteNeedsSafety {
      rethrow;
    } catch (_) {
      if (!isDisposed) {
        hasError = true;
      }
    } finally {
      if (!isDisposed) {
        loaded = true;
        notifyListeners();
      }
    }
  }

  void select(RewriteTone value) {
    tone = value;
    edited = _textOf(value);
    revision++;
    notifyListeners();
  }

  void edit(String value) => edited = value;
}
