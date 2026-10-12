import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

bool _isOffline(List<ConnectivityResult> results) =>
    results.isEmpty ||
    results.every((result) => result == ConnectivityResult.none);

/// `true` khi thiết bị mất mạng — băng STATE-05 (Pencil UmR4I) dưới app bar.
/// Lỗi plugin (test, nền tảng không hỗ trợ) được coi là đang có mạng.
final isOfflineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  try {
    yield _isOffline(await connectivity.checkConnectivity());
  } on Object {
    yield false;
    return;
  }
  yield* connectivity.onConnectivityChanged
      .map(_isOffline)
      .handleError((Object _) {});
});
