part of '../mobile/circle_child_mobile_view.dart';

/// Đầu trang cháu (Pencil “Child Header”): avatar 84 viền màu bé, tên 30/800,
/// tuổi 18 `text-secondary`, nhãn “🎉 Ngày mai tròn 18 tháng” (`accent-100`
/// 14/700) khi ngày mai tròn tháng.
class _CircleChildHeader extends StatelessWidget {
  const _CircleChildHeader({
    required this.child,
    required this.today,
    required this.monthsTomorrow,
  });

  final Child child;
  final DateTime today;
  final int? monthsTomorrow;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final birth = child.birthDate;
    final months = monthsTomorrow;
    return Row(
      children: [
        ChildAvatar(
          child: child,
          size: 84,
          borderColor: ChildAvatar.colorOf(child),
          borderWidth: 3,
        ),
        const SizedBox(width: AppSpacing.s4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                child.name,
                style: AppTypography.adapt(
                  context,
                  AppTypography.display.copyWith(fontSize: 30, height: 41 / 30),
                ),
              ),
              if (birth != null) ...[
                const SizedBox(height: AppSpacing.s1),
                Text(
                  childAgeText(l10n, birth, today),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.h3.copyWith(
                      fontFamily: AppTypography.bodyFamily,
                      fontWeight: FontWeight.w400,
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ],
              if (months != null) ...[
                const SizedBox(height: AppSpacing.s1),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s3,
                    vertical: AppSpacing.s1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorAccent100FDF1D6),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    l10n.cirChildTomorrow(months),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kColorAccent7009A6A12,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
