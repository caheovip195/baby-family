import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/year_book_preview/mobile/year_book_preview_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// REC-04 xem trước PDF trong app (BF-20261030-002): PDF dựng trên máy, xem
/// được ở mọi gói; “Xuất PDF” theo quyền của gói.
@RoutePage()
class YearBookPreviewPage extends BaseHookWidget {
  const YearBookPreviewPage({
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

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return YearBookPreviewMobileView(
      bytes: bytes,
      title: title,
      fileName: fileName,
      canExport: canExport,
    );
  }
}
