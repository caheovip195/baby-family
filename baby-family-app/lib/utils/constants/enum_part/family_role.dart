part of '../enum.dart';

/// Vai trò trong gia đình (ONB-03, BR-050). Nhãn gọi (Papa/Mama/Bố…) là dữ
/// liệu người dùng (`Member.callName`), không suy ra từ enum.
enum FamilyRole {
  father,
  mother,
  relative;

  bool get isParent => this != FamilyRole.relative;

  /// Vai trò của bạn đời khi lời mời bạn đời được chấp nhận.
  FamilyRole get partnerRole => switch (this) {
    FamilyRole.father => FamilyRole.mother,
    FamilyRole.mother => FamilyRole.father,
    FamilyRole.relative => FamilyRole.relative,
  };
}
