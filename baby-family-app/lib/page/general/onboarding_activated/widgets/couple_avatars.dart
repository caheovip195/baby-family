part of '../mobile/onboarding_activated_mobile_view.dart';

/// 2 vòng tròn 96 (Papa `child-peach`, Mama `child-mint`) viền 4 `primary-50`,
/// chồng lên nhau 16, chữ tên gọi 18/800; đệm trên 40, dưới 8.
class _CoupleAvatars extends StatelessWidget {
  const _CoupleAvatars({required this.parents});

  final List<Member> parents;

  @override
  Widget build(BuildContext context) {
    const size = 96.0;
    const overlap = AppSpacing.s4;
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.s10,
        bottom: AppSpacing.s2,
      ),
      child: SizedBox(
        height: size,
        child: Center(
          child: SizedBox(
            width: parents.isEmpty
                ? size
                : size * parents.length - overlap * (parents.length - 1),
            child: Stack(
              children: [
                for (var i = 0; i < parents.length; i++)
                  Positioned(
                    left: i * (size - overlap),
                    child: Container(
                      width: size,
                      height: size,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: parents[i].role == FamilyRole.father
                            ? kColorChildPeachFFB59E
                            : kColorChildMint9EDCC4,
                        border: Border.all(
                          color: AppColors.resolve(
                            context,
                            kColorPrimary50FFF4F1,
                          ),
                          width: 4,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.s2),
                          child: Text(
                            parents[i].callName,
                            style: AppTypography.h3.copyWith(
                              fontWeight: FontWeight.w800,
                              color: kColorTextPrimary2E2A27,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
