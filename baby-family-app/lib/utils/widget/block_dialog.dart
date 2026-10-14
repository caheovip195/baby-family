import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_check_mark.dart';
import 'package:baby_family/utils/widget/app_dialog_card.dart';
import 'package:baby_family/utils/widget/app_relative_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Mở RPT-02 — Chặn (Pencil `E6bZLd`) cho người thân [name]. Trả về `null`
/// khi huỷ, ngược lại `true` nếu chọn “Gỡ … khỏi gia đình luôn” (mục 7.24:
/// bố mẹ chặn người thân được khuyến nghị kèm lựa chọn gỡ).
Future<bool?> showBlockDialog(
  BuildContext context, {
  required String name,
  RelativeRelation? relation,
  bool canRemove = true,
}) => showAppDialogCard<bool>(
  context,
  builder: (_) =>
      BlockDialog(name: name, relation: relation, canRemove: canRemove),
);

/// Nội dung RPT-02: avatar chữ, “Chặn Ông ngoại?”, ba hậu quả (không bình
/// luận/thả tim, không nhận thông báo, vẫn ở trong gia đình), ô “Gỡ khỏi gia
/// đình luôn” (nền `accent-100`), Huỷ / Chặn (nền `error`).
class BlockDialog extends HookWidget {
  const BlockDialog({
    required this.name,
    this.relation,
    this.canRemove = true,
    super.key,
  });

  final String name;
  final RelativeRelation? relation;
  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final remove = useState(false);
    final who = relativePronounCode(relation);
    final body = AppTypography.adapt(
      context,
      AppTypography.text14.copyWith(
        height: 20 / 14,
        color: kColorTextSecondary6B625B,
      ),
    );
    Widget effect(IconData icon, String text) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.resolve(context, kColorTextSecondary6B625B),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(child: Text(text, style: body)),
      ],
    );
    return AppDialogCard(
      children: [
        AppRelativeAvatar(name: name, relation: relation, size: 56),
        Text(
          l10n.rptBlockTitle(name),
          textAlign: TextAlign.center,
          style: AppTypography.adapt(context, AppTypography.title20),
        ),
        Column(
          children: [
            effect(
              LucideIcons.messageCircleOff,
              l10n.rptBlockEffectComment(name),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            effect(LucideIcons.bellOff, l10n.rptBlockEffectNotify(who)),
            const SizedBox(height: AppSpacing.itemGap),
            effect(LucideIcons.images, l10n.rptBlockEffectStay(who)),
          ],
        ),
        if (canRemove)
          Material(
            color: AppColors.resolve(context, kColorAccent100FDF1D6),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.md),
              onTap: () => remove.value = !remove.value,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCheckMark(
                      checked: remove.value,
                      size: 20,
                      borderColor: kColorAccent7009A6A12,
                    ),
                    const SizedBox(width: AppSpacing.itemGap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.rptBlockRemove(name),
                            style: AppTypography.adapt(
                              context,
                              AppTypography.text14.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.rptBlockRemoveHint(who),
                            style: AppTypography.adapt(
                              context,
                              AppTypography.small.copyWith(
                                height: 17 / 12,
                                color: kColorTextSecondary6B625B,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s1),
          child: Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: l10n.commonCancel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: AppButton(
                  label: l10n.rptBlockConfirm,
                  color: kColorErrorD14B4B,
                  onPressed: () => Navigator.of(context).pop(remove.value),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
