import 'package:baby_family/page/general/about/about_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/external_launcher.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_logo.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/app_card_header.dart';

/// SET-12 — Giới thiệu (Pencil `vlWDT`). “Giấy phép mã nguồn mở” mở trang
/// giấy phép của Flutter; điều khoản / chính sách chưa có màn → “Sắp ra mắt”.
class AboutMobileView extends HookConsumerWidget {
  const AboutMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(aboutControllerProvider);
    final l10n = context.l10n;
    void comingSoon() => showComingSoonSnackBar(context);
    const gap = SizedBox(height: AppSpacing.cardInset);
    final footerStyle = AppTypography.adapt(
      context,
      AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
    );
    return BaseScaffold(
      appBar: const AppTopBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            sliver: SliverList.list(
              children: [
                Text(
                  l10n.settingsAbout,
                  style: AppTypography.adapt(context, AppTypography.h1),
                ),
                gap,
                _AppCardHeader(version: controller.appVersion),
                gap,
                AppGroupedList(
                  children: [
                    AppSettingsRow(
                      icon: LucideIcons.fileText,
                      title: l10n.setTerms,
                      onTap: controller.termsUrl == null
                          ? comingSoon
                          : () => launchExternalUrl(controller.termsUrl!),
                    ),
                    AppSettingsRow(
                      icon: LucideIcons.shield,
                      title: l10n.setPrivacyPolicy,
                      onTap: controller.privacyUrl == null
                          ? comingSoon
                          : () => launchExternalUrl(controller.privacyUrl!),
                    ),
                    AppSettingsRow(
                      icon: LucideIcons.code,
                      title: l10n.setLicenses,
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: l10n.appName,
                        applicationVersion: controller.appVersion,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.s8,
                AppSpacing.screen,
                AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    l10n.setMadeWith,
                    textAlign: TextAlign.center,
                    style: footerStyle,
                  ),
                  gap,
                  Text(
                    l10n.setCopyright('${controller.year}'),
                    textAlign: TextAlign.center,
                    style: footerStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
