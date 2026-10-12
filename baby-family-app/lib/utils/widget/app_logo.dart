import 'package:baby_family/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Logo Baby Family (Pencil Logo Mark `SkkmR`, ảnh xuất `bwVCm.png`).
/// SPL-01: 112; AUTH-01: 72.
class AppLogo extends StatelessWidget {
  const AppLogo({this.size = 112, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    child: Assets.images.bwVCm.image(width: size, height: size),
  );
}
