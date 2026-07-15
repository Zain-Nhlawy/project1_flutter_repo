// import 'package:flutter/material.dart';
// import 'package:media_kit/media_kit.dart';

// class VideoControls extends StatelessWidget {
//   final Player player;
//   const VideoControls({super.key, required this.player});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // شريط التقدم (Slider)
//         SeekBar(player: player),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(icon: const Icon(Icons.replay_10), onPressed: () => player.seek(player.state.position - const Duration(seconds: 10))),
//             IconButton(icon: Icon(player.state.playing ? Icons.pause : Icons.play_arrow), iconSize: 48, onPressed: () => player.playOrPause()),
//             IconButton(icon: const Icon(Icons.forward_10), onPressed: () => player.seek(player.state.position + const Duration(seconds: 10))),
//           ],
//         ),
//         // سرعة التشغيل
//         PopupMenuButton<double>(
//           child: Text("${player.state.rate}x"),
//           onSelected: (rate) => player.setRate(rate),
//           itemBuilder: (_) => [0.5, 1.0, 1.5, 2.0].map((r) => PopupMenuItem(value: r, child: Text("${r}x"))).toList(),
//         ),
//       ],
//     );
//   }
// }