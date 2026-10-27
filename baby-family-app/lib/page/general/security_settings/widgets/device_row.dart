part of '../mobile/security_settings_mobile_view.dart';

/// Dòng thiết bị (Pencil `dg7Wz`): ô icon 32 (máy này `secondary-100`/
/// `secondary-700`), tên 15/500 + “Hà Nội · Đang dùng / 2 ngày trước /
/// 15/09/2026” 12; máy này: nhãn “Thiết bị này”; máy khác: viên viền
/// “Đăng xuất”.
class _DeviceRow extends StatelessWidget {
  const _DeviceRow({
    required this.device,
    required this.now,
    required this.onSignOut,
  });

  final LoginDevice device;
  final DateTime now;
  final VoidCallback onSignOut;

  /// Trong tuần: “2 ngày trước” (theo ngày lịch); xa hơn: ngày.
  static const _recentDays = 7;

  String _lastActive(BuildContext context) {
    final l10n = context.l10n;
    final last = device.lastActiveAt;
    if (last == null) {
      return device.location;
    }
    final days = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(last.year, last.month, last.day)).inDays;
    final time = days < _recentDays
        ? l10n.commonDaysAgo(days)
        : last.toFormDate(context.localeName);
    // Server chưa có vị trí đăng nhập: không để “ · 2 ngày trước”
    // (BF-20261026-002).
    return device.location.isEmpty
        ? time
        : l10n.setDeviceLastActive(device.location, time);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = device.current;
    return AppSettingsRow(
      icon: device.kind == DeviceKind.tablet
          ? LucideIcons.tablet
          : LucideIcons.smartphone,
      iconBackground: current
          ? kColorSecondary100E4F2EA
          : kColorSurfaceVariantF7F1EC,
      iconColor: current ? kColorSecondary7003F7A5C : kColorTextSecondary6B625B,
      title: device.name,
      subtitle: current
          ? device.location.isEmpty
                ? l10n.setDeviceInUseNoLocation
                : l10n.setDeviceInUse(device.location)
          : switch (_lastActive(context)) {
              '' => null,
              final String text => text,
            },
      showChevron: false,
      trailing: current
          ? AppTagPill(label: l10n.setThisDevice)
          : AppPillButton(
              label: l10n.settingsLogout,
              onPressed: onSignOut,
              outlined: true,
              height: 27,
              fontSize: 12,
              horizontalPadding: AppSpacing.s3,
              color: kColorTransparent,
              foreground: kColorTextPrimary2E2A27,
            ),
    );
  }
}
