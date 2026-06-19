import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/features/auth/auth_token_manager.dart';
import 'package:project1/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:project1/features/auth/data/repository/auth_repository_impl.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';
import 'package:project1/features/auth/domain/use_case/forgot_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/register_usecase.dart';
import 'package:project1/features/auth/domain/use_case/login_usecase.dart';
import 'package:project1/features/auth/domain/use_case/logout_usecase.dart';
import 'package:project1/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/verify_email_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/demo/data/data_sources/demo_remote_datasource.dart';
import 'package:project1/features/demo/data/repository/demo_repository.dart';
import 'package:project1/features/demo/data/repository/demo_repository_impl.dart';
import 'package:project1/features/demo/domain/use%20case/get_demos_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/demo_cubit.dart';

final getIt = GetIt.instance;

final String baseUrl = dotenv.env['BASE_URL'] ?? '';

void setupDI() {
  getIt.registerLazySingleton<AppSecureStorage>(
    () => AppSecureStorage(),
  );

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      storage: getIt<AppSecureStorage>(),
      refreshToken: () async => null,
      refreshIfNeeded: () async {},
    ),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AppSecureStorage>(),
    ),
  );

  getIt.registerLazySingleton<AuthTokenManager>(
    () => AuthTokenManager(getIt<AppSecureStorage>()),
  );

  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyEmailUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt<AuthRepository>()));


getIt.registerLazySingleton<DemoRemoteDataSource>(
  () => DemoRemoteDataSourceImpl(
    dio: getIt<DioClient>().dio,
  ),
);

getIt.registerLazySingleton<DemoRepository>(
  () => DemoRepositoryImpl(
    remoteDataSource: getIt<DemoRemoteDataSource>(),
  ),
);

getIt.registerLazySingleton<GetDemosUseCase>(
  () => GetDemosUseCase(
    getIt<DemoRepository>(),
  ),
);


getIt.registerFactory(
  () => DemoCubit(
    getDemosUseCase: getIt<GetDemosUseCase>(),
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
      
    ),
  );
}