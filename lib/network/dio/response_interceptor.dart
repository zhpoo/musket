import 'package:dio/dio.dart';

abstract class TypeAdapter {
  T adapt<T>(dynamic data);
}

class ResponseInterceptor extends InterceptorsWrapper {
  final TypeAdapter typeAdapter;

  ResponseInterceptor({required this.typeAdapter});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response.copyWith(data: typeAdapter.adapt(response.data)));
  }
}

extension ResponseEx on Response {
  Response copyWith({
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
