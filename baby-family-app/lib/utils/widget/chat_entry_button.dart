import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Lối vào nhắn tin (Pencil CHAT-04 cạnh chuông Trang chủ, CHAT-04b ở
/// Papa & Mama, người thân ở CIR-01): icon `message-circle` 24 trong vùng
/// chạm 40, huy hiệu số chưa đọc `primary-600` (Papa & Mama: `us-500`) viền
/// `bg`. [label] là nhãn trợ năng (mặc định “Tin nhắn”).
class ChatEntryButton extends StatelessWidget {
  const ChatEntryButton({
    required this.unread,
    required this.onTap,
    this.label,
    this.couple = false,
    super.key,
  });

  final int unread;
  final VoidCallback onTap;
  final String? label;
  final bool couple;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final badge = AppColors.resolve(
      context,
      couple ? kColorUs5009B85D1 : kColorPrimary600C2513F,
    );
    final icon = AppColors.resolve(
      context,
      couple ? kColorUs7006A549F : kColorTextPrimary2E2A27,
    );
    return Semantics(
      button: true,
      label: '${label ?? l10n.chatTitle}, ${l10n.chatUnread(unread)}',
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: AppSpacing.s6,
        child: SizedBox.square(
          dimension: AppSpacing.s10,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(LucideIcons.messageCircle, size: 24, color: icon),
              ),
              if (unread > 0)
                Positioned(
                  left: 22,
                  top: 2,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 18),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: badge,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: AppColors.resolve(context, kColorBgFFFBF7),
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: Text(
                      unread > 99 ? '99+' : '$unread',
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.noScaling,
                      style: AppTypography.micro.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onPrimary(context),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
