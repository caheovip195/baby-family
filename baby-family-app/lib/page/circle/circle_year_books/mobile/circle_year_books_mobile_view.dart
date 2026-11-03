import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/circle/circle_year_books/circle_year_books_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Sách năm của nhà: mỗi dòng một sách (tên sách / tên bé · năm), chạm để
/// đọc (chỉ đọc, xem trước PDF).
class CircleYearBooksMobileView extends HookConsumerWidget {
  const CircleYearBooksMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(circleYearBooksControllerProvider);
    final l10n = context.l10n;
    final books = controller.books;
    final Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (books == null) {
      body = const Center(child: CircleLoadingProgress());
    } else if (books.isEmpty) {
      body = Center(child: EmptyState(title: l10n.yearBookSharedEmpty));
    } else {
      final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
      body = ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screen),
        itemCount: books.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s3),
        itemBuilder: (context, index) {
          final book = books[index];
          final name = book.scope == 'FAMILY'
              ? l10n.yearBookFamilyTitle
              : book.name;
          return AppCard(
            child: InkWell(
              onTap: () => context.router.push(
                YearBookRoute(childId: book.childId, year: book.year),
              ),
              child: Row(
                spacing: AppSpacing.s3,
                children: [
                  Icon(
                    LucideIcons.bookHeart,
                    color: AppColors.resolve(context, kColorPrimary600C2513F),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title ?? name,
                          style: AppTypography.adapt(context, AppTypography.h3),
                        ),
                        Text(
                          '$name · ${book.year}',
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small.copyWith(color: secondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, size: 20, color: secondary),
                ],
              ),
            ),
          );
        },
      );
    }
    return BaseScaffold(
      backgroundColor: kColorBgFFFBF7,
      appBar: AppTopBar(title: l10n.yearBookShared),
      body: body,
    );
  }
}
