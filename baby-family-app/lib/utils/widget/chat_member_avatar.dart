import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:flutter/material.dart';

/// Avatar chữ cái của thành viên trò chuyện (Pencil CHAT-01/02): Bố Mẹ nền
/// `primary-500` chữ trắng, người thân `us-100` chữ `us-700`; cuộc trò chuyện
/// Papa & Mama ([couple]) nền `us-500`. Viền `bg` 2 khi xếp chồng.
/// Dùng ở CHAT-01 (chồng avatar) và CHAT-02 (cạnh bong bóng).
class ChatMemberAvatar extends StatelessWidget {
  const ChatMemberAvatar({
    required this.name,
    this.parent = true,
    this.couple = false,
    this.size = 28,
    this.outlined = false,
    super.key,
  });

  final String name;
  final bool parent;
  final bool couple;
  final double size;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final avatar = AppInitialAvatar(
      name: name,
      size: size,
      color: couple
          ? kColorUs5009B85D1
          : parent
          ? kColorPrimary500EE7B67
          : kColorUs100EAE2F8,
      foreground: couple || parent ? kColorWhite : kColorUs7006A549F,
    );
    if (!outlined) {
      return avatar;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.resolve(context, kColorBgFFFBF7),
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: avatar,
    );
  }
}
