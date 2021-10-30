import 'package:dio/dio.dart';

import 'result_data.dart';

class ResponseInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    bool isSuccessful = response.statusCode >= 200 && response.statusCode < 300;
    var resultData = ResultData(
      body: response.data,
      isSuccessful: isSuccessful,
      statusCode: response.statusCode,
      headers: response.headers,
    );
    var transformedResponse = Response(
      requestOptions: response.requestOptions,
      data: resultData,
      headers: response.headers,
      isRedirect: response.isRedirect,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      redirects: response.redirects,
      extra: response.extra,
    );
    // handler.resolve(transformedResponse);
    super.onResponse(transformedResponse, handler);
  }
}
