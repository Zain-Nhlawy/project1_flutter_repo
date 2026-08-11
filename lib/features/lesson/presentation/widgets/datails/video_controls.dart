import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

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

  String _formatDuration(Duration duration) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
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
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x33000000),
                    Color(0x10000000),
                    Color(0xB8000000),
                  ],
                  stops: [0, 0.48, 1],
                ),
              ),
            ),
          if (_visible)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _GlassVideoButton(
                    icon: Icons.skip_previous_rounded,
                    enabled: widget.onPrevious != null,
                    onPressed: widget.onPrevious,
                  ),
                  const SizedBox(width: 7),
                  _GlassVideoButton(
                    icon: Icons.replay_10_rounded,
                    onPressed: () =>
                        _seekRelative(const Duration(seconds: -10)),
                  ),
                  const SizedBox(width: 10),
                  _PrimaryVideoButton(
                    icon: _playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    onPressed: () => widget.player.playOrPause(),
                  ),
                  const SizedBox(width: 10),
                  _GlassVideoButton(
                    icon: Icons.forward_10_rounded,
                    onPressed: () => _seekRelative(const Duration(seconds: 10)),
                  ),
                  const SizedBox(width: 7),
                  _GlassVideoButton(
                    icon: Icons.skip_next_rounded,
                    enabled: widget.onNext != null,
                    onPressed: widget.onNext,
                  ),
                ],
              ),
            ),
          if (_visible)
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 20, 10, 8),
                child: Row(
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 5.5,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 13,
                          ),
                          activeTrackColor: AppColors.tertiary,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                          overlayColor: AppColors.tertiary.withValues(
                            alpha: 0.20,
                          ),
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
                            widget.player.seek(
                              Duration(milliseconds: value.toInt()),
                            );
                            _scheduleAutoHide();
                          },
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 7),
                    PopupMenuButton<double>(
                      initialValue: _rate,
                      onSelected: (rate) => widget.player.setRate(rate),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                      itemBuilder: (_) => [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                          .map(
                            (rate) => PopupMenuItem(
                              value: rate,
                              child: Text('${rate}x'),
                            ),
                          )
                          .toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          '${_rate}x',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    if (widget.onFullscreen != null) ...[
                      const SizedBox(width: 6),
                      _CompactVideoButton(
                        icon: widget.isFullscreen
                            ? Icons.fullscreen_exit_rounded
                            : Icons.fullscreen_rounded,
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

class _GlassVideoButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onPressed;

  const _GlassVideoButton({
    required this.icon,
    this.enabled = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: enabled ? 0.34 : 0.20),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: enabled ? 0.16 : 0.08),
        ),
      ),
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: Colors.white.withValues(alpha: enabled ? 0.95 : 0.30),
          size: 22,
        ),
      ),
    );
  }
}

class _PrimaryVideoButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _PrimaryVideoButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: Colors.white, size: 31),
      ),
    );
  }
}

class _CompactVideoButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CompactVideoButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
