import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class DioClient {
  final Dio dio;
  final TokenStorage _tokenStorage;

  DioClient(this._tokenStorage)
    : dio = Dio(
        BaseOptions(
          baseUrl: 'http://192.168.100.7:8000/api',
          headers: {'Accept': 'application/json'},
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _tokenStorage.clear();
          }
          handler.next(error);
        },
      ),
    );
  }
}
