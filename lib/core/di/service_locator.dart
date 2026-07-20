import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
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
import 'package:project1/features/course/data/repository/course_repository_impl.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';
import 'package:project1/features/course/domain/use_case/create_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/delete_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_demo_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_demo_courses_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_tags_usecase.dart';
import 'package:project1/features/course/domain/use_case/publish_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/update_course_usecase.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/tags_cubit.dart';
import 'package:project1/features/course/upload_photo/data/data_sources/upload_photo_course_remote_datasource.dart';
import 'package:project1/features/course/upload_photo/data/repository/upload_photo_course_repositpry_impl.dart';
import 'package:project1/features/course/upload_photo/domain/repository/upload_photo_course_repository.dart';
import 'package:project1/features/course/upload_photo/domain/use_case/upload_photo_course_usecase.dart';
import 'package:project1/features/course/upload_photo/presentation/cubit/upload_photo_course_cubit.dart';
import 'package:project1/features/demo/data/data_sources/data_payment_data_source.dart';
import 'package:project1/features/demo/data/data_sources/demo_remote_data_source.dart';
import 'package:project1/features/demo/data/data_sources/demo_users_remote_data_source.dart';
import 'package:project1/features/demo/data/repository/demo_repository.dart';
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
import 'package:project1/features/demo/presentation/cubit/department%20cubit/department_cubit.dart';
import 'package:project1/features/department/data/data_sources/department_data_source.dart';
import 'package:project1/features/department/domain/repository/department_repository.dart';
import 'package:project1/features/department/data/repository/department_repository_implement.dart';
import 'package:project1/features/department/domain/use_case/get_department_use_case.dart';
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
import 'package:project1/features/profile/data/data_sources/profile_remote_datasource.dart';
import 'package:project1/features/profile/data/repository/profile_repository_impl.dart';
import 'package:project1/features/profile/domain/repository/profile_repository.dart';
import 'package:project1/features/profile/domain/use_case/update_profile_image_usecase.dart';
import 'package:project1/features/section/data/data_sources/section_remote_datasource.dart';
import 'package:project1/features/section/data/repository/section_repository_impl.dart';
import 'package:project1/features/section/domain/repository/section_repository.dart';
import 'package:project1/features/section/domain/use_case/create_section_usecase.dart';
import 'package:project1/features/section/domain/use_case/delete_section_usecase.dart';
import 'package:project1/features/section/domain/use_case/get_section_usecase.dart';
import 'package:project1/features/section/domain/use_case/get_sections_usecase.dart';
import 'package:project1/features/section/domain/use_case/update_section_usecase.dart';
import 'package:project1/features/section/presentation/cubit/section_cubit.dart';

final getIt = GetIt.instance;

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
  getIt.registerFactory(
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
    () => DemoCubit(getDemosUseCase: getIt<GetDemosUseCase>()),
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
}
