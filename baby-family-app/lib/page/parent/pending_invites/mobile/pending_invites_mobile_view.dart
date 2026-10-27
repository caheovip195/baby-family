import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/page/parent/pending_invites/pending_invites_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_relative_avatar.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/invite_card.dart';

/// FAM-05 — Lời mời đang chờ (Pencil `O61Ev`): số người thân đang tham gia /
/// đang chờ + chỗ đã dùng, “ĐANG CHỜ” (gửi lại link, thu hồi), “ĐÃ HẾT HẠN”
/// (tạo lời mời mới), quy tắc lời mời và “Mời thêm người thân” → FAM-03.
class PendingInvitesMobileView extends HookConsumerWidget {
  const PendingInvitesMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pendingInvitesControllerProvider);
    final l10n = context.l10n;
    final invites = controller.invites;
    if (controller.hasError) {
      return AppStepScaffold(
        topBar: const AppTopBar(),
        children: [ErrorState(onRetry: controller.load)],
      );
    }
    if (invites == null) {
      return const AppStepScaffold(
        topBar: AppTopBar(),
        children: [Center(child: CircleLoadingProgress())],
      );
    }
    final pending = controller.pending;
    final expired = controller.expired;
    final used = controller.activeRelatives + pending.length;

    String description(InviteInfo invite) {
      final names = controller.childNames(invite);
      final relation =
          invite.relationNote ??
          relativeRelationLabel(
            l10n,
            invite.relation,
            fallback: invite.callName ?? '',
          );
      return [
        l10n.famInviteKindRelative,
        if (relation.isNotEmpty) relation,
        if (names.isNotEmpty) names.join(', '),
        _permission(l10n, invite),
      ].join(' · ');
    }

    Widget card(InviteInfo invite, {required bool isExpired}) {
      final name = invite.callName ?? '';
      return _InviteCard(
        invite: invite,
        expired: isExpired,
        description: description(invite),
        dates: _dates(context, controller, invite, isExpired: isExpired),
        onResend: () async {
          await controller.resend(
            invite,
            l10n.famInviteShareMessage(
              name,
              joinNames(l10n, controller.childNames(invite)),
              invite.code,
              invite.link ?? '',
            ),
          );
          if (context.mounted) {
            showAppSnackBar(context, l10n.famInviteResent(name));
          }
        },
        onRevoke: () async {
          await controller.revoke(invite);
          if (context.mounted) {
            showAppSnackBar(context, l10n.famInviteRevokedName(name));
          }
        },
        onRenew: () async {
          await controller.renew(invite);
          if (context.mounted) {
            showAppSnackBar(context, l10n.famInviteRenewed(name));
          }
        },
      );
    }

    return AppStepScaffold(
      topBar: const AppTopBar(),
      topPadding: 0,
      gap: AppSpacing.cardInset,
      actionGap: AppSpacing.cardInset,
      actions: [
        Text(
          l10n.famInvitesRules,
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(
              height: 1.45,
              color: kColorTextTertiary9C928A,
            ),
          ),
        ),
        AppButton(
          label: l10n.famInviteMore,
          onPressed: () => context.router.push(const RelativeInviteRoute()),
        ),
      ],
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.familyPendingInvitesTitle,
              style: AppTypography.adapt(context, AppTypography.h1),
            ),
            const SizedBox(height: AppSpacing.compact),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.famInvitesCapacity(
                      controller.family?.name ?? '',
                      controller.activeRelatives,
                      pending.length,
                    ),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(height: 16 / 13),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.itemGap,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorPrimary50FFF4F1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    l10n.subPlanSlots(used, controller.slotsMax),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kColorPrimary700A2402F,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (pending.isEmpty && expired.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
            child: Text(
              l10n.famInvitesEmpty,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(context, AppTypography.caption),
            ),
          ),
        if (pending.isNotEmpty) ...[
          AppCapsLabel(l10n.famInvitesPending),
          for (final invite in pending) card(invite, isExpired: false),
        ],
        if (expired.isNotEmpty) ...[
          AppCapsLabel(l10n.famInvitesExpired),
          for (final invite in expired) card(invite, isExpired: true),
        ],
      ],
    );
  }

  static String _permission(AppLocalizations l10n, InviteInfo invite) {
    if (invite.canPost) {
      return l10n.famInvitePermPost;
    }
    return invite.canComment
        ? l10n.famInvitePermComment
        : l10n.famInvitePermView;
  }

  static String _dates(
    BuildContext context,
    PendingInvitesController controller,
    InviteInfo invite, {
    required bool isExpired,
  }) {
    final l10n = context.l10n;
    final locale = context.localeName;
    final expiresAt = invite.expiresAt;
    if (expiresAt == null) {
      return '';
    }
    if (isExpired) {
      return l10n.famInviteExpiredOn(expiresAt.toFormDate(locale));
    }
    final days = daysUntil(expiresAt, controller.today);
    return l10n.famInviteDates(
      invite.sentAt?.toDayMonth(locale) ?? '',
      expiresAt.toFormDate(locale),
      l10n.famInviteDaysLeft(days < 0 ? 0 : days),
    );
  }
}
