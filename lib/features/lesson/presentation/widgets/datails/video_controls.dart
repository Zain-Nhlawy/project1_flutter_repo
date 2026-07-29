import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:project1/config/theme/app_colors.dart';

class VideoControls extends StatefulWidget {
  final Player player;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onFullscreen;
  final bool isFullscreen;

  const VideoControls({
    super.key,
    required this.player,
    this.onNext,
    this.onPrevious,
    this.onFullscreen,
    this.isFullscreen = false,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  bool _playing = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _rate = 1.0;
  bool _visible = true;
  Timer? _hideTimer;

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
      _scheduleAutoHide();
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

    _scheduleAutoHide();
  }

  @override
  void dispose() {
    _playingSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _rateSub?.cancel();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _scheduleAutoHide() {
    _hideTimer?.cancel();
    if (!_playing) return;
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _visible = false);
    });
  }

  void _toggleVisibility() {
    setState(() => _visible = !_visible);
    if (_visible) _scheduleAutoHide();
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _toggleVisibility,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_visible)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded),
                    iconSize: 34,
                    color: widget.onPrevious != null
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    onPressed: widget.onPrevious,
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.replay_10_rounded),
                    iconSize: 32,
                    color: AppColors.primary,
                    onPressed: () => _seekRelative(const Duration(seconds: -10)),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      ),
                      iconSize: 40,
                      color: Colors.white,
                      onPressed: () => widget.player.playOrPause(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.forward_10_rounded),
                    iconSize: 32,
                    color: AppColors.primary,
                    onPressed: () => _seekRelative(const Duration(seconds: 10)),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded),
                    iconSize: 34,
                    color: widget.onNext != null
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    onPressed: widget.onNext,
                  ),
                ],
              ),
            ),
          if (_visible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 24, 6, 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.65),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: Colors.white30,
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
                            _scheduleAutoHide();
                          },
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<double>(
                      initialValue: _rate,
                      onSelected: (rate) => widget.player.setRate(rate),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.zero,
                      itemBuilder: (_) => [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                          .map((r) => PopupMenuItem(value: r, child: Text("${r}x")))
                          .toList(),
                      child: Text(
                        "${_rate}x",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (widget.onFullscreen != null) ...[
                      const SizedBox(width: 6),
                      IconButton(
                        icon: Icon(
                          widget.isFullscreen
                              ? Icons.fullscreen_exit_rounded
                              : Icons.fullscreen_rounded,
                        ),
                        iconSize: 20,
                        color: Colors.white,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: widget.onFullscreen,
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}