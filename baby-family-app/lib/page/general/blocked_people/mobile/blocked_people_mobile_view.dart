import 'package:baby_family/data/model/settings/blocked_person.dart';
import 'package:baby_family/page/general/blocked_people/blocked_people_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/blocked_row.dart';

/// SET-13 — Người bị chặn (Pencil `DXquo`): mô tả, “ĐANG CHẶN · N NGƯỜI”,
/// mỗi người một dòng (avatar chữ, nơi gặp, ngày chặn, “Bỏ chặn”), ghi chú
/// sau khi bỏ chặn và ghi chú Papa & Mama không chặn nhau.
class BlockedPeopleMobileView extends HookConsumerWidget {
  const BlockedPeopleMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(blockedPeopleControllerProvider);
    final people = controller.people;
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (people == null) {
      body = const SizedBox.shrink();
    } else {
      body = _content(context, controller, people);
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }

  Widget _content(
    BuildContext context,
    BlockedPeopleController controller,
    List<BlockedPerson> people,
  ) {
    final l10n = context.l10n;
    const gap = SizedBox(height: AppSpacing.cardInset);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        28 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Text(
          l10n.settingsBlockedTitle,
          style: AppTypography.adapt(context, AppTypography.h1),
        ),
        const SizedBox(height: AppSpacing.compact),
        Text(
          l10n.setBlockedBody,
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(
              height: 1.45,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
        gap,
        if (people.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
            child: Text(
              l10n.setBlockedEmpty,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(context, AppTypography.caption),
            ),
          )
        else ...[
          AppCapsLabel(l10n.setBlockedSection(people.length)),
          gap,
          AppGroupedList(
            children: [
              for (final person in people)
                _BlockedRow(
                  person: person,
                  onUnblock: () async {
                    await controller.unblock(person);
                    if (context.mounted) {
                      showAppSnackBar(context, l10n.setUnblocked(person.name));
                    }
                  },
                ),
            ],
          ),
          gap,
          AppInfoNote(
            icon: LucideIcons.info,
            text: l10n.setUnblockInfo,
            background: kColorSurfaceVariantF7F1EC,
            iconColor: kColorTextSecondary6B625B,
            iconSize: 16,
            lineHeight: 1.45,
            alignTop: true,
          ),
        ],
        gap,
        AppInfoNote(
          icon: LucideIcons.heartHandshake,
          text: l10n.setBlockedPartnerNote,
          iconSize: 16,
          lineHeight: 1.45,
          alignTop: true,
        ),
      ],
    );
  }
}
