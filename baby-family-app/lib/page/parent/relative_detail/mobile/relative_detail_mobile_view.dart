import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/page/parent/relative_detail/relative_detail_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/relative_time.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_preference_segment.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_relative_avatar.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_tag_pill.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/child_permission_row.dart';
part '../widgets/relative_header.dart';
part '../widgets/remove_relative_sheet.dart';

/// FAM-04 — Chi tiết người thân (Pencil `g7UQ1F`). Quyền theo từng bé lấy từ
/// dữ liệu (`Member.childPermissions`): Bà ngoại đang theo dõi cả Bơ (CIR-01)
/// nên dòng Bơ hiện mức quyền thật thay cho “Chưa chia sẻ” của frame.
/// “Gỡ khỏi gia đình” mở FAM-06 (bottom sheet xác nhận) rồi quay về FAM-01.
class RelativeDetailMobileView extends HookConsumerWidget {
  const RelativeDetailMobileView({required this.memberId, super.key});

  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(relativeDetailControllerProvider(memberId));
    final l10n = context.l10n;
    final member = controller.member;

    Future<void> remove(Member member) async {
      final confirmed = await showAppBottomSheet<bool>(
        context,
        builder: (_) => _RemoveRelativeSheet(member: member),
      );
      if (confirmed != true || !context.mounted) {
        return;
      }
      await controller.remove();
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(context, l10n.famRemoved(member.callName));
      await context.router.maybePop();
    }

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (member == null) {
      body = const SizedBox.shrink();
    } else {
      final who = relativePronounCode(member.relation);
      const gap = SizedBox(height: AppSpacing.cardInset);
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          _RelativeHeader(member: member, now: controller.now),
          gap,
          AppGroupedList(
            children: [
              AppSettingsRow(
                icon: LucideIcons.tag,
                title: l10n.famDisplayName,
                value: member.callName,
                onTap: () => showComingSoonSnackBar(context),
              ),
              AppSettingsRow(
                icon: LucideIcons.smartphone,
                title: l10n.famSignIn,
                value: member.phoneMasked == null
                    ? null
                    : l10n.famSignInPhone(member.phoneMasked!),
                showChevron: false,
              ),
              AppSettingsRow(
                icon: LucideIcons.images,
                title: l10n.famPostedMemories,
                value: l10n.famMemoryCount(member.postedCount),
                onTap: () => showComingSoonSnackBar(context),
              ),
            ],
          ),
          gap,
          AppCapsLabel(l10n.famPermByChild),
          gap,
          AppGroupedList(
            children: [
              for (final child in controller.children)
                _ChildPermissionRow(
                  child: child,
                  today: controller.today,
                  permission: controller.permissionOf(child.id),
                  onChanged: (permission) =>
                      controller.setPermission(child.id, permission),
                ),
            ],
          ),
          gap,
          AppGroupedList(
            children: [
              AppSettingsRow.toggle(
                title: l10n.famAllowDownload,
                subtitle: member.allowDownload
                    ? l10n.famAllowDownloadOn(who)
                    : l10n.famAllowDownloadOff(who),
                value: member.allowDownload,
                onChanged: controller.setAllowDownload,
              ),
              AppSettingsRow.toggle(
                title: l10n.famMuteFrom(member.callName),
                subtitle: l10n.famMuteHint(who),
                value: member.notificationsMuted,
                onChanged: controller.setMuted,
              ),
            ],
          ),
          gap,
          AppInfoNote(
            icon: LucideIcons.shieldCheck,
            text: l10n.famRelativeNote(member.callName),
          ),
          gap,
          AppGroupedList(
            children: [
              AppSettingsRow(
                icon: member.paused
                    ? LucideIcons.circlePlay
                    : LucideIcons.circlePause,
                title: member.paused ? l10n.famResumeView : l10n.famPauseView,
                onTap: controller.togglePaused,
              ),
              AppSettingsRow(
                icon: LucideIcons.flag,
                title: l10n.famReport,
                onTap: () => showComingSoonSnackBar(context),
              ),
              AppSettingsRow(
                icon: LucideIcons.userMinus,
                iconBackground: kColorPrimary50FFF4F1,
                iconColor: kColorErrorD14B4B,
                title: l10n.famRemoveRelative,
                titleColor: kColorErrorD14B4B,
                titleWeight: FontWeight.w600,
                onTap: () => remove(member),
              ),
            ],
          ),
        ],
      );
    }
    return BaseScaffold(
      isLoading: controller.isLoading,
      appBar: const AppTopBar(),
      body: body,
    );
  }
}
