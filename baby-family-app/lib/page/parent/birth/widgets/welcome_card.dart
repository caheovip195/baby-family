part of '../mobile/birth_mobile_view.dart';

/// Thẻ chào mừng (Pencil `KFG8r`): `surface`, bo 28, bóng `#6A549F33`
/// (y 10, blur 30); ảnh cao 240; thân đệm 18, cách 6, căn giữa.
class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({
    required this.baby,
    required this.siblings,
    this.familyName,
  });

  final BirthDraft baby;
  final String? familyName;
  final List<Child> siblings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final photo = baby.welcomePhoto;
    final nickname = baby.nickname ?? '';
    final details = [
      ?baby.birthTime,
      ?baby.birthDate?.toFormDate(context.localeName),
      if (baby.weightKg != null)
        l10n.pregKg(_formatMeasure(context, baby.weightKg!)),
    ].join(' · ');
    final names = siblings.map((child) => child.name).toList();
    final siblingText = names.isEmpty
        ? null
        : names.length == 1
        ? names.single
        : l10n.pregNamesAnd(
            names.sublist(0, names.length - 1).join(', '),
            names.last,
          );
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.sheet),
        boxShadow: AppColors.isDark(context)
            ? null
            : const [
                BoxShadow(
                  color: kColorShadowUs700Alpha20,
                  offset: Offset(0, 10),
                  blurRadius: 30,
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (photo != null)
            Image.asset(
              photo,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox(height: 240),
            ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                if (familyName != null)
                  Text(
                    l10n.pregBirthFamilyWelcomes(familyName!).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.tiny.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: kColorUs7006A549F,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.compact),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n.pregBirthWelcomeName(
                      baby.name.isEmpty ? nickname : baby.name,
                    ),
                    maxLines: 1,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.h1.copyWith(fontSize: 28, height: 38 / 28),
                    ),
                  ),
                ),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.compact),
                  Text(
                    details,
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(context, AppTypography.caption),
                  ),
                ],
                if (nickname.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.compact),
                  Text(
                    siblingText == null
                        ? l10n.pregBirthNickname(nickname)
                        : l10n.pregBirthNicknameSiblings(nickname, siblingText),
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: kColorPrimary700A2402F,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
