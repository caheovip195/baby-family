import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:baby_family/utils/helper/year_book_pdf.dart';
import 'package:flutter_test/flutter_test.dart';

/// PNG 1×1 hợp lệ và một ảnh hỏng (bỏ qua, vẫn in chú thích).
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGA'
  'hKmMIQAAAABJRU5ErkJggg==',
);

ByteData _font(String name) =>
    ByteData.sublistView(File('assets/fonts/$name').readAsBytesSync());

void main() {
  test('BF-20261028-013: REC-04 builds a Vietnamese PDF on device', () async {
    final bytes = await buildYearBookPdf(
      YearBookPdfInput(
        title: 'Năm 2025 của Haru',
        subtitle: 'Những khoảnh khắc nhà mình đã lưu',
        regularFont: _font('BeVietnamPro-Regular.ttf'),
        boldFont: _font('BeVietnamPro-SemiBold.ttf'),
        chapters: [
          YearBookPdfChapter(
            heading: 'Tháng 3',
            entries: [
              YearBookPdfEntry(
                caption: 'Lẫy lần đầu — ướt đẫm mồ hôi',
                dateLine: '02/03/2025',
                images: [
                  _png,
                  _png,
                  Uint8List.fromList([1, 2, 3]),
                ],
              ),
              const YearBookPdfEntry(caption: '', dateLine: '20/03/2025'),
            ],
          ),
        ],
      ),
    );
    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
    expect(bytes.length, greaterThan(1000));
  });
}
