part of '../mobile/partner_invite_mobile_view.dart';

/// “Người nhận sẽ thấy trước khi tham gia” (Pencil “Recipient Sees”): nền
/// `surface`, viền `border`, bo 16, đệm 14; avatar các bé 36 chồng −8 viền
/// trắng 2, “Nhà Lan · Hana, Haru, Bơ” 14/600 + ghi chú 12 `text-tertiary`.
class _RecipientPreview extends StatelessWidget {
  const _RecipientPreview({
    required this.familyName,
    required this.children,
    required this.inviterName,
    required this.inviterCallName,
  });

  final String familyName;
  final List<Child> children;
  final String inviterName;
  final String inviterCallName;

  static const _avatar = 36.0;
  static const _overlap = 8.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final names = [for (final child in children) child.name].join(', ');
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.famPartnerRecipientSees,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                height: 16 / 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              if (children.isNotEmpty) ...[
                SizedBox(
                  width: _avatar + (children.length - 1) * (_avatar - _overlap),
                  height: _avatar,
                  child: Stack(
                    children: [
                      for (final (index, child) in children.indexed)
                        Positioned(
                          left: index * (_avatar - _overlap),
                          child: ChildAvatar(
                            child: child,
                            size: _avatar,
                            borderColor: kColorSurfaceFFFFFF,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      names.isEmpty
                          ? familyName
                          : l10n.commonDotJoin(familyName, names),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.famPartnerRecipientHint(
                        inviterName,
                        inviterCallName,
                      ),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          color: kColorTextTertiary9C928A,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
