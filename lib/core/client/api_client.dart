import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:spotify_clone/utils/secure_storage.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

Dio createDio() {
  final dio = Dio();

  dio.interceptors.add(DioCacheInterceptor(
    options: CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      maxStale: const Duration(days: 7),
    ),
  ));

  dio.interceptors.add(
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: false,
        printResponseHeaders: false,
        printResponseMessage: false,
      ),
    ),
  );
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    var token = SecureStorage().getData(key: 'accessToken');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }));

  return dio;
}

class DioInspector {
  final Dio _dio;

  DioInspector(this._dio);

  Future<Response<T>> send<T>(RequestOptions options) async {
    try {
      final response = await _dio.request<T>(options.path,
          data: options.data,
          queryParameters: options.queryParameters,
          options: Options(
            method: options.method,
            headers: options.headers,
          ));

      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Response status: ${e.response?.statusCode}');
        print('Response headers: ${e.response?.headers}');
      } else {
        print('Request failed with error: $e');
      }

      return Future.error(e);
    }
  }
}
