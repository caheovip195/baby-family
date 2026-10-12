import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/pregnancy/name_candidate.dart';
import 'package:baby_family/page/parent/baby_names/baby_names_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/add_name_sheet.dart';
part '../widgets/name_card.dart';

/// PREG-07 (X8AtZx) — nền `us-50`: tiêu đề 26/800, khoá “Chỉ Papa & Mama nhìn
/// thấy”, thẻ tên (chọn: viền 2 `us-500`), “Thêm tên dự định”, nút `us-700`
/// “Chọn “An Nhiên” làm tên của Bơ”.
class BabyNamesMobileView extends HookConsumerWidget {
  const BabyNamesMobileView({required this.pregnancyId, super.key});

  final String pregnancyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(babyNamesControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(pregnancyId));
      return null;
    }, [pregnancyId]);
    final l10n = context.l10n;
    final child = controller.child;
    final selected = controller.selected;
    Widget body;
    if (child == null) {
      body = Center(
        child: controller.hasError
            ? ErrorState(onRetry: controller.load)
            : const CircleLoadingProgress(),
      );
    } else {
      final items = <Widget>[
        for (final name in controller.names)
          _NameCard(
            name: name,
            selected: name.id == controller.selectedId,
            iAmMama: controller.iAmMama,
            onTap: () => controller.select(name.id),
            onLike: () => controller.toggleLike(name.id),
          ),
        _addButton(context, controller),
      ];
      body = Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.pregnancyNamesFor(child.name),
                      style: AppTypography.adapt(context, AppTypography.h1),
                    ),
                    const SizedBox(height: AppSpacing.s3),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.lock,
                          size: 12,
                          color: AppColors.resolve(context, kColorUs7006A549F),
                        ),
                        const SizedBox(width: AppSpacing.compact),
                        Flexible(
                          child: Text(
                            l10n.pregnancyPrivate,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.small.copyWith(
                                fontWeight: FontWeight.w600,
                                color: kColorUs7006A549F,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (final item in items) ...[
                      const SizedBox(height: AppSpacing.s3),
                      item,
                    ],
                    const SizedBox(height: AppSpacing.s3),
                  ],
                ),
              ),
            ),
            if (selected != null)
              AppButton.us(
                label: l10n.pregnancyChooseNameFor(selected.name, child.name),
                isLoading: controller.isLoading,
                onPressed: () async {
                  final router = context.router;
                  await controller.chooseSelected();
                  await router.maybePop();
                },
              ),
          ],
        ),
      );
    }
    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      appBar: const AppTopBar(backgroundColor: kColorUs50F6F2FC),
      body: SafeArea(top: false, child: body),
    );
  }

  Widget _addButton(BuildContext context, BabyNamesController controller) {
    return Material(
      color: kColorTransparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: AppColors.resolve(context, kColorUs5009B85D1),
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => showAppBottomSheet<void>(
          context,
          builder: (_) => _AddNameSheet(controller: controller),
        ),
        child: SizedBox(
          height: AppSpacing.s12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.plus,
                size: 16,
                color: AppColors.resolve(context, kColorUs7006A549F),
              ),
              const SizedBox(width: AppSpacing.s2),
              Text(
                context.l10n.pregnancyAddName,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: kColorUs7006A549F,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
