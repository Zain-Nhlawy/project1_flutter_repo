import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class LessonVideoHeader extends StatefulWidget {
  const LessonVideoHeader({super.key});

  @override
  State<LessonVideoHeader> createState() =>
      _LessonVideoHeaderState();
}

class _LessonVideoHeaderState
    extends State<LessonVideoHeader> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();

    player = Player();
    controller = VideoController(player);

    player.open(
      Media(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Video(
        controller: controller,
        controls: MaterialVideoControls,
      ),
    );
  }
}