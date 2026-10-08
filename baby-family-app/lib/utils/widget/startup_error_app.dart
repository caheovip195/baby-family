import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Màn hiển thị khi khởi tạo app thất bại (thay cho màn trắng) — cho phép sao
/// chép lỗi gửi bộ phận kỹ thuật.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      // Chạy trước khi đọc được lựa chọn ngôn ngữ → theo ngôn ngữ thiết bị.
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Builder(builder: _buildBody),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.circleAlert,
                color: kColorErrorD14B4B,
                size: 40,
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(l10n.errorStartupTitle, style: AppTypography.h3),
              const SizedBox(height: AppSpacing.s2),
              Text(l10n.errorStartupDescription, style: AppTypography.caption),
              const SizedBox(height: AppSpacing.s3),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.s3),
                decoration: BoxDecoration(
                  color: kColorSurfaceVariantF7F1EC,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: kColorBorderEADFD6),
                ),
                child: SelectableText(message, style: AppTypography.caption),
              ),
              const SizedBox(height: AppSpacing.s4),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () =>
                      Clipboard.setData(ClipboardData(text: message)),
                  icon: const Icon(LucideIcons.copy, size: 16),
                  label: Text(l10n.commonCopyError),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
