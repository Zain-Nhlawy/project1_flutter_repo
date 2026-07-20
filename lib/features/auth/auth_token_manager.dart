// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:project1/core/storage/secure_storage.dart';
// import 'package:project1/core/storage/storage_keys.dart';

// class AuthTokenManager {
//   final AppSecureStorage storage;

//   AuthTokenManager(this.storage);

//   Future<String?> getAccessToken() async {
//     return storage.read(StorageKeys.token);
//   }

//   Future<String?> getRefreshToken() async {
//     return storage.read(StorageKeys.refreshToken);
//   }

//   Future<bool> isTokenExpired() async {
//     final token = await getAccessToken();
//     if (token == null) return true;

//     try {
//       return JwtDecoder.isExpired(token);
//     } catch (_) {
//       return true;
//     }
//   }

//   Future<Duration?> getRemainingTime() async {
//     final token = await getAccessToken();
//     if (token == null) return null;

//     try {
//       return JwtDecoder.getRemainingTime(token);
//     } catch (_) {
//       return null;
//     }
//   }

//   Future<bool> shouldRefresh() async {
//     final remaining = await getRemainingTime();
//     if (remaining == null) return true;

//     return remaining.inSeconds < 60;
//   }

//   Future<void> saveTokens({
//     required String accessToken,
//     required String refreshToken,
//   }) async {
//     await storage.write(StorageKeys.token, accessToken);
//     await storage.write(StorageKeys.refreshToken, refreshToken);
//   }

//   Future<void> clearTokens() async {
//     await storage.delete(StorageKeys.token);
//     await storage.delete(StorageKeys.refreshToken);
//   }
// }
