import 'package:dio/dio.dart';

import 'result_data.dart';

class ResponseInterceptor extends InterceptorsWrapper {
  @override
  onResponse(Response response) async {
    bool isSuccessful = response.statusCode >= 200 && response.statusCode < 300;
    return new ResultData(response.data, isSuccessful, response.statusCode, response.headers);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}
