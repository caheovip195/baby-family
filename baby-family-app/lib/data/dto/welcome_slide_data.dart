import 'package:flutter/widgets.dart';

/// Nội dung 1 slide ở màn Welcome (ONB-01).
class WelcomeSlideData {
  const WelcomeSlideData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
