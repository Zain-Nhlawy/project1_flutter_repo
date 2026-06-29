import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/features/auth/auth_token_manager.dart';
import 'package:project1/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:project1/features/auth/data/repository/auth_repository_impl.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';
import 'package:project1/features/auth/domain/use_case/change_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/forgot_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/get_me_usecase.dart';
import 'package:project1/features/auth/domain/use_case/google_login_usecase.dart';
import 'package:project1/features/auth/domain/use_case/register_usecase.dart';
import 'package:project1/features/auth/domain/use_case/login_usecase.dart';
import 'package:project1/features/auth/domain/use_case/logout_usecase.dart';
import 'package:project1/features/auth/domain/use_case/resend_verification_email_usecase.dart';
import 'package:project1/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/verify_email_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/upload_photo/data/data_sources/upload_photo_remote_datasource.dart';
import 'package:project1/features/auth/upload_photo/data/repository/upload_photo_repository_impl.dart';
import 'package:project1/features/auth/upload_photo/domain/repository/upload_photo_repository.dart';
import 'package:project1/features/auth/upload_photo/domain/use_case/upload_photo_usecase.dart';
import 'package:project1/features/demo/data/data_sources/demo_remote_datasource.dart';
import 'package:project1/features/demo/data/repository/demo_repository.dart';
import 'package:project1/features/demo/data/repository/demo_repository_impl.dart';
import 'package:project1/features/demo/domain/use%20case/get_demos_usecase.dart';
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


final getIt = GetIt.instance;

final String baseUrl = dotenv.env['BASE_URL'] ?? '';

void setupDI() {
  //storage
  getIt.registerLazySingleton<AppSecureStorage>(
    () => AppSecureStorage(),
  );
  
  //dio
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      storage: getIt<AppSecureStorage>(),
      refreshToken: () async => null,
      refreshIfNeeded: () async {},
    ),
  );



  ////////////////////Auth+user////////////////////
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AppSecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<UploadPhotoRemoteDataSource>(
    () => UploadPhotoRemoteDataSource(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<UploadPhotoRepository>(
    () => UploadPhotoRepositoryImpl(getIt<UploadPhotoRemoteDataSource>()),
  );
  getIt.registerLazySingleton<AuthTokenManager>(
    () => AuthTokenManager(getIt<AppSecureStorage>()),
  );

  //usecase
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyEmailUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(getIt<AuthRepository>()),);
  getIt.registerLazySingleton(() => GoogleLoginUseCase(getIt<AuthRepository>()),);
  getIt.registerLazySingleton(() => ResendVerificationEmailUseCase(getIt<AuthRepository>()),);
  getIt.registerLazySingleton<GetMeUseCase>(() => GetMeUseCase(getIt<AuthRepository>()),);
  getIt.registerLazySingleton<UploadPhotoUseCase>(() => UploadPhotoUseCase(getIt<UploadPhotoRepository>()),);

  //cubit
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
      ),
  );




  getIt.registerLazySingleton<ProfileRemoteDataSource>(
  () => ProfileRemoteDataSource(getIt<DioClient>()),
);

getIt.registerLazySingleton<ProfileRepository>(
  () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
);

getIt.registerLazySingleton(
  () => UpdateProfileImageUseCase(getIt<ProfileRepository>()),
);

getIt.registerFactory(
  () => UserCubit(
    getMeUseCase: getIt<GetMeUseCase>(),
    updateProfileImageUseCase: getIt<UpdateProfileImageUseCase>(),
  ),
);



  ////////////////////Auth+user////////////////////
  

  ////////////////////Demo////////////////////
getIt.registerLazySingleton<DemoRemoteDataSource>(
  () => DemoRemoteDataSourceImpl(
    getIt<DioClient>(),
    dio: getIt<DioClient>().dio,
  ),
);
getIt.registerLazySingleton<DemoRepository>(
  () => DemoRepositoryImpl(
    getIt<DioClient>(),
    remoteDataSource: getIt<DemoRemoteDataSource>(),
  ),
);
getIt.registerLazySingleton<GetDemosUseCase>(
  () => GetDemosUseCase(getIt<DemoRepository>()),
);
getIt.registerFactory(
  () => DemoCubit(
    getDemosUseCase: getIt<GetDemosUseCase>(),
  ),
);
  ////////////////////Demo////////////////////
  

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
}