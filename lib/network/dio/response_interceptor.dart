import 'package:dio/dio.dart';

import 'result_data.dart';

class ResponseInterceptor extends InterceptorsWrapper {
  @override
  Future onResponse(Response response) async {
    bool isSuccessful = response.statusCode >= 200 && response.statusCode < 300;
    return ResultData(
      body: response.data,
      isSuccessful: isSuccessful,
      statusCode: response.statusCode,
      headers: response.headers,
    );
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}
