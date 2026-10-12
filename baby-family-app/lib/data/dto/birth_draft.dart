import 'package:baby_family/utils/constants/enum.dart';

/// Thông tin một bé trong luồng Bé đã chào đời (PREG-05 B2), điền sẵn từ tên
/// đã chọn (PREG-07) và bản nháp của thai kỳ.
class BirthDraft {
  const BirthDraft({
    this.name = '',
    this.nickname,
    this.birthDate,
    this.birthTime,
    this.gender = ChildGender.unknown,
    this.weightKg,
    this.heightCm,
    this.photoAsset,
    this.samplePhotoAsset,
  });

  /// Tên chính thức (không gồm tên ở nhà).
  final String name;

  /// Tên ở nhà (tên gọi thai kỳ, ví dụ “Bơ”).
  final String? nickname;
  final DateTime? birthDate;

  /// `HH:mm`.
  final String? birthTime;
  final ChildGender gender;
  final double? weightKg;
  final double? heightCm;

  /// Ảnh đầu tiên người dùng đã chọn (B2).
  final String? photoAsset;

  /// Ảnh dùng cho thẻ chào mừng khi chưa chọn ảnh (B3).
  final String? samplePhotoAsset;

  String? get welcomePhoto => photoAsset ?? samplePhotoAsset;

  BirthDraft copyWith({
    String? name,
    String? nickname,
    DateTime? birthDate,
    String? birthTime,
    ChildGender? gender,
    double? weightKg,
    double? heightCm,
    String? photoAsset,
  }) {
    return BirthDraft(
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      gender: gender ?? this.gender,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      photoAsset: photoAsset ?? this.photoAsset,
      samplePhotoAsset: samplePhotoAsset,
    );
  }
}
