import 'dart:async';
import 'dart:io';
import 'package:better_player_plus/better_player_plus.dart';

class VideoDurationHelper {
  const VideoDurationHelper._();

  static Future<Duration> getDuration(File file) async {
    final controller = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: false,
        handleLifecycle: false,
        autoDispose: false,
      ),
    );

    final completer = Completer<Duration>();

    void listener(BetterPlayerEvent event) {
      if (completer.isCompleted) return;

      switch (event.betterPlayerEventType) {
        case BetterPlayerEventType.initialized:
          final duration =
              controller.videoPlayerController?.value.duration ??
              Duration.zero;
          completer.complete(duration);
          break;
        case BetterPlayerEventType.exception:
          completer.complete(Duration.zero);
          break;
        default:
          break;
      }
    }

    controller.addEventsListener(listener);

    try {
      await controller.setupDataSource(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          file.path,
        ),
      );

      return await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => Duration.zero,
      );
    } catch (_) {
      return Duration.zero;
    } finally {
      controller.removeEventsListener(listener);
      controller.dispose(forceDispose: true);
    }
  }
}