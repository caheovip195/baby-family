import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/page/parent/letter_composer/letter_composer_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_back_title_bar.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/letter_envelope.dart';
part '../widgets/letter_format_segment.dart';
part '../widgets/letter_open_card.dart';
part '../widgets/letter_option.dart';
part '../widgets/letter_paper.dart';
part '../widgets/letter_recipient_chip.dart';

/// MEM-14 Thư gửi con (Pencil `Q4HQel`).
class LetterComposerMobileView extends HookConsumerWidget {
  const LetterComposerMobileView({this.childId, super.key});

  final String? childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(letterComposerControllerProvider(childId));
    final l10n = context.l10n;
    if (!controller.loaded) {
      return const BaseScaffold(body: Center(child: CircleLoadingProgress()));
    }
    final child = controller.recipient;
    final callName = controller.me?.callName ?? '';
    final salutation =
        controller.salutation ??
        l10n.memLetterSalutation(child?.name ?? '', callName);
    final signature =
        controller.signature ??
        [l10n.memLetterSignOff, controller.me?.displayName ?? callName];
    final openDate = controller.openDate;
    final openText = openDate?.toFormDate(l10n.localeName);
    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s2),
      child: Text(
        text,
        style: AppTypography.adapt(
          context,
          AppTypography.caption.copyWith(
            fontWeight: FontWeight.w700,
            height: 16 / 13,
          ),
        ),
      ),
    );
    final sections = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label(l10n.memLetterRecipient),
          Wrap(
            spacing: AppSpacing.s2,
            runSpacing: AppSpacing.s2,
            children: [
              for (final item in controller.children)
                _LetterRecipientChip(
                  child: item,
                  selected: item.id == child?.id,
                  onTap: () => controller.selectRecipient(item.id),
                ),
            ],
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          label(l10n.memLetterFormat),
          _LetterFormatSegment(
            selected: controller.format,
            onChanged: controller.setFormat,
          ),
        ],
      ),
      _LetterPaper(
        salutation: salutation,
        signature: signature,
        body: controller.body,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          label(l10n.memLetterOpenDate),
          _optionsRow([
            _LetterOption(
              label: l10n.memLetterOpenNone,
              selected: controller.openMode == LetterOpenMode.none,
              filled: true,
              onTap: () => controller.setOpenMode(LetterOpenMode.none),
            ),
            _LetterOption(
              label: l10n.memLetterPickDate,
              selected: controller.openMode == LetterOpenMode.date,
              filled: true,
              onTap: () => _pickDate(context, controller),
            ),
            _LetterOption(
              label: l10n.memLetterBirthdayN,
              selected: controller.openMode == LetterOpenMode.birthday,
              filled: true,
              onTap: () => controller.setOpenMode(LetterOpenMode.birthday),
            ),
          ]),
          if (openText != null && child != null) ...[
            const SizedBox(height: AppSpacing.s2),
            _LetterOpenCard(
              birthday: controller.openMode == LetterOpenMode.birthday,
              title: controller.openMode == LetterOpenMode.birthday
                  ? l10n.memLetterBirthdayAge(controller.birthdayAge)
                  : openText,
              subtitle: l10n.memLetterOpensOn(child.name, openText),
              age: controller.birthdayAge,
              onChange: controller.changeBirthday,
              onTap: controller.openMode == LetterOpenMode.date
                  ? () => _pickDate(context, controller)
                  : null,
            ),
          ],
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          label(l10n.memLetterReaders),
          _optionsRow([
            _LetterOption(
              icon: LucideIcons.lock,
              label: l10n.commonOnlyYou,
              selected: controller.readers == MemoryVisibility.onlyMe,
              onTap: () => controller.setReaders(MemoryVisibility.onlyMe),
            ),
            _LetterOption(
              icon: LucideIcons.heartHandshake,
              label: l10n.familyParents,
              selected: controller.readers == MemoryVisibility.parents,
              onTap: () => controller.setReaders(MemoryVisibility.parents),
            ),
            _LetterOption(
              icon: LucideIcons.users,
              label: l10n.memoriesFamily,
              selected: controller.readers == MemoryVisibility.family,
              onTap: () => controller.setReaders(MemoryVisibility.family),
            ),
          ]),
          const SizedBox(height: AppSpacing.s2),
          _hint(
            context,
            LucideIcons.info,
            l10n.memLetterReadersNote(
              controller.readers.name,
              callName,
              controller.partner?.callName ?? '',
            ),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          label(l10n.memLetterEnvelopePreview),
          _LetterEnvelope(
            name: l10n.memLetterEnvelopeTo(child?.name ?? ''),
            meta: openText == null
                ? l10n.memLetterEnvelopeAnytime
                : controller.openMode == LetterOpenMode.birthday
                ? l10n.memLetterEnvelopeBirthday(
                    openText,
                    controller.birthdayAge,
                  )
                : l10n.memLetterEnvelopeDate(openText),
          ),
          const SizedBox(height: AppSpacing.s2),
          _hint(
            context,
            LucideIcons.calendarHeart,
            openText == null
                ? l10n.memLetterTimelineHintNow(callName)
                : l10n.memLetterTimelineHint(callName, openText),
          ),
        ],
      ),
      AppButton(
        label: l10n.memLetterSeal,
        isLoading: controller.isLoading,
        onPressed: () => _seal(context, controller, salutation, signature),
      ),
    ];
    return BaseScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBackTitleBar(
            title: l10n.commonLetter,
            trailing: TextButton(
              onPressed: () {
                final router = context.router;
                showAppSnackBar(context, l10n.memLetterDraftSaved);
                router.maybePop();
              },
              child: Text(
                l10n.memLetterSaveDraft,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: kColorTextSecondary6B625B,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.s1,
                AppSpacing.screen,
                28 + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                for (var index = 0; index < sections.length; index++) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.cardInset),
                  sections[index],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Ba lựa chọn chia đều, cách 8 (`SIifg`, `uScTy`).
  static Widget _optionsRow(List<Widget> options) => Row(
    children: [
      for (var index = 0; index < options.length; index++) ...[
        if (index > 0) const SizedBox(width: AppSpacing.s2),
        Expanded(child: options[index]),
      ],
    ],
  );

  /// Dòng ghi chú (`cpiWM`): icon 14 + chữ 12 `text-tertiary` (1.45), cách 8.
  static Widget _hint(BuildContext context, IconData icon, String text) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(
                icon,
                size: 14,
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(
                text,
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(
                    height: 1.45,
                    color: kColorTextTertiary9C928A,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _pickDate(
    BuildContext context,
    LetterComposerController controller,
  ) async {
    final today = controller.today;
    final value = await showDatePicker(
      context: context,
      initialDate:
          controller.pickedDate ??
          DateTime(today.year + 1, today.month, today.day),
      firstDate: today,
      lastDate: DateTime(today.year + 100),
    );
    if (value != null) {
      controller.setPickedDate(value);
    }
  }

  Future<void> _seal(
    BuildContext context,
    LetterComposerController controller,
    String salutation,
    List<String> signature,
  ) async {
    final router = context.router;
    final message = context.l10n.memLetterSealDone;
    if (await controller.seal(salutation: salutation, signature: signature)) {
      await router.maybePop();
      final current = router.navigatorKey.currentContext;
      if (current != null && current.mounted) {
        showAppSnackBar(current, message);
      }
    }
  }
}
