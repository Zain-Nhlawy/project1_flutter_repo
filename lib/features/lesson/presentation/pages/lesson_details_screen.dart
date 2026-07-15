// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:project1/features/course/presentation/widgets/course_tag.dart';
// import 'package:project1/features/lesson/presentation/cubit/lesson_cubit.dart';
// import 'package:project1/features/lesson/presentation/cubit/lesson_state.dart';
// import '../widgets/lesson_tabs.dart';
// import '../widgets/lesson_video_header.dart';

// // class LessonDetailsScreen extends StatelessWidget {
// //   const LessonDetailsScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const LessonVideoHeader(),

// //             Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text(
// //                     "Introduction to Deep Learning",
// //                     style: TextStyle(
// //                       fontSize: 26,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),

// //                   const SizedBox(height: 16),

// //                   Wrap(
// //                     spacing: 8,
// //                     runSpacing: 8,
// //                     children: const [
// //                       CourseTag(
// //                         text: "45 min",
// //                       ),
// //                       CourseTag(
// //                         text: "Lesson 3",
// //                       ),
// //                       CourseTag(
// //                         text: "12.5K Views",
// //                       ),
// //                       CourseTag(
// //                         text: "Completed",
// //                       ),
// //                     ],
// //                   ),

// //                   const SizedBox(height: 24),

// //                   Text(
// //                     "Lesson Overview",
// //                     style: TextStyle(
// //                       fontSize: 22,
// //                       fontWeight: FontWeight.bold,
// //                       color: Theme.of(context).primaryColor,
// //                     ),
// //                   ),

// //                   const SizedBox(height: 12),

// //                   Text(
// //                     "This lesson introduces the fundamentals of deep learning, neural networks, training strategies, and real-world applications.",
// //                     style: TextStyle(
// //                       height: 1.6,
// //                       color: Colors.grey,
// //                       fontSize: 16,
// //                     ),
// //                   ),

// //                   const SizedBox(height: 30),

// //                   const SizedBox(
// //                     height: 500,
// //                     child: LessonTabs(),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


// class LessonDetailsScreen extends StatefulWidget {
//   final String lessonId;
//   const LessonDetailsScreen({super.key, required this.lessonId});

//   @override
//   State<LessonDetailsScreen> createState() => _LessonDetailsScreenState();
// }

// class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
//   late final Player _player = Player();
//   late final VideoController _videoController = VideoController(_player);

//   @override
//   void initState() {
//     super.initState();
//     // هنا يجب استدعاء الـ Cubit لجلب بيانات الدرس
//     context.read<LessonCubit>().getLesson(widget.lessonId);
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<LessonCubit, LessonState>(
//         builder: (context, state) {
//           if (state is LessonLoading) return const Center(child: CircularProgressIndicator());
//           if (state is LessonLoaded) {
//             final lesson = state.lesson;
//             _player.open(Media(lesson.videoUrl)); // تحميل الفيديو

//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // مشغل الفيديو
//                   AspectRatio(
//                     aspectRatio: 16 / 9,
//                     child: Video(controller: _videoController),
//                   ),
//                   VideoControls(player: _player),
                  
//                   // باقي البيانات...
//                   Text(lesson.title),
//                   // استخدم الـ Tags مع الترجمة
//                   CourseTag(text: "${lesson.duration} min"), 
//                 ],
//               ),
//             );
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }