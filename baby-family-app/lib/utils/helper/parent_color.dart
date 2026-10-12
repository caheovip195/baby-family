import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter/painting.dart';

/// Màu avatar chữ cái của Bố/Mẹ trong thiết kế (Mama `primary-500` “M”, Papa
/// `secondary-500` “P”) — CAL-02, CARE-08, SET-01…
Color parentAvatarColor(FamilyRole? role) => role == FamilyRole.mother
    ? kColorPrimary500EE7B67
    : kColorSecondary5006FAE8E;
