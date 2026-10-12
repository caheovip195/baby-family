import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Icon Lucide theo tên kebab-case lưu trong dữ liệu (sự kiện lịch CARE-07,
/// huy hiệu CARE-10, loại nhiệm vụ CARE-12, lời cảm ơn US-06). Tên chưa biết
/// rơi về [missionIcon] (bộ icon nhiệm vụ) rồi `heart-handshake`.
IconData lucideIconByName(String? name) => switch (name) {
  'house-heart' => LucideIcons.houseHeart,
  'notebook-pen' => LucideIcons.notebookPen,
  'lock' => LucideIcons.lock,
  'cake' => LucideIcons.cake,
  'backpack' => LucideIcons.backpack,
  'star' => LucideIcons.star,
  'handshake' => LucideIcons.handshake,
  'flower-2' => LucideIcons.flower2,
  'hand-heart' => LucideIcons.handHeart,
  'mail' => LucideIcons.mail,
  'heart-handshake' => LucideIcons.heartHandshake,
  'heart-pulse' => LucideIcons.heartPulse,
  'puzzle' => LucideIcons.puzzle,
  'coffee' => LucideIcons.coffee,
  'shirt' => LucideIcons.shirt,
  'sun' => LucideIcons.sun,
  'heart' => LucideIcons.heart,
  'award' => LucideIcons.award,
  _ => missionIcon(name),
};
