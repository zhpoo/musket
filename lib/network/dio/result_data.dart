import 'package:dio/dio.dart';

/// 网络请求结果数据
class ResultData {
  var body;
  Headers headers;
  int statusCode;
  bool isSuccessful;

  ResultData(this.body, this.isSuccessful, this.statusCode, [this.headers]);
}
