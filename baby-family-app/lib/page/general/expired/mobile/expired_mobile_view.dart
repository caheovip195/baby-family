import 'package:auto_route/auto_route.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/page/general/expired/expired_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_icon_badge.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/footer_link.dart';
part '../widgets/retention_card.dart';

/// SUB-07 — Hết hạn dùng thử (Pencil `aZ9MZ`). Chặn quay lại; chỉ cho chọn
/// gói, tải dữ liệu, khôi phục, hỗ trợ, đăng xuất, xoá tài khoản (BR-036).
class ExpiredMobileView extends HookConsumerWidget {
  const ExpiredMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(expiredControllerProvider);
    final l10n = context.l10n;
    final retained = controller.retainedUntil;

    Future<void> signOut() async {
      await controller.signOut();
      if (!context.mounted) {
        return;
      }
      await context.router.replaceAll([routeForSession(controller.session)]);
    }

    final linkSeparator = Text(
      ' · ',
      style: AppTypography.adapt(
        context,
        AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
      ),
    );
    return BaseScaffold(
      canPop: false,
      isLoading: controller.isLoading,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s6,
              vertical: AppSpacing.s8,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - AppSpacing.s8 * 2,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Assets.images.v46baZ.image(
                        width: 200,
                        height: 200,
                        excludeFromSemantics: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    Text(
                      l10n.billingExpired,
                      textAlign: TextAlign.center,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.h1.copyWith(height: 1.2),
                      ),
                    ),
                    if (controller.childNames.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sectionGap),
                      Text(
                        l10n.subExpiredStats(
                          controller.memoryCount,
                          controller.firstsCount,
                          controller.childNames.join(', '),
                        ),
                        textAlign: TextAlign.center,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.body.copyWith(
                            height: 1.5,
                            color: kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ],
                    if (retained != null) ...[
                      const SizedBox(height: AppSpacing.sectionGap),
                      _RetentionCard(
                        title: l10n.subRetentionTitle(
                          retained.toFormDate(context.localeName),
                        ),
                        subtitle: l10n.billingRetentionHint,
                      ),
                    ],
                    const Spacer(),
                    const SizedBox(height: AppSpacing.sectionGap),
                    AppButton(
                      label: l10n.billingChoosePlans,
                      onPressed: () => context.router.push(const PlansRoute()),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    AppButton.secondary(
                      label: l10n.billingExport,
                      onPressed: () =>
                          showAppSnackBar(context, l10n.subExportStarted),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _FooterLink(
                          label: l10n.billingRestore,
                          onTap: () =>
                              showAppSnackBar(context, l10n.subRestoreNone),
                        ),
                        linkSeparator,
                        _FooterLink(
                          label: l10n.billingSupport,
                          onTap: () => showComingSoonSnackBar(context),
                        ),
                        linkSeparator,
                        _FooterLink(label: l10n.settingsLogout, onTap: signOut),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    Center(
                      child: _FooterLink(
                        label: l10n.settingsDeleteAccount,
                        color: kColorErrorD14B4B,
                        onTap: () => showComingSoonSnackBar(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
