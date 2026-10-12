part of '../mobile/welcome_mobile_view.dart';

class _WelcomePageDots extends StatelessWidget {
  const _WelcomePageDots({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var index = 0; index < count; index++) ...[
        if (index > 0) const SizedBox(width: AppSpacing.s2),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: index == currentIndex ? AppSpacing.s6 : AppSpacing.s2,
          height: AppSpacing.s2,
          decoration: BoxDecoration(
            color: AppColors.resolve(
              context,
              index == currentIndex
                  ? kColorPrimary500EE7B67
                  : kColorBorderEADFD6,
            ),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ],
    ],
  );
}
