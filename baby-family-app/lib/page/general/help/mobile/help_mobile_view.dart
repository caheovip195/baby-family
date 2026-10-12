import 'package:baby_family/page/general/help/help_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_tag_pill.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// SET-11 — Trợ giúp (Pencil `fyper`). Câu trả lời, form hỗ trợ, báo cáo và
/// liên hệ chưa có màn riêng → “Sắp ra mắt”.
class HelpMobileView extends HookConsumerWidget {
  const HelpMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(helpControllerProvider);
    final l10n = context.l10n;
    final info = controller.info;
    void comingSoon() => showComingSoonSnackBar(context);
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (info == null) {
      body = const SizedBox.shrink();
    } else {
      const gap = SizedBox(height: AppSpacing.cardInset);
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.settingsHelp,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          gap,
          AppCapsLabel(l10n.setFaqSection),
          gap,
          AppGroupedList(
            children: [
              for (final question in info.faqs)
                AppSettingsRow(
                  title: question,
                  titleSize: 14,
                  minHeight: 52,
                  onTap: comingSoon,
                ),
              AppSettingsRow(
                title: l10n.setFaqAll,
                titleSize: 14,
                titleWeight: FontWeight.w600,
                titleColor: kColorPrimary600C2513F,
                minHeight: 48,
                onTap: comingSoon,
              ),
            ],
          ),
          gap,
          AppCapsLabel(l10n.setSupportSection),
          gap,
          AppGroupedList(
            children: [
              AppSettingsRow(
                icon: LucideIcons.messageSquareText,
                iconBackground: kColorPrimary50FFF4F1,
                iconColor: kColorPrimary600C2513F,
                title: l10n.setSendRequest,
                subtitle: l10n.setSendRequestHint,
                onTap: comingSoon,
              ),
              AppSettingsRow(
                icon: LucideIcons.flag,
                title: l10n.setMyReports,
                trailing: info.openReports > 0
                    ? AppTagPill(
                        label: l10n.setReportsOpen(info.openReports),
                        color: kColorAccent100FDF1D6,
                        foreground: kColorTextPrimary2E2A27,
                      )
                    : null,
                onTap: comingSoon,
              ),
            ],
          ),
          gap,
          AppCapsLabel(l10n.setContactSection),
          gap,
          AppGroupedList(
            children: [
              AppSettingsRow(
                icon: LucideIcons.mail,
                title: info.email,
                subtitle: l10n.setEmailSupport,
                showChevron: false,
                onTap: comingSoon,
              ),
              AppSettingsRow(
                icon: LucideIcons.phone,
                title: info.hotline,
                subtitle: l10n.setHotline,
                showChevron: false,
                onTap: comingSoon,
              ),
            ],
          ),
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
