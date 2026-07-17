// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:project1/config/theme/app_colors.dart';
// import 'package:project1/core/di/service_locator.dart';
// import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
// import 'package:project1/features/course/presentation/widgets/course_tag.dart';
// import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
// import 'package:project1/features/lesson/presentation/widgets/datails/lesson_tabs.dart';
// import 'package:project1/features/lesson/presentation/widgets/datails/video_controls.dart';
// import 'package:project1/l10n/app_localizations.dart';

// class LessonDetailsScreen extends StatefulWidget {
//   final List<LessonEntity> lessons;
//   final int initialIndex;

//   const LessonDetailsScreen({
//     super.key,
//     required this.lessons,
//     required this.initialIndex,
//   });

//   @override
//   State<LessonDetailsScreen> createState() => _LessonDetailsScreenState();
// }

// class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
//   late final Player _player;
//   late final VideoController _videoController;
//   late int _currentIndex;

//   LessonEntity get _currentLesson => widget.lessons[_currentIndex];
//   bool get _hasNext => _currentIndex < widget.lessons.length - 1;
//   bool get _hasPrevious => _currentIndex > 0;

//   @override
// void initState() {
//   super.initState();
//   _currentIndex = widget.initialIndex;
//   _player = Player();
//   _videoController = VideoController(_player);
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     debugPrint(_currentLesson.videoUrl);
//     debugPrint("VIDEO URL: ${_currentLesson.videoUrl}");
//     _player.open(
//   Media(
//     _currentLesson.videoUrl,
//     httpHeaders: {
//       'User-Agent': 'Mozilla/5.0',
//     },
//   ),
// );
//     _player.stream.playing.listen((playing) {
//   debugPrint("PLAYING = $playing");
// });

// _player.stream.buffering.listen((buffering) {
//   debugPrint("BUFFERING = $buffering");
// });

// _player.stream.error.listen((error) {
//   debugPrint("PLAYER ERROR = $error");
// });
// _player.stream.position.listen((position) {
//   debugPrint("POSITION = $position");
// });
// _player.stream.duration.listen((value) {
//   debugPrint("DURATION = $value");
// });

// _player.stream.error.listen((value) {
//   debugPrint("ERROR = $value");
// });

// _player.stream.log.listen((event) {
//   debugPrint("MEDIAKIT LOG: $event");
// });

// _player.stream.buffering.listen((value) {
//   debugPrint("BUFFERING STREAM = $value");
// });

// _player.stream.duration.listen((value) {
//   debugPrint("DURATION STREAM = $value");
// });

// _player.stream.position.listen((value) {
//   debugPrint("POSITION STREAM = $value");
// });
//   });
// }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   void _goToNext() {
//   if (!_hasNext) return;
//   setState(() {
//     _currentIndex++;
//   });
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     _player.open(Media(_currentLesson.videoUrl));
//   });
// }

//   void _goToPrevious() {
//   if (!_hasPrevious) return;
//   setState(() {
//     _currentIndex--;
//   });
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     _player.open(Media(_currentLesson.videoUrl));
//   });
// }

//   String _formatDuration(int totalSeconds) {
//     final duration = Duration(seconds: totalSeconds);
//     return '${duration.inMinutes} min';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context)!;

//     return BlocProvider(
//       create: (_) => getIt<LessonAttachmentCubit>(),
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: Text(
//             _currentLesson.title,
//             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: Video(key: ValueKey(_currentLesson.id),controller: _videoController, controls: NoVideoControls),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: VideoControls(
//                   player: _player,
//                   onNext: _hasNext ? _goToNext : null,
//                   onPrevious: _hasPrevious ? _goToPrevious : null,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _currentLesson.title,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: [
//                         CourseTag(text: _formatDuration(_currentLesson.duration)),
//                         CourseTag(text: '${localizations.lessons} ${_currentLesson.order}'),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     Text(
//                       localizations.lessonOverview,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       _currentLesson.description,
//                       style: TextStyle(
//                         height: 1.6,
//                         color: Colors.grey[700],
//                         fontSize: 15,
//                       ),
//                     ),
//                     const SizedBox(height: 28),
//                     SizedBox(
//                       height: 450,
//                       child: LessonTabs(lessonId: _currentLesson.id),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
import 'package:project1/features/course/presentation/widgets/course_tag.dart';
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
  double _downloadProgress = 0;
  bool _hasVideoError = false;

  LessonEntity get _currentLesson => widget.lessons[_currentIndex];
  bool get _hasNext => _currentIndex < widget.lessons.length - 1;
  bool get _hasPrevious => _currentIndex > 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _player = Player();
    _videoController = VideoController(_player);

    _player.stream.playing.listen((playing) {
      debugPrint("PLAYING = $playing");
    });
    _player.stream.buffering.listen((buffering) {
      debugPrint("BUFFERING = $buffering");
    });
    _player.stream.error.listen((error) {
      debugPrint("PLAYER ERROR = $error");
    });
    _player.stream.log.listen((event) {
      debugPrint("MEDIAKIT LOG: $event");
    });

    _loadCurrentVideo();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentVideo() async {
    final lesson = _currentLesson;

    setState(() {
      _isDownloadingVideo = true;
      _downloadProgress = 0;
      _hasVideoError = false;
    });

    try {
      final localPath = await _downloadVideoLocally(
        lesson.videoUrl,
        onProgress: (progress) {
          if (!mounted) return;
          setState(() => _downloadProgress = progress);
        },
      );

      if (!mounted) return;

      await _player.open(Media(localPath));

      if (!mounted) return;
      setState(() => _isDownloadingVideo = false);
    } catch (e) {
      debugPrint('Video download failed: $e');
      if (!mounted) return;
      setState(() {
        _isDownloadingVideo = false;
        _hasVideoError = true;
      });
    }
  }

  Future<String> _downloadVideoLocally(
    String url, {
    required void Function(double progress) onProgress,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = url.split('/').last.split('?').first;
    final localPath = '${tempDir.path}/lesson_video_$fileName';
    final localFile = File(localPath);

    if (await localFile.exists()) {
      final length = await localFile.length();
      if (length > 0) {
        onProgress(1.0);
        return localPath;
      }
    }

    await Dio().download(
      url,
      localPath,
      onReceiveProgress: (received, total) {
        if (total > 0) {
          onProgress(received / total);
        }
      },
    );

    return localPath;
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

  String _formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    return '${duration.inMinutes} min';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<LessonAttachmentCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            _currentLesson.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildVideoArea(localizations),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: VideoControls(
                  player: _player,
                  onNext: _hasNext ? _goToNext : null,
                  onPrevious: _hasPrevious ? _goToPrevious : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentLesson.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        CourseTag(text: _formatDuration(_currentLesson.duration)),
                        CourseTag(text: '${localizations.lessons} ${_currentLesson.order}'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      localizations.lessonOverview,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _currentLesson.description,
                      style: TextStyle(
                        height: 1.6,
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 450,
                      child: LessonTabs(lessonId: _currentLesson.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoArea(AppLocalizations localizations) {
    if (_hasVideoError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                localizations.videoLoadFailed,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _loadCurrentVideo,
                child: Text(localizations.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_isDownloadingVideo) {
      return Container(
        color: Colors.black,
        child: Center(
          child: SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              value: _downloadProgress > 0 ? _downloadProgress : null,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return Video(
      key: ValueKey(_currentLesson.id),
      controller: _videoController,
      controls: NoVideoControls,
    );
  }
}