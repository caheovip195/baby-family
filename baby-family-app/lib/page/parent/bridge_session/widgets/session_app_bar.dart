part of '../mobile/bridge_session_mobile_view.dart';

/// Thanh trên US-11 (`Gwk7W`): đệm 4/20/8/12; nút back 40 (`chevron-left`
/// 24) + “Cầu nối” 22/800 + khoá 12/11; nút “Tạm dừng” cao 34 (`surface`
/// viền `us-100`, `pause` 14 + 12/700 `us-700`).
class _SessionAppBar extends StatelessWidget {
  const _SessionAppBar({required this.onPause});

  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final shape = StadiumBorder(
      side: BorderSide(color: AppColors.resolve(context, kColorUs100EAE2F8)),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s3,
        AppSpacing.s1,
        AppSpacing.screen,
        AppSpacing.s2,
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.s10,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: l10n.commonBack,
              onPressed: () => context.router.maybePop(),
              icon: Icon(
                LucideIcons.chevronLeft,
                size: 24,
                color: AppColors.resolve(context, kColorTextPrimary2E2A27),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.usBridgeShort,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 2),
                UsPrivateLabel(l10n.usOnlyTwo, iconSize: 12, fontSize: 11),
              ],
            ),
          ),
          Material(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            shape: shape,
            child: InkWell(
              onTap: onPause,
              customBorder: shape,
              child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.pause, size: 14, color: usDark),
                    const SizedBox(width: AppSpacing.compact),
                    Text(
                      l10n.commonPause,
                      style: AppTypography.small.copyWith(
                        fontWeight: FontWeight.w700,
                        color: usDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
