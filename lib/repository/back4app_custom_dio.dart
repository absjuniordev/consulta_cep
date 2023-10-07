import 'package:dio/dio.dart';
import 'backapp_dio_interceptor.dart';

class Back4AppCustomDio {
  final _dio = Dio();

  Dio get dio => _dio;

  Back4AppCustomDio() {
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes";
    _dio.interceptors.add(BackAppDioInterceptor());
  }
}
