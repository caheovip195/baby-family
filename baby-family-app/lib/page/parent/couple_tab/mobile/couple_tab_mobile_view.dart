import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/couple_request.dart';
import 'package:baby_family/data/model/us/daily_question.dart';
import 'package:baby_family/data/model/us/mood_checkin.dart';
import 'package:baby_family/data/model/us/thanks.dart';
import 'package:baby_family/data/provider/shell.dart';
import 'package:baby_family/page/parent/couple_tab/couple_tab_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/relative_time.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/skeleton_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/checkin_energy_bar.dart';
part '../widgets/checkin_mood_tile.dart';
part '../widgets/checkin_share_toggle.dart';
part '../widgets/checkin_sheet.dart';
part '../widgets/couple_header.dart';
part '../widgets/couple_tool_tiles.dart';
part '../widgets/daily_question_card.dart';
part '../widgets/mood_card.dart';
part '../widgets/open_request_card.dart';
part '../widgets/question_answer_sheet.dart';
part '../widgets/quick_replies.dart';
part '../widgets/thanks_note.dart';

/// US-01 — Papa & Mama (Pencil `J1j3bI`, tối `E8mGfO`): nền `us-50`, khoá
/// “Chỉ hai bạn nhìn thấy”, không có bộ chuyển bé (mục 9.8).
class CoupleTabMobileView extends HookConsumerWidget {
  const CoupleTabMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(coupleTabControllerProvider);

    // QC-01 “Check-in” → chuyển sang tab này rồi mở US-02.
    void handlePending() {
      if (controller.consumeCheckinRequest() && context.mounted) {
        _openCheckin(context, controller);
      }
    }

    ref.listen(pendingQuickActionProvider, (_, next) {
      if (next == QuickCreateAction.checkin) {
        handlePending();
      }
    });
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => handlePending());
      return null;
    }, const []);

    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      body: SafeArea(bottom: false, child: _body(context, controller)),
    );
  }

  Widget _body(BuildContext context, CoupleTabController controller) {
    final today = controller.today;
    final bottom = MediaQuery.paddingOf(context).bottom;
    if (today == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CoupleHeader(),
          Expanded(
            child: controller.hasError
                ? ErrorState(onRetry: controller.load)
                : const Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      AppSpacing.s2,
                      AppSpacing.screen,
                      0,
                    ),
                    child: Column(
                      children: [
                        SkeletonBlock(height: 150, radius: AppRadius.xl),
                        SizedBox(height: AppSpacing.sectionGap),
                        SkeletonBlock(height: 72, radius: AppRadius.xl),
                        SizedBox(height: AppSpacing.sectionGap),
                        SkeletonBlock(height: 110, radius: AppRadius.xl),
                      ],
                    ),
                  ),
          ),
        ],
      );
    }
    final partner = controller.partner;
    final sections = <Widget>[
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _MoodCard(
                member: controller.me,
                isMe: true,
                checkin: today.myCheckin,
                onTap: () => _openCheckin(context, controller),
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: _MoodCard(
                member: partner,
                isMe: false,
                checkin: today.partnerCheckin,
              ),
            ),
          ],
        ),
      ),
      if (today.partnerCheckin != null)
        _QuickReplies(
          onReply: () => showAppSnackBar(
            context,
            context.l10n.usReplySent(partner?.callName ?? ''),
          ),
        ),
      for (final request in today.openRequests)
        _OpenRequestCard(
          request: request,
          controller: controller,
          onTap: () =>
              context.router.push(RequestDetailRoute(requestId: request.id)),
        ),
      if (today.question != null)
        _DailyQuestionCard(
          question: today.question!,
          partnerName: partner?.callName ?? '',
          onTap: () => _openAnswer(context, controller, today.question!),
        ),
      if (today.recentThanks.isNotEmpty)
        _ThanksNote(
          thanks: today.recentThanks.first,
          controller: controller,
          onSeeAll: () => context.router.push(const ThanksWallRoute()),
        ),
      _CoupleToolTiles(
        onTap: () => showComingSoonSnackBar(context),
        onJournal: () => context.router.push(const PrivateJournalRoute()),
      ),
    ];
    return ListView(
      padding: EdgeInsets.only(bottom: bottom),
      children: [
        _CoupleHeader(
          onSettings: () => context.router.push(const CoupleSettingsRoute()),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.s2,
            AppSpacing.screen,
            AppSpacing.s6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < sections.length; index++) ...[
                if (index > 0) const SizedBox(height: AppSpacing.sectionGap),
                sections[index],
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openCheckin(
    BuildContext context,
    CoupleTabController controller,
  ) {
    return showAppBottomSheet<bool>(
      context,
      strongScrim: true,
      builder: (_) => _CheckinSheet(
        partnerName: controller.partner?.callName ?? '',
        onSave: controller.saveCheckin,
      ),
    );
  }

  Future<void> _openAnswer(
    BuildContext context,
    CoupleTabController controller,
    DailyQuestion question,
  ) {
    return showAppBottomSheet<void>(
      context,
      builder: (_) => _QuestionAnswerSheet(
        question: question,
        onSave: controller.answerQuestion,
      ),
    );
  }
}
