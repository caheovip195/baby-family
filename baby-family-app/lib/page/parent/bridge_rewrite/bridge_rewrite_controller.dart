import 'package:baby_family/data/model/us/rewrite_suggestion.dart';
import 'package:baby_family/data/provider/us.dart';
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

class BridgeRewriteController extends BaseNotifier {
  BridgeRewriteController(super.ref) {
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);

  bool loaded = false;
  bool hasError = false;
  RewriteSuggestion? suggestion;
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

  void select(RewriteTone value) {
    tone = value;
    edited = _textOf(value);
    revision++;
    notifyListeners();
  }

  void edit(String value) => edited = value;
}
