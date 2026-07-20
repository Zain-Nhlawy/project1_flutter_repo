import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:project1/config/theme/app_colors.dart';

class VideoControls extends StatefulWidget {
  final Player player;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const VideoControls({
    super.key,
    required this.player,
    this.onNext,
    this.onPrevious,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  bool _playing = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _rate = 1.0;

  StreamSubscription? _playingSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _rateSub;

  @override
  void initState() {
    super.initState();
    _playing = widget.player.state.playing;
    _position = widget.player.state.position;
    _duration = widget.player.state.duration;
    _rate = widget.player.state.rate;

    _playingSub = widget.player.stream.playing.listen((playing) {
      if (mounted) setState(() => _playing = playing);
    });
    _positionSub = widget.player.stream.position.listen((position) {
      if (mounted) setState(() => _position = position);
    });
    _durationSub = widget.player.stream.duration.listen((duration) {
      if (mounted) setState(() => _duration = duration);
    });
    _rateSub = widget.player.stream.rate.listen((rate) {
      if (mounted) setState(() => _rate = rate);
    });
  }

  @override
  void dispose() {
    _playingSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _rateSub?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = d.inHours;
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  void _seekRelative(Duration offset) {
    final target = _position + offset;
    final clamped = target < Duration.zero
        ? Duration.zero
        : (target > _duration ? _duration : target);
    widget.player.seek(clamped);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                _formatDuration(_position),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.border,
                    thumbColor: AppColors.primary,
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inMilliseconds > 0
                        ? _duration.inMilliseconds.toDouble()
                        : 1,
                    value: _position.inMilliseconds
                        .clamp(0, _duration.inMilliseconds)
                        .toDouble(),
                    onChanged: (value) {
                      widget.player.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded),
                iconSize: 28,
                color: widget.onPrevious != null
                    ? AppColors.primary
                    : AppColors.textSecondary,
                onPressed: widget.onPrevious,
              ),
              IconButton(
                icon: const Icon(Icons.replay_10_rounded),
                iconSize: 26,
                color: AppColors.primary,
                onPressed: () => _seekRelative(const Duration(seconds: -10)),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                  iconSize: 32,
                  color: Colors.white,
                  onPressed: () => widget.player.playOrPause(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.forward_10_rounded),
                iconSize: 26,
                color: AppColors.primary,
                onPressed: () => _seekRelative(const Duration(seconds: 10)),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next_rounded),
                iconSize: 28,
                color: widget.onNext != null
                    ? AppColors.primary
                    : AppColors.textSecondary,
                onPressed: widget.onNext,
              ),
            ],
          ),
          const SizedBox(height: 4),
          PopupMenuButton<double>(
            initialValue: _rate,
            onSelected: (rate) => widget.player.setRate(rate),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (_) => [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                .map((r) => PopupMenuItem(value: r, child: Text("${r}x")))
                .toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${_rate}x",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
