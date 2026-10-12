part of '../mobile/welcome_mobile_view.dart';

class _WelcomeSlide extends StatelessWidget {
  const _WelcomeSlide({required this.data});

  final WelcomeSlideData data;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          image: true,
          label: data.title,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sheet),
            child: AspectRatio(
              aspectRatio: 350 / 340,
              child: Image.asset(data.imageAsset, fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s6),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s2,
            AppSpacing.s2,
            AppSpacing.s2,
            0,
          ),
          child: Column(
            children: [
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.h1.copyWith(height: 1.3),
                ),
              ),
              const SizedBox(height: AppSpacing.s3),
              Text(
                data.description,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.body.copyWith(
                    fontSize: 16,
                    height: 1.5,
                    color: kColorTextSecondary6B625B,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
