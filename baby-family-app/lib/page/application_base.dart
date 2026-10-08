import 'package:baby_family/data/dto/result.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Controller cơ sở của mọi màn (Page → Controller → Service → Repository).
///
/// Dùng với `ChangeNotifierProvider.autoDispose` (hooks_riverpod/legacy.dart).
abstract class BaseNotifier extends ChangeNotifier {
  BaseNotifier(this.ref);

  final Ref ref;

  bool isLoading = false;
  bool _isDispose = false;

  /// `true` sau khi provider đã bị dispose (người dùng rời màn khi request còn
  /// chạy). LUÔN kiểm tra sau mỗi `await` trước khi dùng [ref].
  bool get isDisposed => _isDispose;

  Future<T> whileLoading<T>(Future<T> Function() future) {
    return Future.microtask(
      toLoading,
    ).then((_) => future()).whenComplete(toIdle);
  }

  @override
  void dispose() {
    _isDispose = true;
    super.dispose();
  }

  void toLoading() {
    if (isLoading) {
      return;
    }
    isLoading = true;
    notifyListeners();
  }

  void toIdle() {
    if (!isLoading) {
      return;
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (_isDispose) {
      return;
    }
    super.notifyListeners();
  }

  Future<Result<T>> callFuture<T>(Future<T> future, {bool withLoading = true}) {
    if (withLoading) {
      return whileLoading(() => Result.guardFuture<T>(() async => future));
    }
    return Result.guardFuture<T>(() async => future);
  }
}

abstract class BaseHookWidget extends HookConsumerWidget {
  const BaseHookWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return buildWidget(context, ref);
  }

  Widget buildWidget(BuildContext context, WidgetRef ref);
}

abstract class BaseHookStateWidget<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  Widget buildWidget(BuildContext context);
}

abstract class BaseHookStateFull<T extends ConsumerState>
    extends StatefulHookConsumerWidget {
  const BaseHookStateFull({super.key});
}
