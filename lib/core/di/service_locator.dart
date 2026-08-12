import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/notifications/data/data_sources/device_info_data_source.dart';
import 'package:project1/features/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:project1/features/notifications/domain/repository/notification_repository.dart';
import 'package:project1/features/notifications/data/repository/notification_repository_impl.dart';
import 'package:project1/features/notifications/domain/use_case/register_fcm_token_usecase.dart';
import 'package:project1/features/notifications/presentation/services/notification_service.dart';
import 'package:project1/features/demo/data/data_sources/inquery_data_source.dart';
import 'package:project1/features/demo/data/repository/inquiry_repository_impl.dart';
import 'package:project1/features/demo/domain/repository/inquiry_repository.dart';
import 'package:project1/features/demo/presentation/cubit/inquiry%20cubit/inquiry_cubit.dart';
import 'package:project1/features/attachment/data/data_sources/lesson_attachment_remote_data_source.dart';
import 'package:project1/features/attachment/data/repository/lesson_attachment_repository_impl.dart';
import 'package:project1/features/attachment/domain/repository/lesson_attachment_repository.dart';
import 'package:project1/features/attachment/domain/use_case/create_attachment_usecase.dart';
import 'package:project1/features/attachment/domain/use_case/delete_attachment_usecase.dart';
import 'package:project1/features/attachment/domain/use_case/get_attachments_usecase.dart';
import 'package:project1/features/attachment/domain/use_case/update_attachment_usecase.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
import 'package:project1/features/attachment/upload/data/data_sources/attachment_upload_remote_data_source.dart';
import 'package:project1/features/attachment/upload/data/repository/attachment_upload_repository_impl.dart';
import 'package:project1/features/attachment/upload/domain/repository/attachment_upload_repository.dart';
import 'package:project1/features/attachment/upload/domain/use_case/generate_attachment_upload_url_usecase.dart';
import 'package:project1/features/attachment/upload/domain/use_case/upload_attachment_file_usecase.dart';
import 'package:project1/features/attachment/upload/presentation/cubit/attachment_upload_cubit.dart';
import 'package:project1/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:project1/features/auth/data/repository/auth_repository_impl.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';
import 'package:project1/features/auth/domain/use_case/change_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/forgot_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/generate2FA_usecase.dart';
import 'package:project1/features/auth/domain/use_case/get_me_usecase.dart';
import 'package:project1/features/auth/domain/use_case/google_login_usecase.dart';
import 'package:project1/features/auth/domain/use_case/register_usecase.dart';
import 'package:project1/features/auth/domain/use_case/login_usecase.dart';
import 'package:project1/features/auth/domain/use_case/logout_usecase.dart';
import 'package:project1/features/auth/domain/use_case/resend_verification_email_usecase.dart';
import 'package:project1/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/turnOff2FA_usecase.dart';
import 'package:project1/features/auth/domain/use_case/turnOn2FA_usecase.dart';
import 'package:project1/features/auth/domain/use_case/verify2FA_usecase.dart';
import 'package:project1/features/auth/domain/use_case/verify_email_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/upload_photo/data/data_sources/upload_photo_remote_datasource.dart';
import 'package:project1/features/auth/upload_photo/data/repository/upload_photo_repository_impl.dart';
import 'package:project1/features/auth/upload_photo/domain/repository/upload_photo_repository.dart';
import 'package:project1/features/auth/upload_photo/domain/use_case/upload_photo_usecase.dart';
import 'package:project1/features/course/data/data_sources/course_remote_datasource.dart';
import 'package:project1/features/course/data/data_sources/department_course_remote_data_source.dart';
import 'package:project1/features/course/data/repository/course_repository_impl.dart';
import 'package:project1/features/course/data/repository/department_course_repository_impl.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';
import 'package:project1/features/course/domain/repository/department_course_repository.dart';
import 'package:project1/features/course/domain/use_case/confirm_payment_usecase.dart';
import 'package:project1/features/course/domain/use_case/create_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/create_department_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/delete_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/delete_department_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_courses_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_demo_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_demo_courses_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_department_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_department_courses_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_tags_usecase.dart';
import 'package:project1/features/course/domain/use_case/publish_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/update_course_usecase.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/department_course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/tags_cubit.dart';
import 'package:project1/features/course/upload_photo/data/data_sources/upload_photo_course_remote_datasource.dart';
import 'package:project1/features/course/upload_photo/data/repository/upload_photo_course_repositpry_impl.dart';
import 'package:project1/features/course/upload_photo/domain/repository/upload_photo_course_repository.dart';
import 'package:project1/features/course/upload_photo/domain/use_case/upload_photo_course_usecase.dart';
import 'package:project1/features/course/upload_photo/presentation/cubit/upload_photo_course_cubit.dart';
import 'package:project1/features/demo/data/data_sources/data_payment_data_source.dart';
import 'package:project1/features/demo/data/data_sources/demo_remote_data_source.dart';
import 'package:project1/features/demo/data/data_sources/demo_users_remote_data_source.dart';
import 'package:project1/features/demo/domain/repository/demo_repository.dart';
import 'package:project1/features/demo/data/repository/demo_repository_impl.dart';
import 'package:project1/features/demo/data/repository/demo_user_repository_impl.dart';
import 'package:project1/features/demo/data/repository/payment%20repo/demo_payment_repository_impl.dart';
import 'package:project1/features/demo/domain/repository/demo_payment_repository.dart';
import 'package:project1/features/demo/domain/repository/demo_users_repository.dart';
import 'package:project1/features/demo/domain/use%20case/demo_payment_usecase.dart';
import 'package:project1/features/demo/domain/use%20case/demo_users_usecase.dart';
import 'package:project1/features/demo/domain/use%20case/demos_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/features/department/presentation/cubit/department%20cubit/department_cubit.dart';
import 'package:project1/features/department/data/data_sources/department_data_source.dart';
import 'package:project1/features/department/domain/repository/department_repository.dart';
import 'package:project1/features/department/data/repository/department_repository_implement.dart';
import 'package:project1/features/department/domain/use_case/get_department_use_case.dart';
import 'package:project1/features/department/data/data_sources/roadmap_datasource.dart';
import 'package:project1/features/department/data/repository/roadmap_repository_implement.dart';
import 'package:project1/features/department/domain/repository/roadmap_repository.dart';
import 'package:project1/features/department/domain/use_case/roadmap_usecase.dart';
import 'package:project1/features/department/presentation/cubit/roadmap_cubit/roadmap_cubit.dart';
import 'package:project1/features/live_stream/data/data_sources/live_stream_remote_data_source.dart';
import 'package:project1/features/live_stream/data/repository/live_stream_repository_impl.dart';
import 'package:project1/features/live_stream/domain/repository/live_stream_repository.dart';
import 'package:project1/features/live_stream/domain/use_cases/create_live_stream_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/end_live_stream_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/get_live_stream_details_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/get_live_stream_token_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/get_live_streams_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/start_live_stream_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/update_live_stream_usecase.dart';
import 'package:project1/features/live_stream/presentation/cubit/live_stream_cubit.dart';
import 'package:project1/features/department/data/data_sources/department_member_datasource.dart';
import 'package:project1/features/department/data/repository/department_member_repo_impl.dart';
import 'package:project1/features/department/domain/repository/department_member_repository.dart';
import 'package:project1/features/department/presentation/cubit/department%20members%20cubit/department_member_cubit.dart';
import 'package:project1/features/faq/data/data_sources/course_faq_remote_data_source.dart';
import 'package:project1/features/faq/data/repository/course_faq_repository_impl.dart';
import 'package:project1/features/faq/domain/repository/course_faq_repository.dart';
import 'package:project1/features/faq/domain/use_case/create_course_faq_usecase.dart';
import 'package:project1/features/faq/domain/use_case/delete_course_faq_usecase.dart';
import 'package:project1/features/faq/domain/use_case/get_course_faq_usecase.dart';
import 'package:project1/features/faq/domain/use_case/get_course_faqs_usecase.dart';
import 'package:project1/features/faq/presentation/cubit/course_faq_cubit.dart';
import 'package:project1/features/lesson/data/data_sources/lesson_remote_datasource.dart';
import 'package:project1/features/lesson/data/repository/lesson_repository_impl.dart';
import 'package:project1/features/lesson/domain/repository/lesson_repository.dart';
import 'package:project1/features/lesson/domain/use_case/create_lesson_usecase.dart';
import 'package:project1/features/lesson/domain/use_case/delete_lesson_usecase.dart';
import 'package:project1/features/lesson/domain/use_case/get_lesson_usecase.dart';
import 'package:project1/features/lesson/domain/use_case/get_lessons_usecase.dart';
import 'package:project1/features/lesson/domain/use_case/update_lesson_usecase.dart';
import 'package:project1/features/lesson/presentation/cubit/lesson_cubit.dart';
import 'package:project1/features/lesson/upload_video/data/data_sources/lesson_video_upload_remote_datasource.dart';
import 'package:project1/features/lesson/upload_video/data/repository/lesson_video_upload_repository_impl.dart';
import 'package:project1/features/lesson/upload_video/domain/repository/lesson_video_upload_repository.dart';
import 'package:project1/features/lesson/upload_video/domain/use_case/generate_video_upload_url_usecase.dart';
import 'package:project1/features/lesson/upload_video/domain/use_case/upload_video_file_usecase.dart';
import 'package:project1/features/lesson/upload_video/presentation/cubit/lesson_video_upload_cubit.dart';
import 'package:project1/features/course/data/data_sources/payment_remote_data_source.dart';
import 'package:project1/features/course/data/repository/payment_repository_impl.dart';
import 'package:project1/features/course/domain/repository/payment_repository.dart';
import 'package:project1/features/course/domain/use_case/checkout_course_usecase.dart';
import 'package:project1/features/course/presentation/cubit/payment_cubit.dart';
import 'package:project1/features/profile/data/data_sources/profile_remote_datasource.dart';
import 'package:project1/features/profile/data/repository/profile_repository_impl.dart';
import 'package:project1/features/profile/domain/repository/profile_repository.dart';
import 'package:project1/features/profile/domain/use_case/update_profile_image_usecase.dart';
import 'package:project1/features/q&a/data/data_sources/discussion_remote_data_source.dart';
import 'package:project1/features/q&a/data/repositories/discussion_repository_impl.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';
import 'package:project1/features/q&a/domain/use_case/create_discussion_answer_usecase.dart';
import 'package:project1/features/q&a/domain/use_case/create_discussion_question_usecase.dart';
import 'package:project1/features/q&a/domain/use_case/delete_discussion_answer_usecase.dart';
import 'package:project1/features/q&a/domain/use_case/delete_discussion_question_usecase.dart';
import 'package:project1/features/q&a/domain/use_case/get_discussion_answers_usecase.dart';
import 'package:project1/features/q&a/domain/use_case/get_discussion_questions_usecase.dart';
import 'package:project1/features/q&a/domain/use_case/update_discussion_answer_usecase.dart';
import 'package:project1/features/q&a/domain/use_case/update_discussion_question_usecase.dart';
import 'package:project1/features/q&a/presentation/cubit/discussion_cubit.dart';
import 'package:project1/features/questions_bank/data/data_sources/question_bank_remote_data_source.dart';
import 'package:project1/features/questions_bank/data/repository/question_bank_repository_impl.dart';
import 'package:project1/features/questions_bank/domain/repository/question_bank_repository.dart';
import 'package:project1/features/questions_bank/domain/use_case/create_question_bank_usecase.dart';
import 'package:project1/features/questions_bank/domain/use_case/delete_question_bank_usecase.dart';
import 'package:project1/features/questions_bank/domain/use_case/get_question_bank_usecase.dart';
import 'package:project1/features/questions_bank/domain/use_case/get_question_banks_usecase.dart';
import 'package:project1/features/questions_bank/presentation/cubit/question_bank_cubit.dart';
import 'package:project1/features/quiz/data/data_sources/exam_attempt_remote_data_source.dart';
import 'package:project1/features/quiz/data/data_sources/exam_remote_data_source.dart';
import 'package:project1/features/quiz/data/repositories/exam_attempt_repository_impl.dart';
import 'package:project1/features/quiz/data/repositories/exam_repository_impl.dart';
import 'package:project1/features/quiz/domain/repositories/exam_attempt_repository.dart';
import 'package:project1/features/quiz/domain/repositories/exam_repository.dart';
import 'package:project1/features/quiz/domain/use_case/create_exam_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/delete_exam_attempt_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/delete_exam_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/generate_exam_attempt_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/get_exam_attempt_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/get_exam_attempts_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/get_exams_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/submit_exam_attempt_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/update_exam_usecase.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_attempts_history_cubit.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_cubit.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_taking_cubit.dart';
import 'package:project1/features/rag/data/data_sources/rag_remote_data_source.dart';
import 'package:project1/features/rag/data/repositories/rag_repository_impl.dart';
import 'package:project1/features/rag/domain/repositories/rag_repository.dart';
import 'package:project1/features/rag/domain/use_case/ask_question_usecase.dart';
import 'package:project1/features/rag/domain/use_case/generate_random_quiz_usecase.dart';
import 'package:project1/features/rag/domain/use_case/generate_topic_quiz_usecase.dart';
import 'package:project1/features/rag/presentation/cubit/rag_cubit.dart';
import 'package:project1/features/section/data/data_sources/section_remote_datasource.dart';
import 'package:project1/features/section/data/repository/section_repository_impl.dart';
import 'package:project1/features/section/domain/repository/section_repository.dart';
import 'package:project1/features/section/domain/use_case/create_section_usecase.dart';
import 'package:project1/features/section/domain/use_case/delete_section_usecase.dart';
import 'package:project1/features/section/domain/use_case/get_section_usecase.dart';
import 'package:project1/features/section/domain/use_case/get_sections_usecase.dart';
import 'package:project1/features/section/domain/use_case/update_section_usecase.dart';
import 'package:project1/features/section/presentation/cubit/section_cubit.dart';
import 'package:project1/features/department_chat/data/data_sources/department_chat_remote_datasource.dart';
import 'package:project1/features/department_chat/data/data_sources/department_chat_socket_datasource.dart';
import 'package:project1/features/department_chat/data/repository/department_chat_repository_impl.dart';
import 'package:project1/features/department_chat/domain/repository/department_chat_repository.dart';
import 'package:project1/features/department_chat/domain/use_case/connect_department_chat_usecase.dart';
import 'package:project1/features/department_chat/domain/use_case/delete_department_message_usecase.dart';
import 'package:project1/features/department_chat/domain/use_case/disconnect_department_chat_usecase.dart';
import 'package:project1/features/department_chat/domain/use_case/edit_department_message_usecase.dart';
import 'package:project1/features/department_chat/domain/use_case/get_message_history_usecase.dart';
import 'package:project1/features/department_chat/domain/use_case/send_department_message_usecase.dart';
import 'package:project1/features/department_chat/domain/use_case/set_typing_status_usecase.dart';
import 'package:project1/features/department_chat/presentation/cubit/department_chat_cubit.dart';

final getIt = GetIt.instance;
final sl = getIt;

final String baseUrl = dotenv.env['BASE_URL'] ?? '';

void setupDI() {
  ////////////////////////storage////////////////////////
  getIt.registerLazySingleton<AppSecureStorage>(() => AppSecureStorage());
  ////////////////////////storage////////////////////////

  ////////////////////////Dio+refresh////////////////////////
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      storage: getIt<AppSecureStorage>(),
      refreshToken: () async {
        final storage = getIt<AppSecureStorage>();
        final refresh = await storage.read(StorageKeys.refreshToken);
        if (refresh == null) return null;
        final dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {'Accept': 'application/json'},
          ),
        );
        final res = await dio.post(
          '/authentication/refresh-tokens',
          data: {"refreshToken": refresh},
        );
        return res.data['data'];
      },
    ),
  );
  ////////////////////////Dio+refresh////////////////////////

  ////////////////////////auth+user////////////////////////

  //datasource
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>()),
  );

  //repo
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AppSecureStorage>(),
    ),
  );

  //remote
  getIt.registerLazySingleton<UploadPhotoRemoteDataSource>(
    () => UploadPhotoRemoteDataSource(getIt<DioClient>()),
  );

  //repo
  getIt.registerLazySingleton<UploadPhotoRepository>(
    () => UploadPhotoRepositoryImpl(getIt<UploadPhotoRemoteDataSource>()),
  );

  // getIt.registerLazySingleton<AuthTokenManager>(
  //   () => AuthTokenManager(getIt<AppSecureStorage>()),
  // );

  //usecase
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => VerifyEmailUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => ForgotPasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => ResetPasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => ChangePasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => GoogleLoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => ResendVerificationEmailUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetMeUseCase>(
    () => GetMeUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<UploadPhotoUseCase>(
    () => UploadPhotoUseCase(getIt<UploadPhotoRepository>()),
  );
  getIt.registerLazySingleton(() => Verify2FAUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => Generate2FAUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(() => TurnOn2FAUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => TurnOff2FAUseCase(getIt<AuthRepository>()));

  //cubit
  getIt.registerLazySingleton(
    () => UserCubit(
      getMeUseCase: getIt<GetMeUseCase>(),
      updateProfileImageUseCase: getIt<UpdateProfileImageUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => AuthCubit(
      registerUseCase: getIt<RegisterUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      verifyEmailUseCase: getIt<VerifyEmailUseCase>(),
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
      googleLoginUseCase: getIt<GoogleLoginUseCase>(),
      resendVerificationEmailUseCase: getIt<ResendVerificationEmailUseCase>(),
      userCubit: getIt<UserCubit>(),
      uploadPhotoUseCase: getIt<UploadPhotoUseCase>(),
      verify2FAUseCase: getIt<Verify2FAUseCase>(),
      generate2FAUseCase: getIt<Generate2FAUseCase>(),
      turnOn2FAUseCase: getIt<TurnOn2FAUseCase>(),
      turnOff2FAUseCase: getIt<TurnOff2FAUseCase>(),
    ),
  );

  //remote
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(getIt<DioClient>()),
  );

  //repo
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );

  //repo
  getIt.registerLazySingleton(
    () => UpdateProfileImageUseCase(getIt<ProfileRepository>()),
  );
  ////////////////////////auth+user////////////////////////

  ////////////////////////Demo////////////////////////

  //datasource
  getIt.registerLazySingleton<DemoRemoteDataSource>(
    () => DemoRemoteDataSourceImpl(
      getIt<DioClient>(),
      dio: getIt<DioClient>().dio,
    ),
  );

  //repo
  getIt.registerLazySingleton<DemoRepository>(
    () => DemoRepositoryImpl(
      getIt<DioClient>(),
      remoteDataSource: getIt<DemoRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<DemoPaymentDataSource>(
    () => DemoPaymentDataSourceImpl(
      getIt<DioClient>(),
      dio: getIt<DioClient>().dio,
    ),
  );

  getIt.registerLazySingleton<GetDemosUseCase>(
    () => GetDemosUseCase(getIt<DemoRepository>()),
  );
  getIt.registerFactory(
    () => DemoCubit(
      getDemosUseCase: getIt<GetDemosUseCase>(),
      uploadPhotoUseCase: getIt<UploadPhotoUseCase>(),
    ),
  );

  getIt.registerLazySingleton<DemoPaymentRepository>(
    () => DemoPaymentRepositoryImpl(
      demoPaymentDataSource: getIt<DemoPaymentDataSource>(),
    ),
  );

  getIt.registerLazySingleton<DemoUsersRemoteDataSource>(
    () => DemoUsersRemoteDataSourceImpl(dio: getIt<DioClient>().dio),
  );

  getIt.registerLazySingleton<DemoUsersRepository>(
    () => DemoUserRepositoryImpl(
      remoteDataSource: getIt<DemoUsersRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<DemoUsersUsecase>(
    () => DemoUsersUsecase(repository: getIt<DemoUsersRepository>()),
  );

  getIt.registerFactory<DemoUserCubit>(
    () => DemoUserCubit(getUsersUseCase: getIt<DemoUsersUsecase>()),
  );

  getIt.registerLazySingleton(
    () => DemoPaymentUseCase(getIt<DemoPaymentRepository>()),
  );

  ////////////////////////Demo////////////////////////

  ///////////////////// department ////////////////

  getIt.registerLazySingleton<DepartmentRemoteDataSource>(
    () => DepartmentRemoteDataSourcImpl(
      getIt<DioClient>(),
      dio: getIt<DioClient>().dio,
    ),
  );

  getIt.registerLazySingleton<DepartmentRepository>(
    () => DepartmentRepositoryImplement(
      getIt<DioClient>(),
      remoteDataSource: getIt<DepartmentRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetDepartmentUseCase>(
    () => GetDepartmentUseCase(repository: getIt<DepartmentRepository>()),
  );

  getIt.registerFactory<DepartmentCubit>(
    () => DepartmentCubit(getIt<GetDepartmentUseCase>()),
  );

  // Department Member
  getIt.registerLazySingleton<DepartmentMemberDataSource>(
    () => DepartmentMemberDataSourceImpl(
      getIt<DioClient>(),
      dio: getIt<DioClient>().dio,
    ),
  );

  getIt.registerLazySingleton<DepartmentMemberRepository>(
    () => DepartmentMemberRepositoryImpl(
      dataSource: getIt<DepartmentMemberDataSource>(),
    ),
  );

  getIt.registerFactory<DepartmentMemberCubit>(
    () => DepartmentMemberCubit(getIt<DepartmentMemberRepository>()),
  );

  // Roadmap
  getIt.registerLazySingleton<RoadmapRemoteDataSource>(
    () => RoadmapRemoteDataSourceImpl(
      getIt<DioClient>(),
      dio: getIt<DioClient>().dio,
    ),
  );

  getIt.registerLazySingleton<RoadmapRepository>(
    () => RoadmapRepositoryImpl(
      remoteDataSource: getIt<RoadmapRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<RoadmapUseCase>(
    () => RoadmapUseCase(roadmapRepository: getIt<RoadmapRepository>()),
  );

  getIt.registerFactory<RoadmapCubit>(
    () => RoadmapCubit(getIt<RoadmapUseCase>()),
  );


  //////////////// department //////////////////////////

  //////////////////////// Course ////////////////////////

  // datasource
  getIt.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<UploadPhotoCourseRemoteDataSource>(
    () => UploadPhotoCourseRemoteDataSource(getIt<DioClient>()),
  );

  // repository
  getIt.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(getIt<CourseRemoteDataSource>()),
  );
  getIt.registerLazySingleton<UploadPhotoCourseRepository>(
    () => UploadPhotoCourseRepositoryImpl(
      getIt<UploadPhotoCourseRemoteDataSource>(),
    ),
  );

  // usecases
  getIt.registerLazySingleton<UploadPhotoCourseUseCase>(
    () => UploadPhotoCourseUseCase(getIt<UploadPhotoCourseRepository>()),
  );
  getIt.registerLazySingleton<GetTagsUseCase>(
    () => GetTagsUseCase(getIt<CourseRepository>()),
  );
  getIt.registerLazySingleton<CreateCourseUseCase>(
    () => CreateCourseUseCase(getIt<CourseRepository>()),
  );
  getIt.registerLazySingleton<GetDemoCoursesUseCase>(
    () => GetDemoCoursesUseCase(getIt<CourseRepository>()),
  );
  getIt.registerLazySingleton<UpdateCourseUseCase>(
    () => UpdateCourseUseCase(getIt<CourseRepository>()),
  );
  getIt.registerLazySingleton(() => DeleteCourseUseCase(getIt()));
  getIt.registerLazySingleton(() => PublishCourseUseCase(getIt()));
  getIt.registerLazySingleton<GetCourseUseCase>(
    () => GetCourseUseCase(getIt<CourseRepository>()),
  );
  getIt.registerLazySingleton<GetCoursesUseCase>(
    () => GetCoursesUseCase(getIt<CourseRepository>()),
  );
  getIt.registerLazySingleton<GetDemoCourseUseCase>(
    () => GetDemoCourseUseCase(getIt<CourseRepository>()),
  );

  // cubit
  getIt.registerFactory<UploadPhotoCourseCubit>(
    () => UploadPhotoCourseCubit(getIt<UploadPhotoCourseUseCase>()),
  );
  getIt.registerFactory<TagsCubit>(
    () => TagsCubit(getTagsUseCase: getIt<GetTagsUseCase>()),
  );
  getIt.registerFactory<CourseCubit>(
    () => CourseCubit(
      createCourseUseCase: getIt<CreateCourseUseCase>(),
      getCourseUseCase: getIt<GetCourseUseCase>(),
      getCoursesUseCase: getIt<GetCoursesUseCase>(),
      getDemoCoursesUseCase: getIt<GetDemoCoursesUseCase>(),
      getDemoCourseUseCase: getIt<GetDemoCourseUseCase>(),
      updateCourseUseCase: getIt<UpdateCourseUseCase>(),
      publishCourseUseCase: getIt<PublishCourseUseCase>(),
      deleteCourseUseCase: getIt<DeleteCourseUseCase>(),
    ),
  );

  //////////////////////// Course ////////////////////////

  //////////////////////// Section ////////////////////////

  // datasource
  getIt.registerLazySingleton<SectionRemoteDataSource>(
    () => SectionRemoteDataSource(getIt<DioClient>()),
  );

  // repository
  getIt.registerLazySingleton<SectionRepository>(
    () => SectionRepositoryImpl(getIt<SectionRemoteDataSource>()),
  );

  // usecases
  getIt.registerLazySingleton<CreateSectionUseCase>(
    () => CreateSectionUseCase(getIt<SectionRepository>()),
  );

  getIt.registerLazySingleton<GetSectionUseCase>(
    () => GetSectionUseCase(getIt<SectionRepository>()),
  );

  getIt.registerLazySingleton<UpdateSectionUseCase>(
    () => UpdateSectionUseCase(getIt<SectionRepository>()),
  );

  getIt.registerLazySingleton<DeleteSectionUseCase>(
    () => DeleteSectionUseCase(getIt<SectionRepository>()),
  );

  getIt.registerLazySingleton<GetSectionsUseCase>(
    () => GetSectionsUseCase(getIt<SectionRepository>()),
  );

  // cubit
  getIt.registerFactory<SectionCubit>(
    () => SectionCubit(
      createSectionUseCase: getIt<CreateSectionUseCase>(),
      getSectionUseCase: getIt<GetSectionUseCase>(),
      updateSectionUseCase: getIt<UpdateSectionUseCase>(),
      deleteSectionUseCase: getIt<DeleteSectionUseCase>(),
      getSectionsUseCase: getIt(),
    ),
  );

  //////////////////////// Section ////////////////////////

  //////////////////////// Lesson ////////////////////////

  // datasource
  getIt.registerLazySingleton<LessonVideoUploadRemoteDataSource>(
    () => LessonVideoUploadRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<LessonRemoteDataSource>(
    () => LessonRemoteDataSource(getIt()),
  );

  // repository
  getIt.registerLazySingleton<LessonVideoUploadRepository>(
    () => LessonVideoUploadRepositoryImpl(
      getIt<LessonVideoUploadRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<LessonRepository>(
    () => LessonRepositoryImpl(getIt()),
  );

  // usecases
  getIt.registerLazySingleton<GenerateVideoUploadUrlUseCase>(
    () => GenerateVideoUploadUrlUseCase(getIt<LessonVideoUploadRepository>()),
  );

  getIt.registerLazySingleton<UploadVideoFileUseCase>(
    () => UploadVideoFileUseCase(getIt<LessonVideoUploadRepository>()),
  );

  getIt.registerLazySingleton<CreateLessonUseCase>(
    () => CreateLessonUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetLessonUseCase>(
    () => GetLessonUseCase(getIt<LessonRepository>()),
  );

  getIt.registerLazySingleton<GetLessonsUseCase>(
    () => GetLessonsUseCase(getIt<LessonRepository>()),
  );

  getIt.registerLazySingleton<UpdateLessonUseCase>(
    () => UpdateLessonUseCase(getIt<LessonRepository>()),
  );

  getIt.registerLazySingleton<DeleteLessonUseCase>(
    () => DeleteLessonUseCase(getIt<LessonRepository>()),
  );

  // cubit
  getIt.registerFactory<LessonVideoUploadCubit>(
    () => LessonVideoUploadCubit(
      generateVideoUploadUrlUseCase: getIt<GenerateVideoUploadUrlUseCase>(),
      uploadVideoFileUseCase: getIt<UploadVideoFileUseCase>(),
    ),
  );
  getIt.registerFactory<LessonCubit>(
    () => LessonCubit(
      createLessonUseCase: getIt<CreateLessonUseCase>(),
      getLessonUseCase: getIt<GetLessonUseCase>(),
      getLessonsUseCase: getIt<GetLessonsUseCase>(),
      updateLessonUseCase: getIt<UpdateLessonUseCase>(),
      deleteLessonUseCase: getIt<DeleteLessonUseCase>(),
    ),
  );

  //////////////////////// Lesson ////////////////////////

  //////////////////////// Attachment ////////////////////////

  //Data Sources
  getIt.registerLazySingleton<LessonAttachmentRemoteDataSource>(
    () => LessonAttachmentRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AttachmentUploadRemoteDataSource>(
    () => AttachmentUploadRemoteDataSource(getIt<DioClient>()),
  );

  //Repositories
  getIt.registerLazySingleton<LessonAttachmentRepository>(
    () => LessonAttachmentRepositoryImpl(
      getIt<LessonAttachmentRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<AttachmentUploadRepository>(
    () => AttachmentUploadRepositoryImpl(
      getIt<AttachmentUploadRemoteDataSource>(),
      getIt<DioClient>(),
    ),
  );

  //Use Cases
  getIt.registerLazySingleton<GetAttachmentsUseCase>(
    () => GetAttachmentsUseCase(getIt<LessonAttachmentRepository>()),
  );
  getIt.registerLazySingleton<UpdateAttachmentUseCase>(
    () => UpdateAttachmentUseCase(getIt<LessonAttachmentRepository>()),
  );
  getIt.registerLazySingleton<DeleteAttachmentUseCase>(
    () => DeleteAttachmentUseCase(getIt<LessonAttachmentRepository>()),
  );
  getIt.registerLazySingleton<CreateAttachmentUseCase>(
    () => CreateAttachmentUseCase(getIt<LessonAttachmentRepository>()),
  );
  getIt.registerLazySingleton<GenerateAttachmentUploadUrlUseCase>(
    () =>
        GenerateAttachmentUploadUrlUseCase(getIt<AttachmentUploadRepository>()),
  );
  getIt.registerLazySingleton<UploadAttachmentFileUseCase>(
    () => UploadAttachmentFileUseCase(getIt<AttachmentUploadRepository>()),
  );

  //Cubits
  getIt.registerFactory<LessonAttachmentCubit>(
    () => LessonAttachmentCubit(
      getAttachmentsUseCase: getIt<GetAttachmentsUseCase>(),
      updateAttachmentUseCase: getIt<UpdateAttachmentUseCase>(),
      deleteAttachmentUseCase: getIt<DeleteAttachmentUseCase>(),
    ),
  );
  getIt.registerFactory<AttachmentUploadCubit>(
    () => AttachmentUploadCubit(
      generateUploadUrlUseCase: getIt<GenerateAttachmentUploadUrlUseCase>(),
      uploadFileUseCase: getIt<UploadAttachmentFileUseCase>(),
      createAttachmentUseCase: getIt<CreateAttachmentUseCase>(),
    ),
  );

  //////////////////////// Attachment ////////////////////////

  //////////////////////// Course FAQ ////////////////////////

  //Data Sources
  getIt.registerLazySingleton<CourseFaqRemoteDataSource>(
    () => CourseFaqRemoteDataSource(getIt<DioClient>()),
  );

  //Repositories
  getIt.registerLazySingleton<CourseFaqRepository>(
    () => CourseFaqRepositoryImpl(getIt<CourseFaqRemoteDataSource>()),
  );

  //Use Cases
  getIt.registerLazySingleton<GetCourseFaqUseCase>(
    () => GetCourseFaqUseCase(getIt<CourseFaqRepository>()),
  );
  getIt.registerLazySingleton<GetCourseFaqsUseCase>(
    () => GetCourseFaqsUseCase(getIt<CourseFaqRepository>()),
  );
  getIt.registerLazySingleton<CreateCourseFaqUseCase>(
    () => CreateCourseFaqUseCase(getIt<CourseFaqRepository>()),
  );
  getIt.registerLazySingleton<DeleteCourseFaqUseCase>(
    () => DeleteCourseFaqUseCase(getIt<CourseFaqRepository>()),
  );

  //Cubits
  getIt.registerFactory<CourseFaqCubit>(
    () => CourseFaqCubit(
      getCourseFaqsUseCase: getIt<GetCourseFaqsUseCase>(),
      createCourseFaqUseCase: getIt<CreateCourseFaqUseCase>(),
      deleteCourseFaqUseCase: getIt<DeleteCourseFaqUseCase>(),
    ),
  );

  //////////////////////// Course FAQ ////////////////////////
  

  //////////////////////// Department Course ////////////////////////

  //Data Sources
  getIt.registerLazySingleton<DepartmentCourseRemoteDataSource>(
    () => DepartmentCourseRemoteDataSource(getIt<DioClient>()),
  );

  //Repositories
  getIt.registerLazySingleton<DepartmentCourseRepository>(
    () => DepartmentCourseRepositoryImpl(
      getIt<DepartmentCourseRemoteDataSource>(),
    ),
  );

  //Use Cases
  getIt.registerLazySingleton<GetDepartmentCoursesUseCase>(
    () => GetDepartmentCoursesUseCase(getIt<DepartmentCourseRepository>()),
  );
  getIt.registerLazySingleton<GetDepartmentCourseUseCase>(
    () => GetDepartmentCourseUseCase(getIt<DepartmentCourseRepository>()),
  );
  getIt.registerLazySingleton<CreateDepartmentCourseUseCase>(
    () => CreateDepartmentCourseUseCase(getIt<DepartmentCourseRepository>()),
  );
  getIt.registerLazySingleton<DeleteDepartmentCourseUseCase>(
    () => DeleteDepartmentCourseUseCase(getIt<DepartmentCourseRepository>()),
  );

  //Cubits
  getIt.registerFactory<DepartmentCourseCubit>(
    () => DepartmentCourseCubit(
      getDepartmentCoursesUseCase: getIt<GetDepartmentCoursesUseCase>(),
      createDepartmentCourseUseCase: getIt<CreateDepartmentCourseUseCase>(),
      deleteDepartmentCourseUseCase: getIt<DeleteDepartmentCourseUseCase>(),
    ),
  );

  //////////////////////// Department Course ////////////////////////

  //////////////////////// Payment Course ////////////////////////

  //Data Sources
  getIt.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSource(getIt<DioClient>()),
  );

  //Repositories
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(getIt<PaymentRemoteDataSource>()),
  );

  //Use Cases
  getIt.registerLazySingleton<CheckoutCourseUseCase>(
    () => CheckoutCourseUseCase(getIt<PaymentRepository>()),
  );
  getIt.registerLazySingleton<ConfirmPaymentUseCase>(
    () => ConfirmPaymentUseCase(getIt<PaymentRepository>()),
  );

  //Cubits
  getIt.registerFactory<PaymentCubit>(
    () => PaymentCubit(
      checkoutCourseUseCase: getIt<CheckoutCourseUseCase>(),
      confirmPaymentUseCase: getIt<ConfirmPaymentUseCase>(),
    ),
  );

  //////////////////////// Payment Course ////////////////////////
  

  //////////////////////// Rag ////////////////////////
  // Data Source
getIt.registerLazySingleton<RagRemoteDataSource>(
  () => RagRemoteDataSource(getIt<DioClient>()),
);

// Repository
getIt.registerLazySingleton<RagRepository>(
  () => RagRepositoryImpl(getIt<RagRemoteDataSource>()),
);

// Use Cases
getIt.registerLazySingleton<AskQuestionUseCase>(
  () => AskQuestionUseCase(getIt<RagRepository>()),
);
getIt.registerLazySingleton<GenerateTopicQuizUseCase>(
  () => GenerateTopicQuizUseCase(getIt<RagRepository>()),
);
getIt.registerLazySingleton<GenerateRandomQuizUseCase>(
  () => GenerateRandomQuizUseCase(getIt<RagRepository>()),
);

// Cubit 
getIt.registerFactory<RagCubit>(
  () => RagCubit(
    askQuestionUseCase: getIt<AskQuestionUseCase>(),
    generateTopicQuizUseCase: getIt<GenerateTopicQuizUseCase>(),
    generateRandomQuizUseCase: getIt<GenerateRandomQuizUseCase>(),
  ),
);
//////////////////////// RAG ////////////////////////

  //////////////////////// Department Chat ////////////////////////
  getIt.registerLazySingleton<DepartmentChatRemoteDataSource>(
    () => DepartmentChatRemoteDataSourceImpl(
      getIt<DioClient>(),
      dio: getIt<DioClient>().dio,
    ),
  );
  getIt.registerLazySingleton<DepartmentChatSocketDataSource>(
    () => DepartmentChatSocketDataSourceImpl(),
  );

  getIt.registerLazySingleton<DepartmentChatRepository>(
    () => DepartmentChatRepositoryImpl(
      remoteDataSource: getIt<DepartmentChatRemoteDataSource>(),
      socketDataSource: getIt<DepartmentChatSocketDataSource>(),
      storage: getIt<AppSecureStorage>(),
    ),
  );

  getIt.registerLazySingleton<GetMessageHistoryUseCase>(
    () => GetMessageHistoryUseCase(getIt<DepartmentChatRepository>()),
  );
  getIt.registerLazySingleton<ConnectDepartmentChatUseCase>(
    () => ConnectDepartmentChatUseCase(getIt<DepartmentChatRepository>()),
  );
  getIt.registerLazySingleton<DisconnectDepartmentChatUseCase>(
    () => DisconnectDepartmentChatUseCase(getIt<DepartmentChatRepository>()),
  );
  getIt.registerLazySingleton<SendDepartmentMessageUseCase>(
    () => SendDepartmentMessageUseCase(getIt<DepartmentChatRepository>()),
  );
  getIt.registerLazySingleton<EditDepartmentMessageUseCase>(
    () => EditDepartmentMessageUseCase(getIt<DepartmentChatRepository>()),
  );
  getIt.registerLazySingleton<DeleteDepartmentMessageUseCase>(
    () => DeleteDepartmentMessageUseCase(getIt<DepartmentChatRepository>()),
  );
  getIt.registerLazySingleton<SetTypingStatusUseCase>(
    () => SetTypingStatusUseCase(getIt<DepartmentChatRepository>()),
  );

  getIt.registerFactory<DepartmentChatCubit>(
    () => DepartmentChatCubit(
      getMessageHistoryUseCase: getIt<GetMessageHistoryUseCase>(),
      connectDepartmentChatUseCase: getIt<ConnectDepartmentChatUseCase>(),
      disconnectDepartmentChatUseCase: getIt<DisconnectDepartmentChatUseCase>(),
      sendDepartmentMessageUseCase: getIt<SendDepartmentMessageUseCase>(),
      editDepartmentMessageUseCase: getIt<EditDepartmentMessageUseCase>(),
      deleteDepartmentMessageUseCase: getIt<DeleteDepartmentMessageUseCase>(),
      setTypingStatusUseCase: getIt<SetTypingStatusUseCase>(),
      repository: getIt<DepartmentChatRepository>(),
      getMeUseCase: getIt<GetMeUseCase>(),
      departmentMemberRepository: getIt<DepartmentMemberRepository>(),
    ),
  );
  //////////////////////// Department Chat ////////////////////////

  //////////////////////// Question Bank ////////////////////////

  getIt.registerLazySingleton<QuestionBankRemoteDataSource>(
    () => QuestionBankRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<QuestionBankRepository>(
    () => QuestionBankRepositoryImpl(getIt<QuestionBankRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => CreateQuestionBankUseCase(getIt<QuestionBankRepository>()));
  getIt.registerLazySingleton(() => GetQuestionBanksUseCase(getIt<QuestionBankRepository>()));
  getIt.registerLazySingleton(() => GetQuestionBankUseCase(getIt<QuestionBankRepository>()));
  getIt.registerLazySingleton(() => DeleteQuestionBankUseCase(getIt<QuestionBankRepository>()));

  getIt.registerFactory(
    () => QuestionBankCubit(
      getQuestionBanksUseCase: getIt(),
      createQuestionBankUseCase: getIt(),
      deleteQuestionBankUseCase: getIt(),
    ),
  );
  //////////////////////// Quiz ////////////////////////
  

  getIt.registerLazySingleton<ExamRemoteDataSource>(() => ExamRemoteDataSource(getIt()));

  getIt.registerLazySingleton<ExamRepository>(() => ExamRepositoryImpl(getIt()));

  getIt.registerLazySingleton<CreateExamUseCase>(() => CreateExamUseCase(getIt()));
  getIt.registerLazySingleton<GetExamsUseCase>(() => GetExamsUseCase(getIt()));
  getIt.registerLazySingleton<UpdateExamUseCase>(() => UpdateExamUseCase(getIt()));
  getIt.registerLazySingleton<DeleteExamUseCase>(() => DeleteExamUseCase(getIt()));

  getIt.registerFactory<ExamCubit>(() => ExamCubit(
  getExamsUseCase: getIt(),
  createExamUseCase: getIt(),
  updateExamUseCase: getIt(),
  deleteExamUseCase: getIt(),
));

  //////////////////////// Quiz ////////////////////////
  
  
    //////////////////////// Quiz Attempt ////////////////////////

      getIt.registerLazySingleton<ExamAttemptRemoteDataSource>(
  () => ExamAttemptRemoteDataSource(getIt()),
);
getIt.registerLazySingleton<ExamAttemptRepository>(
  () => ExamAttemptRepositoryImpl(getIt()),
);


getIt.registerLazySingleton<GenerateExamAttemptUseCase>(
  () => GenerateExamAttemptUseCase(getIt()),
);
getIt.registerLazySingleton<SubmitExamAttemptUseCase>(
  () => SubmitExamAttemptUseCase(getIt()),
);
getIt.registerLazySingleton<GetExamAttemptsUseCase>(
  () => GetExamAttemptsUseCase(getIt()),
);
getIt.registerLazySingleton<GetExamAttemptUseCase>(
  () => GetExamAttemptUseCase(getIt()),
);
getIt.registerLazySingleton<DeleteExamAttemptUseCase>(
  () => DeleteExamAttemptUseCase(getIt()),
);


getIt.registerFactory<ExamTakingCubit>(() => ExamTakingCubit(
  generateExamAttemptUseCase: getIt(),
  submitExamAttemptUseCase: getIt(),
));
getIt.registerFactory<ExamAttemptsHistoryCubit>(() => ExamAttemptsHistoryCubit(
  getExamAttemptsUseCase: getIt(),
  deleteExamAttemptUseCase: getIt(),
));

    //////////////////////// Quiz Attempt ////////////////////////

  //////////////////////// Inquiry ////////////////////////
  getIt.registerLazySingleton<InquiryDataSource>(
    () => InquiryDataSourceImpl(dio: getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<InquiryRepository>(
    () => InquiryRepositoryImpl(inquiryDataSource: getIt<InquiryDataSource>()),
  );
  getIt.registerFactory<InquiryCubit>(
    () => InquiryCubit(repository: getIt<InquiryRepository>()),
  );
  //////////////////////// Inquiry ////////////////////////

  //////////////////////// Notifications ////////////////////////
  getIt.registerLazySingleton<DeviceInfoDataSource>(
    () => DeviceInfoDataSourceImpl(),
  );
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt<NotificationRemoteDataSource>()),
  );
  getIt.registerLazySingleton<RegisterFcmTokenUseCase>(
    () => RegisterFcmTokenUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(
      registerFcmTokenUseCase: getIt<RegisterFcmTokenUseCase>(),
      deviceInfoDataSource: getIt<DeviceInfoDataSource>(),
      storage: getIt<AppSecureStorage>(),
    ),
  );
  //////////////////////// Notifications ////////////////////////

  //////////////////////// Live Stream ////////////////////////
  getIt.registerLazySingleton<LiveStreamRemoteDataSource>(
    () => LiveStreamRemoteDataSourceImpl(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<LiveStreamRepository>(
    () => LiveStreamRepositoryImpl(getIt<LiveStreamRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetLiveStreamsUseCase>(
    () => GetLiveStreamsUseCase(getIt<LiveStreamRepository>()),
  );
  getIt.registerLazySingleton<GetLiveStreamDetailsUseCase>(
    () => GetLiveStreamDetailsUseCase(getIt<LiveStreamRepository>()),
  );
  getIt.registerLazySingleton<CreateLiveStreamUseCase>(
    () => CreateLiveStreamUseCase(getIt<LiveStreamRepository>()),
  );
  getIt.registerLazySingleton<UpdateLiveStreamUseCase>(
    () => UpdateLiveStreamUseCase(getIt<LiveStreamRepository>()),
  );
  getIt.registerLazySingleton<StartLiveStreamUseCase>(
    () => StartLiveStreamUseCase(getIt<LiveStreamRepository>()),
  );
  getIt.registerLazySingleton<EndLiveStreamUseCase>(
    () => EndLiveStreamUseCase(getIt<LiveStreamRepository>()),
  );
  getIt.registerLazySingleton<GetLiveStreamTokenUseCase>(
    () => GetLiveStreamTokenUseCase(getIt<LiveStreamRepository>()),
  );

  getIt.registerFactory<LiveStreamCubit>(
    () => LiveStreamCubit(
      getLiveStreamsUseCase: getIt<GetLiveStreamsUseCase>(),
      getLiveStreamDetailsUseCase: getIt<GetLiveStreamDetailsUseCase>(),
      createLiveStreamUseCase: getIt<CreateLiveStreamUseCase>(),
      updateLiveStreamUseCase: getIt<UpdateLiveStreamUseCase>(),
      startLiveStreamUseCase: getIt<StartLiveStreamUseCase>(),
      endLiveStreamUseCase: getIt<EndLiveStreamUseCase>(),
      getLiveStreamTokenUseCase: getIt<GetLiveStreamTokenUseCase>(),
    ),
  );
  //////////////////////// Live Stream ////////////////////////
  


  //////////////////////// Q&A ////////////////////////

getIt.registerLazySingleton<DiscussionRemoteDataSource>(
  () => DiscussionRemoteDataSource(getIt()),
);

getIt.registerLazySingleton<DiscussionRepository>(
  () => DiscussionRepositoryImpl(getIt()),
);

getIt.registerLazySingleton<GetDiscussionQuestionsUseCase>(
  () => GetDiscussionQuestionsUseCase(getIt()),
);

getIt.registerLazySingleton<CreateDiscussionQuestionUseCase>(
  () => CreateDiscussionQuestionUseCase(getIt()),
);

getIt.registerLazySingleton<GetDiscussionAnswersUseCase>(
  () => GetDiscussionAnswersUseCase(getIt()),
);

getIt.registerLazySingleton<CreateDiscussionAnswerUseCase>(
  () => CreateDiscussionAnswerUseCase(getIt()),
);

getIt.registerLazySingleton<UpdateDiscussionQuestionUseCase>(
  () => UpdateDiscussionQuestionUseCase(getIt()),
);

getIt.registerLazySingleton<DeleteDiscussionQuestionUseCase>(
  () => DeleteDiscussionQuestionUseCase(getIt()),
);

getIt.registerLazySingleton<UpdateDiscussionAnswerUseCase>(
  () => UpdateDiscussionAnswerUseCase(getIt()),
);

getIt.registerLazySingleton<DeleteDiscussionAnswerUseCase>(
  () => DeleteDiscussionAnswerUseCase(getIt()),
);

getIt.registerFactory<DiscussionCubit>(
  () => DiscussionCubit(
    getDiscussionQuestionsUseCase: getIt(),
    createDiscussionQuestionUseCase: getIt(),
    getDiscussionAnswersUseCase: getIt(),
    createDiscussionAnswerUseCase: getIt(),
    updateDiscussionQuestionUseCase: getIt(),
    deleteDiscussionQuestionUseCase: getIt(),
    updateDiscussionAnswerUseCase: getIt(),
    deleteDiscussionAnswerUseCase: getIt(),
  ),
);

//////////////////////// Q&A ////////////////////////


}
