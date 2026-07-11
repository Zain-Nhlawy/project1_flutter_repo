import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
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
import 'package:project1/features/course/domain/use_case/get_demo_courses_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_tags_usecase.dart';
import 'package:project1/features/course/domain/use_case/update_course_usecase.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/upload_photo/data/data_sources/upload_photo_course_remote_datasource.dart';
import 'package:project1/features/course/upload_photo/data/repository/upload_photo_course_repositpry_impl.dart';
import 'package:project1/features/course/upload_photo/domain/repository/upload_photo_course_repository.dart';
import 'package:project1/features/course/upload_photo/domain/use_case/upload_photo_course_usecase.dart';
import 'package:project1/features/course/upload_photo/presentation/cubit/upload_photo_course_cubit.dart';
import 'package:project1/features/demo/data/data_sources/demo_payment_data_source.dart';
import 'package:project1/features/demo/data/data_sources/demo_remote_datasource.dart';
import 'package:project1/features/demo/data/repository/demo_repository.dart';
import 'package:project1/features/demo/data/repository/demo_repository_impl.dart';
import 'package:project1/features/demo/data/repository/payment%20repo/demo_payment_repository_impl.dart';
import 'package:project1/features/demo/domain/repository/demo_payment_repository.dart';
import 'package:project1/features/demo/domain/use%20case/demo_payment_usecase.dart';
import 'package:project1/features/demo/domain/use%20case/demos_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/demo_cubit.dart';
import 'package:project1/features/department/data/data_sources/department_data_source.dart';
import 'package:project1/features/department/domain/repository/department_repository.dart';
import 'package:project1/features/department/data/repository/department_repository_implement.dart';
import 'package:project1/features/department/domain/use_case/get_department_use_case.dart';
import 'package:project1/features/department/presentation/cubit/department_cubit.dart';
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
  () => CourseRemoteDataSource(
    getIt<DioClient>(),
  ),
);
getIt.registerLazySingleton<UploadPhotoCourseRemoteDataSource>(
  () => UploadPhotoCourseRemoteDataSource(
    getIt<DioClient>(),
  ),
);


// repository
getIt.registerLazySingleton<CourseRepository>(
  () => CourseRepositoryImpl(
    getIt<CourseRemoteDataSource>(),
  ),
);
getIt.registerLazySingleton<UploadPhotoCourseRepository>(
  () => UploadPhotoCourseRepositoryImpl(
    getIt<UploadPhotoCourseRemoteDataSource>(),
  ),
);


// usecases
getIt.registerLazySingleton<UploadPhotoCourseUseCase>(
  () => UploadPhotoCourseUseCase(
    getIt<UploadPhotoCourseRepository>(),
  ),
);
getIt.registerLazySingleton<GetTagsUseCase>(
  () => GetTagsUseCase(
    getIt<CourseRepository>(),
  ),
);
getIt.registerLazySingleton<CreateCourseUseCase>(
  () => CreateCourseUseCase(
    getIt<CourseRepository>(),
  ),
);
getIt.registerLazySingleton<GetDemoCoursesUseCase>(
  () => GetDemoCoursesUseCase(
    getIt<CourseRepository>(),
  ),
);
getIt.registerLazySingleton<UpdateCourseUseCase>(
  () => UpdateCourseUseCase(
    getIt<CourseRepository>(),
  ),
);
getIt.registerLazySingleton(
  () => DeleteCourseUseCase(getIt()),
);


// cubit
getIt.registerFactory<UploadPhotoCourseCubit>(
  () => UploadPhotoCourseCubit(
    getIt<UploadPhotoCourseUseCase>(),
  ),
);
getIt.registerFactory<CourseCubit>(
  () => CourseCubit(
    getTagsUseCase: getIt<GetTagsUseCase>(),
    createCourseUseCase: getIt<CreateCourseUseCase>(),
    getDemoCoursesUseCase: getIt<GetDemoCoursesUseCase>(),
    updateCourseUseCase: getIt<UpdateCourseUseCase>(),
    deleteCourseUseCase: getIt(),
  ),
);


//////////////////////// Course ////////////////////////



//////////////////////// Section ////////////////////////

// datasource
getIt.registerLazySingleton<SectionRemoteDataSource>(
  () => SectionRemoteDataSource(
    getIt<DioClient>(),
  ),
);

// repository
getIt.registerLazySingleton<SectionRepository>(
  () => SectionRepositoryImpl(
    getIt<SectionRemoteDataSource>(),
  ),
);

// usecases
getIt.registerLazySingleton<CreateSectionUseCase>(
  () => CreateSectionUseCase(
    getIt<SectionRepository>(),
  ),
);

getIt.registerLazySingleton<GetSectionUseCase>(
  () => GetSectionUseCase(
    getIt<SectionRepository>(),
  ),
);

getIt.registerLazySingleton<UpdateSectionUseCase>(
  () => UpdateSectionUseCase(
    getIt<SectionRepository>(),
  ),
);

getIt.registerLazySingleton<DeleteSectionUseCase>(
  () => DeleteSectionUseCase(
    getIt<SectionRepository>(),
  ),
);

getIt.registerLazySingleton<GetSectionsUseCase>(
  () => GetSectionsUseCase(
    getIt<SectionRepository>(),
  ),
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
}
