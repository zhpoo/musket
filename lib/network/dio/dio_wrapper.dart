import 'package:dio/dio.dart';

class HttpOptions extends RequestOptions {}

class HttpCancelToken extends CancelToken {
  static bool isCancel(DioError e) => CancelToken.isCancel(e);
}

typedef HttpProgressCallback = void Function(int count, int total);
