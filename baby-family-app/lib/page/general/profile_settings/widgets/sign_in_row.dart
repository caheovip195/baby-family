part of '../mobile/profile_settings_mobile_view.dart';

/// Dòng phương thức đăng nhập (Pencil `ZLaiv`): ô icon 32 (Apple, chữ “G”,
/// điện thoại), tên 15/500 + tài khoản che 12; đã liên kết: “Huỷ liên kết”
/// 12/600 `text-secondary`; chưa: “Chưa liên kết” `text-tertiary` + viên
/// “Liên kết” nền `primary-600`.
class _SignInRow extends StatelessWidget {
  const _SignInRow({required this.method, required this.onToggle});

  final SignInMethod method;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (title, icon) = switch (method.method) {
      AuthMethod.apple => (l10n.setSignInApple, LucideIcons.apple),
      AuthMethod.google => (l10n.setSignInGoogle, null),
      AuthMethod.phone => (l10n.authPhoneLabel, LucideIcons.phone),
    };
    return AppSettingsRow(
      icon: icon,
      iconLabel: icon == null ? 'G' : null,
      title: title,
      subtitle: method.linked ? method.maskedAccount : l10n.setNotLinked,
      subtitleColor: method.linked
          ? kColorTextSecondary6B625B
          : kColorTextTertiary9C928A,
      minHeight: 60,
      showChevron: false,
      trailing: method.linked
          ? InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s1),
                child: Text(
                  l10n.setUnlink,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          : AppPillButton(
              label: l10n.setLink,
              onPressed: onToggle,
              height: 27,
              fontSize: 12,
              horizontalPadding: AppSpacing.s3,
              color: kColorPrimary600C2513F,
              foreground: kColorWhite,
            ),
    );
  }
}
