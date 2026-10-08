# Skill 5: Final Self Review & Hidden Bug Detection

## Goal
After every implementation or fix, perform a strict final review to ensure the solution is correct, safe, and fully compliant with all project rules.

## Mandatory Review

After modifying code, always review the implementation against:

- All skill files in `.skills`
- Existing project architecture
- Existing coding style
- Flutter/Dart compatibility rules
- Data model rules
- UI behavior
- Business logic
- Error handling
- Edge cases
- State management flow
- API/data mapping
- Navigation flow
- Null safety
- Async lifecycle safety

## Required Checks

Before finishing, verify:

- No project rule was violated.
- No unrelated file was changed.
- No backup, duplicate, temporary, or copy file was created.
- No existing logic was accidentally removed or overwritten.
- No previous fix was broken by a later change.
- No hidden UI issue was introduced.
- No layout overflow risk was introduced.
- No `setState`/state update can run after dispose.
- No async race condition was introduced.
- No null crash risk was introduced.
- No incorrect API field mapping was introduced.
- No navigation, route, provider, bloc, controller, or dependency injection issue was introduced.
- No performance regression was introduced through unnecessary rebuilds.
- No deprecated Flutter/Dart API was used.

## Validation Commands

When applicable, run or recommend:

```bash
fvm dart format .
fvm flutter analyze
fvm flutter test
fvm dart run build_runner build