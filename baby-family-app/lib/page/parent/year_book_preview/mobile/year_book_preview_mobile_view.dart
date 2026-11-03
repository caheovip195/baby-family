import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/application_directory.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_text_action.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

/// Khung xem trang PDF; test thay bằng widget không cần plugin raster.
final yearBookPdfViewerProvider = Provider<Widget Function(Uint8List bytes)>(
  (ref) =>
      (bytes) => PdfPreview(
        build: (_) async => bytes,
        useActions: false,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        pdfPreviewPageDecoration: const BoxDecoration(color: Colors.white),
      ),
);

/// REC-04 xem trước PDF: các trang sách như khi in; thanh dưới “Xuất PDF”
/// (lưu file rồi mở bảng chia sẻ) hoặc ghi chú gói chỉ xem trước.
class YearBookPreviewMobileView extends HookConsumerWidget {
  const YearBookPreviewMobileView({
    required this.bytes,
    required this.title,
    required this.fileName,
    required this.canExport,
    super.key,
  });

  final Uint8List bytes;
  final String title;
  final String fileName;
  final bool canExport;

  Future<void> _share(BuildContext context) async {
    try {
      final file = File(
        '${ApplicationDirectory().tempApplicationFolder.path}/$fileName',
      );
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: title,
        ),
      );
    } on Object catch (error) {
      if (context.mounted) {
        showAppSnackBar(context, actionErrorMessage(error));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final viewer = ref.watch(yearBookPdfViewerProvider);
    return BaseScaffold(
      backgroundColor: kColorBgFFFBF7,
      appBar: AppTopBar(title: l10n.yearBookPreview),
      body: Column(
        children: [
          Expanded(child: viewer(bytes)),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.s2,
                AppSpacing.screen,
                AppSpacing.s3,
              ),
              child: canExport
                  ? AppButton(
                      label: l10n.yearBookExport,
                      icon: LucideIcons.share2,
                      onPressed: () => _share(context),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppInfoNote(
                          icon: LucideIcons.lock,
                          text: l10n.yearBookPreviewOnly,
                        ),
                        AppTextAction(
                          label: l10n.yearBookUpgrade,
                          onPressed: () =>
                              context.router.push(const UpgradePlanRoute()),
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
