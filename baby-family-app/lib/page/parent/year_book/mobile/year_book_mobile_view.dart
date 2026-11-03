import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/year_book/year_book.dart';
import 'package:baby_family/page/parent/year_book/year_book_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_check_mark.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_text_action.dart';
import 'package:baby_family/utils/widget/app_text_input_sheet.dart';
import 'package:baby_family/utils/widget/app_toggle_row.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/year_book_item_tile.dart';
part '../widgets/year_book_share_card.dart';

/// REC-04 — Sách của con: tiêu đề + tên bé, chọn năm, tên sách, chương theo
/// tháng (chọn/bỏ ký ức, ảnh, sửa chú thích), thanh dưới “Lưu” / “Xuất PDF”.
class YearBookMobileView extends HookConsumerWidget {
  const YearBookMobileView({required this.childId, this.year, super.key});

  /// null = sách cả nhà.
  final String? childId;
  final int? year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(yearBookControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(childId, atYear: year));
      return null;
    }, [childId, year]);

    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError || controller.book == null) {
      body = ErrorState(onRetry: controller.load);
    } else {
      body = Column(
        children: [
          Expanded(child: _content(context, controller)),
          _ActionBar(controller: controller),
        ],
      );
    }
    return BaseScaffold(
      backgroundColor: kColorBgFFFBF7,
      appBar: const AppTopBar(),
      body: body,
    );
  }

  Widget _content(BuildContext context, YearBookController controller) {
    final l10n = context.l10n;
    final book = controller.book!;
    final name = _subjectName(controller, book);
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    Future<void> editTitle() async {
      final value = await showAppTextInputSheet(
        context,
        title: l10n.yearBookBookName,
        actionLabel: l10n.commonSave,
        initialValue: book.title ?? _defaultTitle(context, book, name),
      );
      if (value != null) {
        controller.setTitle(value);
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s2,
        AppSpacing.screen,
        AppSpacing.s8,
      ),
      children: [
        Text(
          book.isFamily ? l10n.yearBookFamilyTitle : l10n.yearBookTitle,
          style: AppTypography.adapt(
            context,
            AppTypography.display.copyWith(fontSize: 24),
          ),
        ),
        Text(
          name,
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(color: secondary),
          ),
        ),
        const SizedBox(height: AppSpacing.s3),
        // Spec REC-04 “chọn bé/cả nhà” (người thân đọc đúng một bản).
        if (!controller.readOnly && controller.childId != null)
          Row(
            spacing: AppSpacing.s2,
            children: [
              AppSelectableChip(
                label: controller.child?.name ?? l10n.yearBookTitle,
                selected: !controller.family,
                onPressed: () => controller.setFamily(false),
              ),
              AppSelectableChip(
                label: l10n.yearBookFamily,
                selected: controller.family,
                onPressed: () => controller.setFamily(true),
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.s2),
        if (!controller.readOnly)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: AppSpacing.s2,
              children: [
                for (final year in controller.years)
                  AppSelectableChip(
                    label: '$year',
                    selected: year == controller.year,
                    onPressed: () => controller.setYear(year),
                  ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.s4),
        AppCard(
          child: InkWell(
            onTap: controller.readOnly ? null : editTitle,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    book.title ?? _defaultTitle(context, book, name),
                    style: AppTypography.adapt(context, AppTypography.h3),
                  ),
                ),
                if (!controller.readOnly)
                  Icon(LucideIcons.pencil, size: 18, color: secondary),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s3),
        if (!controller.readOnly) ...[
          _ShareCard(controller: controller),
          const SizedBox(height: AppSpacing.s3),
        ],
        if (!book.canExport && !controller.readOnly) ...[
          AppInfoNote(icon: LucideIcons.lock, text: l10n.yearBookPreviewOnly),
          Align(
            alignment: Alignment.centerLeft,
            child: AppTextAction(
              label: l10n.yearBookUpgrade,
              onPressed: () => context.router.push(const UpgradePlanRoute()),
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
        ],
        if (book.pending) ...[
          AppInfoNote(icon: LucideIcons.cloudOff, text: l10n.yearBookPending),
          const SizedBox(height: AppSpacing.s3),
        ],
        if (book.chapters.isEmpty)
          EmptyState(
            title: book.isFamily
                ? l10n.yearBookFamilyEmpty
                : l10n.yearBookEmpty,
          )
        else ...[
          Text(
            controller.readOnly
                ? l10n.yearBookSelected('${book.includedCount}')
                : '${l10n.yearBookSelected('${book.includedCount}')} · '
                      '${l10n.yearBookHint}',
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(color: secondary),
            ),
          ),
          for (final chapter in book.chapters)
            _ChapterSection(controller: controller, chapter: chapter),
        ],
      ],
    );
  }
}

class _ChapterSection extends StatelessWidget {
  const _ChapterSection({required this.controller, required this.chapter});

  final YearBookController controller;
  final YearBookChapter chapter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final heading = chapter.title ?? l10n.yearBookChapter('${chapter.month}');
    Future<void> rename() async {
      final value = await showAppTextInputSheet(
        context,
        title: l10n.yearBookChapterName,
        actionLabel: l10n.commonSave,
        initialValue: heading,
      );
      if (value != null) {
        controller.setChapterTitle(chapter.month, value);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s3,
        children: [
          InkWell(
            onTap: controller.readOnly ? null : rename,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    heading,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.h3.copyWith(
                        color: AppColors.resolve(
                          context,
                          kColorPrimary600C2513F,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!controller.readOnly)
                  Icon(
                    LucideIcons.pencil,
                    size: 16,
                    color: AppColors.resolve(context, kColorTextTertiary9C928A),
                  ),
              ],
            ),
          ),
          for (final item in chapter.items)
            _YearBookItemTile(
              controller: controller,
              month: chapter.month,
              item: item,
            ),
        ],
      ),
    );
  }
}

/// “Lưu” khi có thay đổi (Parent); “Xem trước” khi sách có ký ức.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.controller});

  final YearBookController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final book = controller.book!;
    final name = _subjectName(controller, book);
    Future<void> save() async {
      try {
        final sent = await controller.save();
        if (context.mounted) {
          showAppSnackBar(
            context,
            sent ? l10n.setChangesSaved : l10n.yearBookPending,
          );
        }
      } on Object catch (error) {
        if (context.mounted) {
          showAppSnackBar(context, actionErrorMessage(error));
        }
      }
    }

    Future<void> preview() async {
      final locale = l10n.localeName;
      final title = book.title ?? _defaultTitle(context, book, name);
      try {
        final bytes = await controller.buildPdf(
          title: title,
          subtitle: l10n.yearBookPdfSubtitle,
          chapterHeading: (month) => l10n.yearBookChapter('$month'),
          dateLine: (date) => date.toFormDate(locale),
        );
        if (bytes == null || !context.mounted) {
          return;
        }
        await context.router.push(
          YearBookPreviewRoute(
            bytes: bytes,
            title: title,
            fileName: controller.pdfFileName,
            canExport: book.canExport,
          ),
        );
      } on Object catch (error) {
        if (context.mounted) {
          showAppSnackBar(context, actionErrorMessage(error));
        }
      }
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s2,
          AppSpacing.screen,
          AppSpacing.s3,
        ),
        child: Row(
          spacing: AppSpacing.s3,
          children: [
            if (!controller.readOnly)
              Expanded(
                child: AppButton.secondary(
                  label: l10n.commonSave,
                  onPressed: controller.dirty ? save : null,
                ),
              ),
            // Xem trước ở mọi gói; “Xuất PDF” ở trang xem trước theo gói.
            Expanded(
              child: AppButton(
                label: controller.exporting
                    ? l10n.yearBookExporting
                    : l10n.yearBookPreview,
                icon: LucideIcons.bookOpen,
                isLoading: controller.exporting,
                onPressed: book.includedCount > 0 && !controller.exporting
                    ? preview
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tên trên sách: bé đang mở, hoặc tên gia đình với sách cả nhà.
String _subjectName(YearBookController controller, YearBookRecord book) =>
    book.isFamily ? book.childName : controller.child?.name ?? book.childName;

String _defaultTitle(BuildContext context, YearBookRecord book, String name) =>
    book.isFamily
    ? context.l10n.yearBookFamilyDefaultTitle('${book.year}')
    : context.l10n.yearBookDefaultTitle(name, '${book.year}');
