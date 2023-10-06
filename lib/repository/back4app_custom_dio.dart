import 'package:dio/dio.dart';

class Back4AppCustomDio {
  final _dio = Dio();

  Dio get dio => _dio;
  Back4AppCustomDio() {
    _dio.options.headers["X-Parse-Application-Id"] =
        "H8VGi4GwYZp3bg3i3LSUMreWpXxJYxCIhQlHxhNV";
    _dio.options.headers["X-Parse-REST-API-Key"] =
        "xMajtNsZ9zFpwzndEykpR9I4WnVv3ZSMBxH9PeTz";
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes";
  }
}
