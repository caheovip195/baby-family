import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final vi = lookupAppLocalizations(const Locale('vi'));

  Member relative({
    RelativeRelation? relation,
    Map<String, RelativePermission> permissions = const {},
    bool allowDownload = false,
  }) => Member(
    id: 'm',
    familyId: 'f',
    role: FamilyRole.relative,
    callName: 'Bà ngoại',
    relation: relation,
    childPermissions: permissions,
    allowDownload: allowDownload,
  );

  test('relation description follows the Papa / Mama side', () {
    String describe(RelativeRelation relation) => relativeRelationDescription(
      vi,
      relative(relation: relation),
      papaCallName: 'Papa',
      mamaCallName: 'Mama',
    );
    expect(describe(RelativeRelation.grandmaPaternal), 'Mẹ của Papa');
    expect(describe(RelativeRelation.grandpaMaternal), 'Bố của Mama');
    expect(describe(RelativeRelation.auntUncle), 'Cô / Dì');
    expect(describe(RelativeRelation.other), 'Bà ngoại');
  });

  test('permission summary uses the highest shared level', () {
    expect(
      relativePermissionSummary(
        vi,
        relative(
          permissions: {
            'hana': RelativePermission.comment,
            'haru': RelativePermission.contribute,
          },
        ),
      ),
      'Xem, bình luận · đóng góp ảnh',
    );
    expect(
      relativePermissionSummary(
        vi,
        relative(
          permissions: {'hana': RelativePermission.comment},
          allowDownload: true,
        ),
      ),
      'Xem, bình luận · được tải ảnh',
    );
    expect(
      relativePermissionSummary(
        vi,
        relative(permissions: {'hana': RelativePermission.hidden}),
      ),
      'Xem',
    );
  });

  test('initials, pronouns and name lists', () {
    expect(nameInitials('Bà nội'), 'BN');
    expect(nameInitials('Ông ngoại'), 'ÔN');
    expect(nameInitials('Mama'), 'M');
    expect(relativePronounCode(RelativeRelation.grandmaMaternal), 'grandma');
    expect(relativePronounCode(RelativeRelation.grandpaPaternal), 'grandpa');
    expect(relativePronounCode(null), 'other');
    expect(joinNames(vi, ['Hana', 'Haru', 'Bơ']), 'Hana, Haru và Bơ');
    expect(joinNames(vi, ['Hana']), 'Hana');
  });
}
