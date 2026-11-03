import 'package:baby_family/data/model/year_book/year_book.dart';
import 'package:baby_family/data/provider/year_book.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// REC-04 bản cho ông bà (BF-20261030-002): sách năm Bố Mẹ đã chia sẻ mà
/// người thân được xem.
final circleYearBooksControllerProvider =
    ChangeNotifierProvider.autoDispose<CircleYearBooksController>(
      CircleYearBooksController.new,
    );

class CircleYearBooksController extends BaseNotifier {
  CircleYearBooksController(super.ref) {
    Future.microtask(load);
  }

  List<YearBookSummary>? books;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final value = await ref.read(yearBookServiceProvider).books();
      if (isDisposed) {
        return;
      }
      books = value.where((book) => book.sharedWithCircle).toList();
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }
}
