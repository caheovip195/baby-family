part of '../mobile/pending_review_mobile_view.dart';

/// Bài chờ duyệt mở (Pencil “Pending 1”): thẻ `surface` viền bo 20 đệm 14
/// cách 12 — người đăng, ảnh, lời nhắn 15, sửa bé gắn, Từ chối / “Duyệt &
/// hiện” (48). Đang từ chối (“Pending 2”): ảnh nhỏ 52 cạnh người đăng và
/// khung lý do thay cho phần sửa + nút.
class _PendingCard extends StatelessWidget {
  const _PendingCard({
    required this.post,
    required this.controller,
    required this.onApprove,
    required this.onReject,
  });

  final Memory post;
  final PendingReviewController controller;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rejecting = controller.rejectingId == post.id;
    final caption = post.body ?? post.title;
    const gap = SizedBox(height: AppSpacing.s3);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PendingAuthorRow(
            post: post,
            controller: controller,
            trailing: rejecting && post.mediaAssets.isNotEmpty
                ? MemoryThumb(
                    kind: post.kind,
                    asset: post.mediaAssets.first,
                    size: 52,
                  )
                : null,
          ),
          if (!rejecting && post.mediaAssets.isNotEmpty) ...[
            gap,
            _PendingPhotos(assets: post.mediaAssets),
          ],
          if (caption != null) ...[
            gap,
            Text(
              caption,
              style: AppTypography.adapt(context, AppTypography.body),
            ),
          ],
          gap,
          if (rejecting)
            _RejectPanel(
              authorName: controller.authorOf(post)?.callName ?? '',
              controller: controller,
              onReject: onReject,
            )
          else ...[
            _ChildEditPanel(post: post, controller: controller),
            gap,
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: l10n.memPendingReject,
                    height: 48,
                    onPressed: () => controller.startReject(post),
                  ),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: AppButton(
                    label: l10n.memPendingApprove,
                    height: 48,
                    onPressed: onApprove,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
