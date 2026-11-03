import 'package:baby_family/data/model/chat/chat_member.dart';
import 'package:baby_family/utils/widget/chat_member_avatar.dart';
import 'package:flutter/material.dart';

/// Chồng tối đa [max] avatar thành viên, lệch nhau 60% (Pencil CHAT-01 thẻ
/// cuộc trò chuyện, CHAT-02 thanh tiêu đề). Bố Mẹ đứng trước.
class ChatAvatarStack extends StatelessWidget {
  const ChatAvatarStack({
    required this.members,
    this.couple = false,
    this.size = 32,
    this.max = 3,
    super.key,
  });

  final List<ChatMember> members;
  final bool couple;
  final double size;
  final int max;

  @override
  Widget build(BuildContext context) {
    final shown =
        ([...members]
              ..sort((a, b) => (b.isParent ? 1 : 0) - (a.isParent ? 1 : 0)))
            .take(max)
            .toList();
    if (shown.isEmpty) {
      return SizedBox.square(dimension: size);
    }
    final step = size * 0.6;
    return SizedBox(
      width: size + step * (shown.length - 1),
      height: size,
      child: Stack(
        children: [
          for (final (index, member) in shown.indexed)
            Positioned(
              left: step * index,
              child: ChatMemberAvatar(
                name: member.displayName,
                parent: member.isParent,
                couple: couple,
                size: size,
                outlined: index > 0,
              ),
            ),
        ],
      ),
    );
  }
}
