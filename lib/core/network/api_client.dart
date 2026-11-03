import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../../app/routes/app_pages.dart';
import '../constants/api_constants.dart';
import '../storage/token_storage.dart';
import '../utils/app_snack.dart';
import 'api_exception.dart';

/// Thin wrapper around Dio:
///  * attaches `Authorization: Bearer <jwt>` to every request
///  * logs the user out on 401 (expired / invalid token)
///  * converts every failure into a friendly [ApiException]
class ApiClient {
  ApiClient(this._tokenStorage) {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenStorage.readToken();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (e, handler) async {
        final isLogin = e.requestOptions.path.contains(ApiConstants.login);
        if (e.response?.statusCode == 401 && !isLogin && !_loggingOut) {
          _loggingOut = true;
          await _tokenStorage.clear();
          AppSnack.error('Your session has expired. Please sign in again.');
          await Get.offAllNamed(Routes.login);
          _loggingOut = false;
        }
        handler.next(e);
      },
    ));
  }

  final TokenStorage _tokenStorage;
  late final Dio dio;
  bool _loggingOut = false;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send('GET', path, query: query);

  Future<dynamic> post(String path, {dynamic data}) => _send('POST', path, data: data);

  Future<dynamic> put(String path, {dynamic data}) => _send('PUT', path, data: data);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(String method, String path,
      {Map<String, dynamic>? query, dynamic data}) async {
    try {
      final res = await dio.request(
        path,
        data: data,
        queryParameters: query,
        options: Options(method: method),
      );
      return res.data;
    } on DioException catch (e) {
      throw _toApiException(e);
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  ApiException _toApiException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('The connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return ApiException('No internet connection.');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final body = e.response?.data;
        final serverMsg = body is Map ? body['message']?.toString() : null;
        if (serverMsg != null && serverMsg.isNotEmpty) {
          return ApiException(serverMsg, statusCode: code);
        }
        String msg;
        if (code == 400) {
          msg = 'Invalid request.';
        } else if (code == 401) {
          msg = 'Unauthorized. Please sign in again.';
        } else if (code == 403) {
          msg = 'You do not have permission to do that.';
        } else if (code == 404) {
          msg = 'The requested item was not found.';
        } else if (code != null && code >= 500) {
          msg = 'Server error. Please try later.';
        } else {
          msg = 'Request failed ($code).';
        }
        return ApiException(msg, statusCode: code);
      case DioExceptionType.cancel:
        return ApiException('Request cancelled.');
      default:
        return ApiException('Something went wrong. Please try again.');
    }
  }
}
