import 'package:dio/dio.dart';

/// 网络请求结果数据
class ResultData {
  dynamic body;
  Headers? headers;
  int? statusCode;
  bool? isSuccessful;
  DioError? error;

  ResultData({
    this.body,
    this.isSuccessful,
    this.statusCode,
    this.headers,
    this.error,
  });

  String get failMessage => error?.message?.isNotEmpty == true ? error!.message! : '$body';
}
