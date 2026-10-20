part of '../mobile/photo_viewer_mobile_view.dart';

/// Một video trong MEM-08: poster trước khi tải xong, chạm để phát/dừng,
/// thanh tiến độ phía dưới (video_player; URL server hoặc file vừa chọn).
class _ViewerVideo extends HookWidget {
  const _ViewerVideo({required this.source, required this.poster});

  final String source;
  final String poster;

  @override
  Widget build(BuildContext context) {
    final player = useMemoized(
      () => source.startsWith('/')
          ? VideoPlayerController.file(File(source))
          : VideoPlayerController.networkUrl(Uri.parse(source)),
      [source],
    );
    final ready = useState(false);
    final failed = useState(false);
    useEffect(() {
      player.initialize().then(
        (_) => ready.value = true,
        onError: (Object _) => failed.value = true,
      );
      return player.dispose;
    }, [player]);
    final value = useValueListenable(player);
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label: value.isPlaying ? l10n.memVideoPause : l10n.memVideoPlay,
      child: GestureDetector(
        onTap: ready.value
            ? () => value.isPlaying ? player.pause() : player.play()
            : null,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (ready.value)
              Center(
                child: AspectRatio(
                  aspectRatio: value.aspectRatio,
                  child: VideoPlayer(player),
                ),
              )
            else if (!isLocalVideo(poster))
              Image(
                image: mediaImageProvider(poster),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            if (!value.isPlaying)
              Center(
                child: Icon(
                  failed.value ? LucideIcons.videoOff : LucideIcons.circlePlay,
                  size: 56,
                  color: kColorWhiteAlpha80,
                ),
              ),
            if (ready.value)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VideoProgressIndicator(
                  player,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: kColorPrimary500EE7B67,
                    bufferedColor: kColorWhiteAlpha40,
                    backgroundColor: kColorWhiteAlpha13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
