import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/us/safety_hotline.dart';
import 'package:baby_family/page/parent/safety_support/safety_support_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/hotline_row.dart';
part '../widgets/quick_exit_button.dart';
part '../widgets/safety_privacy_card.dart';
part '../widgets/trusted_person_card.dart';

/// US-13 — Hỗ trợ an toàn (Pencil `SeTnA`): nền trung tính `bg` (không tím),
/// “Thoát nhanh” phải trên, tiêu đề 24/800, danh sách đường dây (113 · 115 ·
/// 111, nút gọi `success`), người tin cậy, khối riêng tư, “Giữ riêng nội
/// dung này” (nút `text-primary`), disclaimer. Không ghi lịch sử phiên.
class SafetySupportMobileView extends HookConsumerWidget {
  const SafetySupportMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(safetySupportControllerProvider);
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else {
      body = _content(context, controller);
    }
    return BaseScaffold(
      backgroundColor: kColorBgFFFBF7,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.s1,
                AppSpacing.s4,
                AppSpacing.s1,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: _QuickExitButton(onTap: () => _quickExit(context)),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  /// “Thoát nhanh”: về Trang chủ và xoá cả chồng màn Cầu nối.
  void _quickExit(BuildContext context) => context.router.replaceAll([
    const MainShellRoute(children: [HomeTabRoute()]),
  ]);

  /// “Giữ riêng nội dung này”: nháp ở lại riêng tư, quay về Papa & Mama.
  void _keepPrivate(BuildContext context) => context.router.replaceAll([
    const MainShellRoute(children: [CoupleTabRoute()]),
  ]);

  Widget _content(BuildContext context, SafetySupportController controller) {
    final l10n = context.l10n;
    final partnerName = controller.partner?.callName ?? '';
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s1,
        AppSpacing.screen,
        28 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.shield,
            size: 28,
            color: AppColors.resolve(context, kColorTextSecondary6B625B),
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Text(
          l10n.usSafetyHeadline,
          style: AppTypography.adapt(
            context,
            AppTypography.h1.copyWith(fontSize: 24, height: 1.25),
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Text(
          l10n.usSafetyBody,
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(
              height: 1.4,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        if (controller.hotlines.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardInset,
              vertical: AppSpacing.s1,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
            ),
            child: Column(
              children: [
                for (final (index, hotline) in controller.hotlines.indexed) ...[
                  if (index > 0)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.resolve(context, kColorBorderEADFD6),
                    ),
                  _HotlineRow(
                    hotline: hotline,
                    onCall: () => controller.call(hotline),
                  ),
                ],
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.s4),
        _TrustedPersonCard(onTap: controller.contactTrustedPerson),
        const SizedBox(height: AppSpacing.s4),
        _SafetyPrivacyCard(partnerName: partnerName),
        const SizedBox(height: AppSpacing.s4),
        AppButton(
          label: l10n.usSafetyKeepPrivate,
          color: kColorTextPrimary2E2A27,
          onPressed: () => _keepPrivate(context),
        ),
        const SizedBox(height: AppSpacing.s4),
        Text(
          l10n.usSafetyDisclaimer,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.tiny.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
