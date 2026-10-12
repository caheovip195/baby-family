part of '../mobile/photo_viewer_mobile_view.dart';

/// Một ảnh trong MEM-08: pinch zoom (tối đa 4×), chạm đúp để thu về; báo
/// [onZoomChanged] để tắt vuốt ngang / vuốt xuống khi đang phóng to.
class _ViewerPhoto extends HookWidget {
  const _ViewerPhoto({required this.asset, required this.onZoomChanged});

  final String asset;
  final ValueChanged<bool> onZoomChanged;

  @override
  Widget build(BuildContext context) {
    final transform = useTransformationController();
    void reset() {
      transform.value = Matrix4.identity();
      onZoomChanged(false);
    }

    return GestureDetector(
      onDoubleTap: reset,
      child: InteractiveViewer(
        transformationController: transform,
        maxScale: 4,
        onInteractionEnd: (_) =>
            onZoomChanged(transform.value.getMaxScaleOnAxis() > 1.01),
        child: SizedBox.expand(
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            semanticLabel: context.l10n.memPhotoViewerTitle,
          ),
        ),
      ),
    );
  }
}
