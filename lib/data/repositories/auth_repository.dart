import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../core/storage/token_storage.dart';
import '../models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login(String username, String password);
  Future<AuthUser> getCurrentUser();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._storage);
  final ApiClient _api;
  final TokenStorage _storage;

  @override
  Future<AuthUser> login(String username, String password) async {
    final data = await _api.post(ApiConstants.login, data: {
      'username': username,
      'password': password,
      'expiresInMins': 60,
    });
    final user = AuthUser.fromJson(data as Map<String, dynamic>);
    if (user.token.isEmpty) throw ApiException('Login failed: no token received.');
    await _storage.saveSession(token: user.token, refreshToken: user.refreshToken);
    return user;
  }

  @override
  Future<AuthUser> getCurrentUser() async {
    final data = await _api.get(ApiConstants.me);
    return AuthUser.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> logout() => _storage.clear();
}
