import 'package:dio/dio.dart';

abstract class TypeAdapter {
  Response<T?> adapt<T>(Response<dynamic> response);
}

class ResponseInterceptor extends InterceptorsWrapper {
  final TypeAdapter typeAdapter;

  ResponseInterceptor({required this.typeAdapter});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(typeAdapter.adapt(response));
  }
}

extension ResponseEx on Response {
  Response<T> copyWith<T>({
    dynamic data,
    RequestOptions? requestOptions,
    int? statusCode,
    String? statusMessage,
    bool? isRedirect,
    List<RedirectRecord>? redirects,
    Map<String, dynamic>? extra,
    Headers? headers,
  }) {
    return Response(
      data: data ?? this.data,
      requestOptions: requestOptions ?? this.requestOptions,
      statusCode: statusCode ?? this.statusCode,
      isRedirect: isRedirect ?? this.isRedirect,
      redirects: redirects ?? this.redirects,
      extra: extra ?? this.extra,
      headers: headers ?? this.headers,
    );
  }
}
