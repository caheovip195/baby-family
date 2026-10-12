part of '../mobile/about_mobile_view.dart';

/// Thẻ ứng dụng (Pencil `grOIW`): nền `primary-50` bo 20, đệm [24,16], cách
/// 6 — ô logo 112 nền `surface`, “Baby Family” 22/800, “Phiên bản 1.0.0”
/// 13, khẩu hiệu 13 (dòng 1.45).
class _AppCardHeader extends StatelessWidget {
  const _AppCardHeader({required this.version});

  final String? version;

  static const _logoSize = 112.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final secondary = AppTypography.adapt(
      context,
      AppTypography.caption.copyWith(height: 1.45),
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s6,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorPrimary50FFF4F1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          Container(
            width: _logoSize,
            height: _logoSize,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.sheet),
            ),
            clipBehavior: Clip.antiAlias,
            child: const AppLogo(),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.appName,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(
              context,
              AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          if (version != null) ...[
            const SizedBox(height: 6),
            Text(
              l10n.setAppVersion(version!),
              textAlign: TextAlign.center,
              style: secondary,
            ),
          ],
          const SizedBox(height: 6),
          Text(
            l10n.splashTagline,
            textAlign: TextAlign.center,
            style: secondary,
          ),
        ],
      ),
    );
  }
}
