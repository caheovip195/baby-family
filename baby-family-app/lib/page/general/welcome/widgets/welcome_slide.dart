part of '../mobile/welcome_mobile_view.dart';

class _WelcomeSlide extends StatelessWidget {
  const _WelcomeSlide({required this.data});

  final WelcomeSlideData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: const BoxDecoration(
            color: kColorPrimary100FFE3DC,
            shape: BoxShape.circle,
          ),
          child: Icon(data.icon, size: 64, color: kColorPrimary500EE7B67),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(data.title, textAlign: TextAlign.center, style: AppTypography.h1),
        const SizedBox(height: AppSpacing.s3),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: AppTypography.bodyLarge.copyWith(
            color: kColorTextSecondary6B625B,
          ),
        ),
      ],
    );
  }
}
