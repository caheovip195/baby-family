import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/thanks_compose/thanks_compose_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part '../widgets/thanks_sticker_tile.dart';

/// US-05 — Gửi lời cảm ơn (không có trong Pencil): dựng từ kit theo phong
/// cách US-03 — nền `us-50`, tiêu đề 26/800, câu mẫu (chip), ô viết tự do,
/// sticker, công tắc “Đề nghị đăng thành khoảnh khắc gia đình”, Gửi.
class ThanksComposeMobileView extends HookConsumerWidget {
  const ThanksComposeMobileView({this.missionId, super.key});

  final String? missionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(thanksComposeControllerProvider);
    final l10n = context.l10n;
    final text = useTextEditingController(text: l10n.usThanksSample1);
    final partnerName = controller.partner?.callName ?? '';
    final accent = AppColors.resolve(context, kColorUs7006A549F);
    final sectionStyle = AppTypography.small.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
      color: accent,
    );
    final samples = [
      l10n.usThanksSample1,
      l10n.usThanksSample2,
      l10n.usThanksSample3,
    ];
    useListenable(text);

    final content = <Widget>[
      Text(
        l10n.usThanksTitle(partnerName),
        style: AppTypography.adapt(context, AppTypography.h1),
      ),
      Text(l10n.usThanksSamples, style: sectionStyle),
      Wrap(
        spacing: AppSpacing.s2,
        runSpacing: AppSpacing.s2,
        children: [
          for (final sample in samples)
            AppSelectableChip(
              label: sample,
              selected: text.text == sample,
              filledSelection: false,
              outlined: true,
              onPressed: () => text.text = sample,
            ),
        ],
      ),
      AppTextField(controller: text, hint: l10n.usThanksHint, maxLines: 4),
      Text(l10n.usThanksSticker, style: sectionStyle),
      Row(
        children: [
          for (final (index, sticker) in kValueThanksStickers.indexed) ...[
            if (index > 0) const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: _ThanksStickerTile(
                sticker: sticker,
                selected: controller.sticker == sticker,
                onTap: () => controller.selectSticker(sticker),
              ),
            ),
          ],
        ],
      ),
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardInset,
          vertical: AppSpacing.s1,
        ),
        decoration: BoxDecoration(
          color: AppColors.resolve(context, kColorSurfaceFFFFFF),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.usThanksPostFamily,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.usThanksPostFamilyHint(partnerName),
                    style: AppTypography.adapt(context, AppTypography.small),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            AppSwitch(
              value: controller.proposeFamilyMoment,
              onChanged: controller.toggleFamilyMoment,
            ),
          ],
        ),
      ),
    ];

    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      appBar: const AppTopBar(backgroundColor: kColorUs50F6F2FC),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.cardInset,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < content.length; index++) ...[
                    if (index > 0) const SizedBox(height: AppSpacing.cardInset),
                    content[index],
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: AppSpacing.s6),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: AppButton.us(
                label: l10n.usSendTo(partnerName),
                isLoading: controller.isLoading,
                onPressed: () async {
                  final router = context.router;
                  final sent = await controller.send(
                    text.text,
                    missionId: missionId,
                  );
                  if (!context.mounted) {
                    return;
                  }
                  showAppSnackBar(
                    context,
                    sent ? l10n.usThanksSent(partnerName) : l10n.errorGeneric,
                  );
                  if (sent) {
                    await router.maybePop();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
