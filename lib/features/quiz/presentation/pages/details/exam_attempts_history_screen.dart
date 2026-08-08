// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:project1/config/theme/app_colors.dart';
// import 'package:project1/config/theme/app_text_styles.dart';
// import 'package:project1/config/theme/snackbar_theme.dart';
// import 'package:project1/core/di/service_locator.dart';
// import 'package:project1/features/quiz/data/models/exam_attempt_model.dart';
// import 'package:project1/features/quiz/presentation/cubit/exam_attempts_history_cubit.dart';
// import 'package:project1/features/quiz/presentation/cubit/exam_attempts_history_state.dart';
// import 'package:project1/features/quiz/presentation/widgets/details/exam_attempt_history_card.dart';

// class ExamAttemptsHistoryScreen extends StatefulWidget {
//   const ExamAttemptsHistoryScreen({super.key});

//   @override
//   State<ExamAttemptsHistoryScreen> createState() =>
//       _ExamAttemptsHistoryScreenState();
// }

// class _ExamAttemptsHistoryScreenState extends State<ExamAttemptsHistoryScreen> {
//   late final ExamAttemptsHistoryCubit _cubit;
//   final _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _cubit = getIt<ExamAttemptsHistoryCubit>();
//     _cubit.fetchAttempts();
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       _cubit.loadMore();
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _cubit.close();
//     super.dispose();
//   }

//   Future<void> _confirmDelete(ExamAttemptModel attempt) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: const Text('Delete attempt'),
//           content: const Text('Are you sure you want to delete this attempt?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext, false),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext, true),
//               child: Text('Delete', style: TextStyle(color: Colors.red.shade400)),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirm != true || !mounted) return;

//     final success = await _cubit.deleteAttempt(attemptId: attempt.id);

//     if (!mounted) return;

//     if (!success) {
//       SnackbarTheme().newSnackBarError(context, 'Failed to delete attempt');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _cubit,
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: const Text(
//             'My attempts',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
//           ),
//         ),
//         body: SafeArea(
//           child: BlocBuilder<ExamAttemptsHistoryCubit, ExamAttemptsHistoryState>(
//             builder: (context, state) {
//               if (state is ExamAttemptsHistoryLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (state is ExamAttemptsHistoryError) {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Text(
//                       state.message,
//                       textAlign: TextAlign.center,
//                       style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
//                     ),
//                   ),
//                 );
//               }

//               if (state is ExamAttemptsHistoryLoaded) {
//                 return ListView(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//                   children: [
//                     if (state.attempts.isEmpty)
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 40),
//                           child: Text(
//                             'No attempts yet',
//                             style: AppTextStyles.bodyMedium.copyWith(
//                               color: AppColors.textSecondary.withOpacity(.7),
//                             ),
//                           ),
//                         ),
//                       )
//                     else
//                       ...[
//                         for (final attempt in state.attempts)
//                           ExamAttemptHistoryCard(
//                             attempt: attempt,
//                             onDelete: () => _confirmDelete(attempt),
//                           ),
//                         if (state.hasNextPage)
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             child: Center(
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             ),
//                           ),
//                       ],
//                   ],
//                 );
//               }

//               return const SizedBox.shrink();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }