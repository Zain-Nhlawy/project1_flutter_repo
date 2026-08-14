import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/features/auth/domain/entities/user_entity.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';
import 'package:project1/features/auth/domain/use_case/get_me_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/profile/domain/repository/profile_repository.dart';
import 'package:project1/features/profile/domain/use_case/update_profile_image_usecase.dart';

const testUser = UserEntity(
  id: 'user-id',
  firstName: 'Test',
  lastName: 'User',
  email: 'test@example.com',
  birthDate: '2000-01-01',
  imagePath: '',
  role: 'student',
  isEmailVerified: true,
  isTwoFactorEnabled: false,
);

class FakeSecureStorage implements AppSecureStorage {
  final Map<String, String> values;

  FakeSecureStorage([Map<String, String>? initialValues])
    : values = {...?initialValues};

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  Future<void> clear() async {
    values.clear();
  }
}

class StubGetMeUseCase implements GetMeUseCase {
  Either<Failure, UserEntity> result;
  int callCount = 0;

  StubGetMeUseCase(this.result);

  @override
  AuthRepository get repository => throw UnsupportedError('Not used by test');

  @override
  Future<Either<Failure, UserEntity>> call() async {
    callCount++;
    return result;
  }
}

class StubUpdateProfileImageUseCase implements UpdateProfileImageUseCase {
  @override
  ProfileRepository get repository =>
      throw UnsupportedError('Not used by test');

  @override
  Future<Either<Failure, void>> call(File file, String userId) async {
    return const Right(null);
  }
}

UserCubit createTestUserCubit(StubGetMeUseCase getMeUseCase) {
  return UserCubit(
    getMeUseCase: getMeUseCase,
    updateProfileImageUseCase: StubUpdateProfileImageUseCase(),
  );
}
