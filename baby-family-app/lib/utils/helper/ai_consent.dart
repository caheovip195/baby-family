import 'package:baby_family/data/service/ai.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_dialog_card.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Chạy [action] AI; lần đầu dùng tính năng (server 428) → hỏi đồng ý, ghi
/// đồng ý qua [grant] rồi chạy lại. null = người dùng không đồng ý (7.18).
Future<T?> runWithAiConsent<T>(
  BuildContext context, {
  required Future<T> Function() action,
  required Future<void> Function(AiFeature feature) grant,
}) async {
  try {
    return await action();
  } on AiConsentRequired catch (required) {
    if (!context.mounted) {
      return null;
    }
    final agreed = await showAppDialogCard<bool>(
      context,
      builder: (_) => AiConsentDialog(feature: required.feature),
    );
    if (agreed != true) {
      return null;
    }
    await grant(required.feature);
    return action();
  }
}

/// Giải thích dữ liệu gửi cho nhà cung cấp AI trước lần dùng đầu tiên.
class AiConsentDialog extends StatelessWidget {
  const AiConsentDialog({required this.feature, super.key});

  final AiFeature feature;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = switch (feature) {
      AiFeature.caption => l10n.aiDataCaption,
      AiFeature.dailyStory => l10n.aiDataDayStory,
      AiFeature.gentleRewrite => l10n.aiDataRewrite,
      AiFeature.bridgeSummary => l10n.aiDataBridge,
      AiFeature.missionSuggest => l10n.aiDataMission,
    };
    return AppDialogCard(
      children: [
        const AppDialogIcon(
          icon: LucideIcons.sparkles,
          color: kColorUs50F6F2FC,
          foreground: kColorUs7006A549F,
        ),
        Text(
          l10n.aiConsentTitle,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(context, AppTypography.title20),
        ),
        Text(
          l10n.aiConsentBody(data),
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(
              height: 20 / 14,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
        AppButton.us(
          label: l10n.aiConsentAccept,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        AppButton.secondary(
          label: l10n.commonCancel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
