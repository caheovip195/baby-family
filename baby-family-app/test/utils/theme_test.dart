import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double contrast(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final light = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final dark = firstLuminance < secondLuminance
      ? firstLuminance
      : secondLuminance;
  return (light + .05) / (dark + .05);
}

void main() {
  test('Primary actions and private-space actions maintain AA contrast', () {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      expect(
        contrast(theme.colorScheme.primary, theme.colorScheme.onPrimary),
        greaterThanOrEqualTo(4.5),
      );
    }
    expect(
      contrast(kColorDarkUs700D2C6F0, kColorDarkPrimary502A1A16),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      contrast(kColorDarkTextPrimaryF5EFEA, kColorDarkSurface221E1B),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      contrast(kColorDarkTextSecondaryBDB3AB, kColorDarkUs1002C2440),
      greaterThanOrEqualTo(4.5),
    );
  });

  testWidgets(
    'Private panels and explicit typography adapt when the theme changes',
    (tester) async {
      Future<void> render(ThemeMode mode) => tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          home: Scaffold(
            body: Builder(
              builder: (context) => AppPanel(
                color: kColorUs100EAE2F8,
                child: Text(
                  'Papa & Mama',
                  style: AppTypography.adapt(context, AppTypography.h3),
                ),
              ),
            ),
          ),
        ),
      );

      await render(ThemeMode.light);
      await tester.pumpAndSettle();
      final light = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(AppPanel),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(light.color, kColorUs100EAE2F8);

      await render(ThemeMode.dark);
      await tester.pumpAndSettle();
      final dark = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(AppPanel),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(dark.color, kColorDarkUs1002C2440);
      expect(
        tester.widget<Text>(find.text('Papa & Mama')).style!.color,
        kColorDarkTextPrimaryF5EFEA,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
