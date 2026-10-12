part of '../mobile/letter_composer_mobile_view.dart';

/// Phong bì xem trước (`n9KNY`): cao 156, nền `#F6E6D2`, viền `#E5CFB3`, bo
/// 10; nắp tam giác cao 80 `#EFD8BC`; dấu sáp 44 `primary-600` viền
/// `primary-700` (tim 20 trắng) ở mũi nắp; địa chỉ trái dưới: “Gửi Haru” chữ
/// tay 24/700 `#7A4E2E` + ngày mở 12/500 `#8C6A4E`.
class _LetterEnvelope extends StatelessWidget {
  const _LetterEnvelope({required this.name, required this.meta});

  final String name;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: kColorEnvelopeF6E6D2,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: kColorEnvelopeBorderE5CFB3),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 80,
            child: CustomPaint(painter: _EnvelopeFlapPainter()),
          ),
          Positioned(
            top: 58,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: kColorPrimary600C2513F,
                  shape: BoxShape.circle,
                  border: Border.all(color: kColorPrimary700A2402F),
                ),
                child: const Icon(
                  LucideIcons.heart,
                  size: 20,
                  color: kColorWhite,
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.screen,
            right: AppSpacing.screen,
            bottom: AppSpacing.s3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.handwriting.copyWith(
                    color: kColorEnvelopeInk7A4E2E,
                  ),
                ),
                Text(
                  meta,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w500,
                    color: kColorEnvelopeMeta8C6A4E,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Nắp phong bì: tam giác từ hai góc trên xuống giữa.
class _EnvelopeFlapPainter extends CustomPainter {
  const _EnvelopeFlapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas
      ..drawPath(path, Paint()..color = kColorEnvelopeFlapEFD8BC)
      ..drawPath(
        path,
        Paint()
          ..color = kColorEnvelopeBorderE5CFB3
          ..style = PaintingStyle.stroke,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
