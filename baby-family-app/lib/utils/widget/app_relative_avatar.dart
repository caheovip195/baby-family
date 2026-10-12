import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Avatar chữ của người thân (Pencil FAM-01 “BN/ÔN” 44 chữ 15/800, FAM-04 84
/// chữ 28/800): nền theo quan hệ (Bà nội `accent-100`, Bà ngoại
/// `child-peach`, Ông ngoại `child-mint`…), chữ `text-primary`.
class AppRelativeAvatar extends StatelessWidget {
  const AppRelativeAvatar({
    required this.name,
    this.relation,
    this.size = 44,
    super.key,
  });

  final String name;
  final RelativeRelation? relation;
  final double size;

  static Color colorOf(RelativeRelation? relation) => switch (relation) {
    RelativeRelation.grandmaPaternal => kColorAccent100FDF1D6,
    RelativeRelation.grandmaMaternal => kColorChildPeachFFB59E,
    RelativeRelation.grandpaMaternal => kColorChildMint9EDCC4,
    RelativeRelation.grandpaPaternal => kColorChildSky9CCBF2,
    RelativeRelation.auntUncle => kColorChildLilacC7B3F0,
    RelativeRelation.nanny => kColorChildLemonF7DD86,
    RelativeRelation.other || null => kColorChildSandE6C9A8,
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: name,
      image: true,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.resolve(context, colorOf(relation)),
          shape: BoxShape.circle,
        ),
        child: Text(
          nameInitials(name),
          style: AppTypography.h3.copyWith(
            fontSize: size / 3,
            height: 1.3,
            fontWeight: FontWeight.w800,
            color: kColorTextPrimary2E2A27,
          ),
        ),
      ),
    );
  }
}
