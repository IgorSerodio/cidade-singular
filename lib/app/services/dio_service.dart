import 'package:cidade_singular/app/config.dart';
import 'package:dio/dio.dart';

class DioService {
  final Dio _dio = Dio(BaseOptions(baseUrl: Config.apiURL));

  Dio get dio => _dio;

  Dio addToken(String token) {
    return dio
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options, handler) {
            _logRequest(options);
            return handler.next(_requestInterceptor(options, token));
          },
        ),
      );
  }

  RequestOptions _requestInterceptor(RequestOptions options, String token) {
    options.headers.addAll({"Authorization": "Bearer $token"});
    return options;
  }

  void removeToken() {
    dio.interceptors.clear();
  }

  void _logRequest(RequestOptions options) {
    print("➡️ Enviando requisição: ${options.method} ${options.uri}");
    print("Headers: ${options.headers}");
    print("Body: ${options.data}");
  }
}
