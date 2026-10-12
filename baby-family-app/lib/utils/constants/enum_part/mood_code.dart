part of '../enum.dart';

/// 10 cảm xúc của check-in (US-02) — thứ tự hiển thị theo Pencil w3t2ak.
enum MoodCode {
  ok('😊'),
  normal('🙂'),
  tired('😪'),
  exhausted('🥱'),
  stressed('😣'),
  sad('😢'),
  annoyed('😠'),
  overwhelmed('🤯'),
  lonely('🥺'),
  missYou('🤗');

  const MoodCode(this.emoji);

  /// Emoji cảm xúc (được phép theo Skill 8: emoji cho cảm xúc & reaction).
  final String emoji;
}
