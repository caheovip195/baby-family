import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Hành động QC-01 cần tab đích xử lý sau khi Main shell chuyển tab
/// (ví dụ `checkin` → CoupleTab mở sheet US-02). Tab đọc rồi gọi [consume].
final pendingQuickActionProvider =
    NotifierProvider<PendingQuickActionNotifier, QuickCreateAction?>(
      PendingQuickActionNotifier.new,
    );

class PendingQuickActionNotifier extends Notifier<QuickCreateAction?> {
  @override
  QuickCreateAction? build() => null;

  void request(QuickCreateAction action) => state = action;

  /// Lấy và xoá hành động đang chờ.
  QuickCreateAction? consume() {
    final value = state;
    state = null;
    return value;
  }
}
