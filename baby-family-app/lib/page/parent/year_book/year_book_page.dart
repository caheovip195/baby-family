import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/year_book/mobile/year_book_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// REC-04
@RoutePage()
class YearBookPage extends BaseHookWidget {
  const YearBookPage({
    @QueryParam('childId') this.childId,
    @QueryParam('year') this.year,
    super.key,
  });

  /// null = sách cả nhà (người thân mở từ danh sách sách đã chia sẻ).
  final String? childId;
  final int? year;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return YearBookMobileView(childId: childId, year: year);
  }
}
