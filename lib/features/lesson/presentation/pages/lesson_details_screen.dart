import 'dart:async';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/hls_url_helper.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/lesson_details_header.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/lesson_navigation_bar.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/lesson_tabs.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/video_controls.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/q&a/presentation/cubit/discussion_cubit.dart';

class LessonDetailsScreen extends StatefulWidget {
  final List<LessonEntity> lessons;
  final int initialIndex;
  final String demoId;
  final bool isEnrolled;
  final bool isFirstSection;

  const LessonDetailsScreen({
    super.key,
    required this.lessons,
    required this.initialIndex,
    required this.demoId,
    this.isEnrolled = true,
    this.isFirstSection = true,
  });

  @override
  State<LessonDetailsScreen> createState() => _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
  static const int _freeLessonsCount = 2;

  late final BetterPlayerController _betterPlayerController;
  late final GlobalKey _betterPlayerGlobalKey;
  late final Dio _dio;
  late int _currentIndex;

  bool _isDownloadingVideo = false;
  bool _hasVideoError = false;
  bool _isFullscreen = false;

  Map<String, String> _qualities = {};
  String _currentQuality = 'auto';
  bool _isChangingQuality = false;

  LessonEntity get _currentLesson => widget.lessons[_currentIndex];

  int get _effectiveFreeLimit =>
      (!widget.isEnrolled && widget.isFirstSection) ? _freeLessonsCount : 0;

  bool get _isLockedNavigation => !widget.isEnrolled;

  bool get _hasNext {
    if (_isLockedNavigation && (_currentIndex + 1) >= _effectiveFreeLimit) {
      return false;
    }
    return _currentIndex < widget.lessons.length - 1;
  }

  bool get _hasPrevious => _currentIndex > 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    _betterPlayerGlobalKey = GlobalKey();
    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
        ),
        fit: BoxFit.contain,
        handleLifecycle: true,
        autoDispose: false,
      ),
    );

    _betterPlayerController.addEventsListener(_onPlayerEvent);
    _loadCurrentVideo();
  }

  @override
  void dispose() {
    if (_isFullscreen) {
      _restoreSystemUi();
    }
    _betterPlayerController.removeEventsListener(_onPlayerEvent);
    _betterPlayerController.dispose(forceDispose: true);
    super.dispose();
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (!mounted) return;
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.exception:
        setState(() {
          _isDownloadingVideo = false;
          _hasVideoError = true;
        });
        break;
      case BetterPlayerEventType.initialized:
        if (!_isChangingQuality) {
          setState(() => _isDownloadingVideo = false);
        }
        break;
      case BetterPlayerEventType.bufferingStart:
        setState(() => _isDownloadingVideo = true);
        break;
      case BetterPlayerEventType.bufferingEnd:
        if (!_isChangingQuality) {
          setState(() => _isDownloadingVideo = false);
        }
        break;
      default:
        break;
    }
  }

  int _loadToken = 0;

  Future<void> _loadCurrentVideo() async {
    final lesson = _currentLesson;
    final token = ++_loadToken;

    setState(() {
      _isDownloadingVideo = true;
      _hasVideoError = false;
      _qualities = {};
      _currentQuality = 'auto';
    });

    final masterUrl = HlsUrlHelper.buildMasterUrl(lesson.videoUrl);

    try {
      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        masterUrl,
        videoFormat: BetterPlayerVideoFormat.hls,
      );

      await _betterPlayerController.setupDataSource(dataSource);

      if (!mounted || token != _loadToken) return;
      _betterPlayerController.play();
    } catch (_) {
      try {
        final fallbackSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          lesson.videoUrl,
        );
        await _betterPlayerController.setupDataSource(fallbackSource);
        if (!mounted || token != _loadToken) return;
        _betterPlayerController.play();
      } catch (e) {
        if (!mounted || token != _loadToken) return;
        setState(() {
          _isDownloadingVideo = false;
          _hasVideoError = true;
        });
        return;
      }
    }

    _loadQualitiesInBackground(lesson.videoUrl, masterUrl, token);
  }

  Future<void> _loadQualitiesInBackground(
    String mp4Url,
    String masterUrl,
    int token,
  ) async {
    final fetchedQualities = await HlsUrlHelper.fetchQualities(
      mp4Url: mp4Url,
      dio: _dio,
    );

    if (!mounted || token != _loadToken) return;
    if (fetchedQualities.isEmpty) return;

    setState(() {
      _qualities = fetchedQualities;
      _currentQuality = 'auto';
    });
  }

  Future<void> _changeQuality(String qualityKey) async {
    if (qualityKey == _currentQuality) return;

    final List<BetterPlayerAsmsTrack> tracks =
        _betterPlayerController.betterPlayerAsmsTracks;

    setState(() {
      _isChangingQuality = true;
    });

    try {
      if (qualityKey == 'auto') {
        if (tracks.isNotEmpty) {
          _betterPlayerController.setTrack(tracks.first);
        }
        setState(() {
          _currentQuality = 'auto';
        });
      } else {
        if (tracks.isEmpty) {
          return;
        }

        final targetHeight = int.tryParse(qualityKey);
        final index = tracks.indexWhere((t) => t.height == targetHeight);

        if (index != -1) {
          _betterPlayerController.setTrack(tracks[index]);
          setState(() {
            _currentQuality = qualityKey;
          });
        }
      }
    } catch (e) {
      debugPrint('Quality change error: $e');
    } finally {
      if (mounted) {
        setState(() => _isChangingQuality = false);
      }
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

    return MultiBlocProvider(
      providers: [
        BlocProvider<LessonAttachmentCubit>(
          create: (_) => getIt<LessonAttachmentCubit>(),
        ),
        BlocProvider<DiscussionCubit>(
          create: (_) => getIt<DiscussionCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        body: Column(
          children: [
            LessonDetailsPageHeader(
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
                          LessonNavigationBar(
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
                              demoId: widget.demoId,
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

    return Stack(
      fit: StackFit.expand,
      children: [
        BetterPlayer(
          key: _betterPlayerGlobalKey,
          controller: _betterPlayerController,
        ),
        if (_isDownloadingVideo)
          const ColoredBox(
            color: Colors.black45,
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
          ),
        VideoControls(
          controller: _betterPlayerController,
          onNext: _hasNext ? _goToNext : null,
          onPrevious: _hasPrevious ? _goToPrevious : null,
          onFullscreen: _toggleFullscreen,
          isFullscreen: _isFullscreen,
          qualities: _qualities,
          currentQuality: _currentQuality,
          onQualityChanged: _changeQuality,
          betterPlayerGlobalKey: _betterPlayerGlobalKey,
        ),
      ],
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