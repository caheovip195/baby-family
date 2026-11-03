import 'dart:isolate';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Một ký ức trên trang sách: chú thích, dòng ngày và ảnh đã tải.
class YearBookPdfEntry {
  const YearBookPdfEntry({
    required this.caption,
    required this.dateLine,
    this.images = const [],
  });

  final String caption;
  final String dateLine;
  final List<Uint8List> images;
}

class YearBookPdfChapter {
  const YearBookPdfChapter({required this.heading, required this.entries});

  final String heading;
  final List<YearBookPdfEntry> entries;
}

/// Dữ liệu thuần (chữ đã dịch, ảnh, font) để dựng PDF trong isolate riêng.
class YearBookPdfInput {
  const YearBookPdfInput({
    required this.title,
    required this.subtitle,
    required this.chapters,
    required this.regularFont,
    required this.boldFont,
  });

  final String title;
  final String subtitle;
  final List<YearBookPdfChapter> chapters;

  /// BeVietnamPro (TTF) để in đủ dấu tiếng Việt.
  final ByteData regularFont;
  final ByteData boldFont;
}

/// REC-04 Sách của con (BF-20261028-013): trang bìa + mỗi tháng một chương,
/// ảnh tối đa 2 cột, chú thích dưới ảnh. Dựng trên isolate riêng để giải mã
/// ảnh (webp/jpeg) không làm giật giao diện.
Future<Uint8List> buildYearBookPdf(YearBookPdfInput input) =>
    Isolate.run(() => _build(input));

const _ink = PdfColor.fromInt(0xFF2B2420);
const _muted = PdfColor.fromInt(0xFF6B625B);
const _accent = PdfColor.fromInt(0xFFC2513F);
const _paper = PdfColor.fromInt(0xFFFFFBF7);

Future<Uint8List> _build(YearBookPdfInput input) async {
  final regular = pw.Font.ttf(input.regularFont);
  final bold = pw.Font.ttf(input.boldFont);
  final document = pw.Document(
    title: input.title,
    theme: pw.ThemeData.withFont(base: regular, bold: bold),
  );
  final page = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(40),
    buildBackground: (_) =>
        pw.FullPage(ignoreMargins: true, child: pw.Container(color: _paper)),
  );
  document.addPage(
    pw.Page(
      pageTheme: page,
      build: (_) => pw.Center(
        child: pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Text(
              input.title,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: bold, fontSize: 34, color: _ink),
            ),
            pw.SizedBox(height: 12),
            pw.Text(
              input.subtitle,
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 16, color: _muted),
            ),
          ],
        ),
      ),
    ),
  );
  for (final chapter in input.chapters) {
    document.addPage(
      pw.MultiPage(
        pageTheme: page,
        build: (_) => [
          pw.Header(
            level: 0,
            decoration: const pw.BoxDecoration(),
            child: pw.Text(
              chapter.heading,
              style: pw.TextStyle(font: bold, fontSize: 24, color: _accent),
            ),
          ),
          for (final entry in chapter.entries) ..._entry(entry),
        ],
      ),
    );
  }
  return document.save();
}

List<pw.Widget> _entry(YearBookPdfEntry entry) {
  final images = <pw.ImageProvider>[];
  for (final bytes in entry.images) {
    try {
      images.add(pw.MemoryImage(bytes));
    } on Object {
      // Ảnh không giải mã được: bỏ, vẫn in chú thích.
    }
  }
  return [
    if (images.isNotEmpty)
      pw.Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final image in images)
            pw.ClipRRect(
              horizontalRadius: 6,
              verticalRadius: 6,
              child: pw.Image(
                image,
                width: images.length == 1 ? 515 : 253,
                height: images.length == 1 ? 340 : 190,
                fit: pw.BoxFit.cover,
              ),
            ),
        ],
      ),
    pw.SizedBox(height: 6),
    pw.Text(
      entry.dateLine,
      style: const pw.TextStyle(fontSize: 10, color: _muted),
    ),
    if (entry.caption.isNotEmpty)
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 2),
        child: pw.Text(
          entry.caption,
          style: const pw.TextStyle(fontSize: 12, color: _ink),
        ),
      ),
    pw.SizedBox(height: 18),
  ];
}
