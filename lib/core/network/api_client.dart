import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient({Dio? dio, String? userId})
    : _userId = userId ?? 'test-user-id',
      dio = dio ??
          Dio(
            BaseOptions(
              // Android emulator -> host machine mapping
              baseUrl: 'http://192.168.1.199:5207/api',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: const {'Content-Type': 'application/json'},
            ),
          ) {
    _setupInterceptors();
  }

  final Dio dio;
  final String _userId;

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['user-id'] = _userId;

          debugPrint('REQUEST ${options.method} ${options.path}');
          debugPrint('Headers: ${options.headers}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('RESPONSE ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('ERROR ${error.requestOptions.path}: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Future<void> testHealth() async {
    try {
      final response = await dio.get('/webhook/health');
      debugPrint('Health data: ${response.data}');
    } on DioException catch (error) {
      debugPrint('Health check failed: ${error.message}');
    }
  }
}
