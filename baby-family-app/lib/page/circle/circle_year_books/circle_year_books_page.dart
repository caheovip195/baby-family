import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/circle/circle_year_books/mobile/circle_year_books_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// REC-04 bản cho ông bà — danh sách sách đã chia sẻ (người thân).
@RoutePage()
class CircleYearBooksPage extends BaseHookWidget {
  const CircleYearBooksPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CircleYearBooksMobileView();
  }
}
