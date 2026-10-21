import 'dart:async';

import 'package:baby_family/utils/widget/voice_card.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// [VoiceCard] phát được ghi âm từ [url] (URL đã ký của server); chưa có URL
/// (bản mẫu) thì nút phát giữ hành vi cũ ([onTap]).
class PlayableVoiceCard extends StatefulWidget {
  const PlayableVoiceCard({
    required this.title,
    required this.duration,
    this.url,
    this.onTap,
    super.key,
  });

  final String title;
  final String duration;
  final String? url;
  final VoidCallback? onTap;

  @override
  State<PlayableVoiceCard> createState() => _PlayableVoiceCardState();
}

class _PlayableVoiceCardState extends State<PlayableVoiceCard> {
  VideoPlayerController? _player;

  @override
  void didUpdateWidget(PlayableVoiceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // URL ký lại (hết hạn) khi bản ghi được làm mới.
    if (oldWidget.url != widget.url) {
      _release();
    }
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  void _release() {
    final player = _player;
    _player = null;
    player?.removeListener(_onTick);
    unawaited(player?.dispose());
  }

  void _onTick() {
    final value = _player?.value;
    if (value != null &&
        value.isInitialized &&
        !value.isPlaying &&
        value.position >= value.duration) {
      unawaited(_player?.seekTo(Duration.zero));
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _toggle() async {
    final url = widget.url;
    if (url == null) {
      widget.onTap?.call();
      return;
    }
    var player = _player;
    if (player == null) {
      player = _player = VideoPlayerController.networkUrl(Uri.parse(url))
        ..addListener(_onTick);
      await player.initialize();
    }
    if (player.value.isPlaying) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = _player?.value;
    final total = value?.duration.inMilliseconds ?? 0;
    return VoiceCard(
      title: widget.title,
      duration: widget.duration,
      playing: value?.isPlaying ?? false,
      progress: total == 0 ? 0 : value!.position.inMilliseconds / total,
      onPlay: _toggle,
      onTap: widget.onTap,
    );
  }
}
