import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/lesson_tabs.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/video_controls.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonDetailsScreen extends StatefulWidget {
  final List<LessonEntity> lessons;
  final int initialIndex;

  const LessonDetailsScreen({
    super.key,
    required this.lessons,
    required this.initialIndex,
  });

  @override
  State<LessonDetailsScreen> createState() => _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
  late final Player _player;
  late final VideoController _videoController;
  late int _currentIndex;

  bool _isDownloadingVideo = false;
  bool _hasVideoError = false;
  bool _isFullscreen = false;

  LessonEntity get _currentLesson => widget.lessons[_currentIndex];
  bool get _hasNext => _currentIndex < widget.lessons.length - 1;
  bool get _hasPrevious => _currentIndex > 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _player = Player();
    _videoController = VideoController(_player);
    _loadCurrentVideo();
  }

  @override
  void dispose() {
    if (_isFullscreen) {
      _restoreSystemUi();
    }
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentVideo() async {
    final lesson = _currentLesson;

    setState(() {
      _isDownloadingVideo = true;
      _hasVideoError = false;
    });

    try {
      await _player.open(Media(lesson.videoUrl));

      if (!mounted) return;
      setState(() => _isDownloadingVideo = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDownloadingVideo = false;
        _hasVideoError = true;
      });
    }
  }

  Future<void> _toggleFullscreen() async {
    setState(() => _isFullscreen = !_isFullscreen);

    if (_isFullscreen) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await _restoreSystemUi();
    }
  }

  Future<void> _restoreSystemUi() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _goToNext() {
    if (!_hasNext) return;
    setState(() => _currentIndex++);
    _loadCurrentVideo();
  }

  void _goToPrevious() {
    if (!_hasPrevious) return;
    setState(() => _currentIndex--);
    _loadCurrentVideo();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (_isFullscreen) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await _toggleFullscreen();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(child: _buildVideoArea(localizations)),
        ),
      );
    }

    return BlocProvider(
      create: (_) => getIt<LessonAttachmentCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        body: Column(
          children: [
            _LessonDetailsPageHeader(
              topPadding: MediaQuery.paddingOf(context).top,
              title: _currentLesson.title,
              currentLesson: _currentIndex + 1,
              totalLessons: widget.lessons.length,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        20,
                        20,
                        20,
                        0,
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.primaryOf(
                              context,
                            ).withValues(alpha: 0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOf(
                                context,
                              ).withValues(alpha: 0.18),
                              blurRadius: 22,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: _buildVideoArea(localizations),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        20,
                        20,
                        20,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LessonNavigationBar(
                            currentLesson: _currentIndex + 1,
                            totalLessons: widget.lessons.length,
                            previousLabel: localizations.previous,
                            nextLabel: localizations.next,
                            onPrevious: _hasPrevious ? _goToPrevious : null,
                            onNext: _hasNext ? _goToNext : null,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _currentLesson.title,
                                  style: AppTextStyles.h2.copyWith(
                                    color: AppColors.textPrimaryOf(context),
                                    fontSize: 25,
                                    height: 1.22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryOf(
                                    context,
                                  ).withValues(alpha: 0.09),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '#${_currentLesson.order.toString().padLeft(2, '0')}',
                                  style: AppTextStyles.label.copyWith(
                                    color: AppColors.primaryOf(context),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          _LessonSectionTitle(
                            icon: Icons.subject_rounded,
                            title: localizations.lessonOverview,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceOf(context),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.borderOf(
                                  context,
                                ).withValues(alpha: 0.78),
                              ),
                            ),
                            child: Text(
                              _currentLesson.description,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textSecondaryOf(context),
                                fontSize: 15,
                                height: 1.65,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            height: 500,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceOf(context),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: AppColors.borderOf(
                                  context,
                                ).withValues(alpha: 0.78),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? 0.18
                                        : 0.05,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: LessonTabs(
                              key: ValueKey(_currentLesson.id),
                              lessonId: _currentLesson.id,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoArea(AppLocalizations localizations) {
    if (_hasVideoError) {
      return ColoredBox(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  localizations.videoLoadFailed,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _loadCurrentVideo,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 17),
                  label: Text(localizations.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_isDownloadingVideo) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.7,
            ),
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Video(
          key: ValueKey(_currentLesson.id),
          controller: _videoController,
          controls: NoVideoControls,
        ),
        VideoControls(
          player: _player,
          onNext: _hasNext ? _goToNext : null,
          onPrevious: _hasPrevious ? _goToPrevious : null,
          onFullscreen: _toggleFullscreen,
          isFullscreen: _isFullscreen,
        ),
      ],
    );
  }
}

class _LessonDetailsPageHeader extends StatelessWidget {
  final double topPadding;
  final String title;
  final int currentLesson;
  final int totalLessons;

  const _LessonDetailsPageHeader({
    required this.topPadding,
    required this.title,
    required this.currentLesson,
    required this.totalLessons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.20),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -34,
            top: -52,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              20,
              topPadding > 0 ? topPadding + 8 : 32,
              20,
              18,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$currentLesson / $totalLessons',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonNavigationBar extends StatelessWidget {
  final int currentLesson;
  final int totalLessons;
  final String previousLabel;
  final String nextLabel;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const _LessonNavigationBar({
    required this.currentLesson,
    required this.totalLessons,
    required this.previousLabel,
    required this.nextLabel,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.78),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _LessonNavigationButton(
              label: previousLabel,
              icon: Icons.arrow_back_rounded,
              onPressed: onPrevious,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.primaryOf(context).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$currentLesson/$totalLessons',
              style: AppTextStyles.label.copyWith(
                color: AppColors.primaryOf(context),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: _LessonNavigationButton(
              label: nextLabel,
              icon: Icons.arrow_forward_rounded,
              iconAtEnd: true,
              isPrimary: true,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonNavigationButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool iconAtEnd;
  final bool isPrimary;

  const _LessonNavigationButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.iconAtEnd = false,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final primary = AppColors.primaryOf(context);

    final children = [
      Icon(
        icon,
        size: 16,
        color: enabled
            ? (isPrimary ? Colors.white : primary)
            : AppColors.textSecondaryOf(context).withValues(alpha: 0.45),
      ),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: enabled
                ? (isPrimary ? Colors.white : primary)
                : AppColors.textSecondaryOf(context).withValues(alpha: 0.45),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ];

    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: enabled && isPrimary
            ? AppColors.buttonGradientOf(context)
            : null,
        color: enabled && isPrimary
            ? null
            : primary.withValues(alpha: enabled ? 0.07 : 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: iconAtEnd ? children.reversed.toList() : children,
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _LessonSectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryOf(context).withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.primaryOf(context), size: 20),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.25,
            ),
          ),
        ),
      ],
    );
  }
}
