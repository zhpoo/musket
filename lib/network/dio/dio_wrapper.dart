import 'package:dio/dio.dart';

class HttpOptions extends RequestOptions {}

class HttpCancelToken extends CancelToken {}

typedef HttpProgressCallback = void Function(int count, int total);
