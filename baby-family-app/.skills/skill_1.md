# Skill 1: Flutter & Dart Compatibility

## Goal
Always write, modify, and refactor code compatible with Flutter >= 3.44.x and Dart >= 3.12.x.

## Rules

- Use only APIs, syntax, and best practices supported by Flutter 3.44.x and Dart 3.12.x or newer.
- Never use deprecated APIs, classes, methods, or patterns.
- Before coding, check:
   - pubspec.yaml
   - Flutter/Dart SDK version
   - analysis_options.yaml
   - project architecture
   - existing coding style
- If deprecated code exists, replace it with the modern equivalent while preserving behavior.
- Prefer modern Dart features:
   - Null Safety
   - const constructors
   - super.key
   - final/late appropriately
   - strong typing
   - avoid unnecessary dynamic
   - avoid unnecessary `!`
- Do not introduce outdated Flutter patterns or obsolete widgets.

## Self Validation

Before finishing, verify:

- Compatible with Flutter 3.44.x and Dart 3.12.x
- No deprecated APIs
- No analyzer or lint issues
- Follows the project's architecture and coding style
- Recommend or run:
   - fvm dart format .
   - fvm flutter analyze
   - fvm dart fix --apply (when applicable)

If any rule is violated, fix it before responding.