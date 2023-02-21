import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:musket/common/logger.dart';
import 'package:musket/network/dio/log_intercepter_plus.dart';
import 'package:musket/network/dio/mime_types.dart';

typedef HttpOptions = Options;

typedef HttpProgressCallback = ProgressCallback;

typedef HttpCancelToken = CancelToken;

typedef HttpResponse<T> = Response<T>;

abstract class TypeAdapter {
  const TypeAdapter();

  T? adapt<T>(data);

  List<T>? adaptList<T>(data) {
    if (data == null) {
      _logger('adapt List<$T> with data: null');
      return null;
    }
    return List<T>.from(data.map((e) => adapt<T>(e)));
  }
}

class DefaultTypeAdapter extends TypeAdapter {
  const DefaultTypeAdapter();

  @override
  T? adapt<T>(data) => data as T?;
}

const formData = 'multipart/form-data';

extension ResponseEx on HttpResponse {
  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;

  bool get isNetworkError => statusCode == null;

  Response<T> withData<T>({
    required T? data,
    RequestOptions? requestOptions,
    int? statusCode,
    String? statusMessage,
    bool? isRedirect,
    List<RedirectRecord>? redirects,
    Map<String, dynamic>? extra,
    Headers? headers,
  }) {
    return Response(
      data: data,
      requestOptions: requestOptions ?? this.requestOptions,
      statusCode: statusCode ?? this.statusCode,
      isRedirect: isRedirect ?? this.isRedirect,
      redirects: redirects ?? this.redirects,
      extra: extra ?? this.extra,
      headers: headers ?? this.headers,
    );
  }
}

class Http {
  Http._();

  static TypeAdapter _typeAdapter = const DefaultTypeAdapter();

  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) initHttp();
    return _dio!;
  }

  static void initHttp({
    BaseOptions? options,
    bool loggable = kDebugMode,
    TypeAdapter? typeAdapter,
  }) {
    Dio dio = _dio ?? Dio();
    dio.options = options ??
        BaseOptions(
          headers: {
            Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
            Headers.acceptHeader: Headers.jsonContentType,
          },
          connectTimeout: 15000,
        );
    if (loggable) {
      var logInterceptor = LogInterceptorPlus(
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        logPrint: _logger,
      );
      dio.interceptors.add(logInterceptor);
    } else {
      dio.interceptors.removeWhere((element) => element is LogInterceptorPlus);
    }
    if (typeAdapter != null) {
      _typeAdapter = typeAdapter;
    }
    _dio = dio;
  }

  /// 发起Http请求对象而非 List
  static Future<HttpResponse<T?>> request<T>({
    required String path,
    String? method,
    dynamic data,
    HttpOptions? options,
    HttpCancelToken? cancelToken,
    HttpProgressCallback? onSendProgress,
    HttpProgressCallback? onReceiveProgress,
    TypeAdapter? typeAdapter,
  }) async {
    var response = await _fetch(
      path: path,
      method: method,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    typeAdapter ??= _typeAdapter;
    return response.withData(data: typeAdapter.adapt<T>(response.data));
  }

  /// 发起Http请求 List
  static Future<HttpResponse<List<T>?>> requestList<T>({
    required String path,
    String? method,
    dynamic data,
    HttpOptions? options,
    HttpCancelToken? cancelToken,
    HttpProgressCallback? onSendProgress,
    HttpProgressCallback? onReceiveProgress,
    TypeAdapter? typeAdapter,
  }) async {
    var response = await _fetch(
      path: path,
      method: method,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    typeAdapter ??= _typeAdapter;
    return response.withData(data: typeAdapter.adaptList<T>(response.data));
  }

  static Future<HttpResponse> _fetch({
    required String path,
    String? method,
    dynamic data,
    HttpOptions? options,
    HttpCancelToken? cancelToken,
    HttpProgressCallback? onSendProgress,
    HttpProgressCallback? onReceiveProgress,
  }) async {
    options ??= HttpOptions();

    Response<dynamic> response;
    try {
      if (data is Map<String, dynamic>) {
        var hasFile = false;
        data.forEach((key, value) async {
          if (value is File) {
            hasFile = true;
            data[key] = await asMultipartFile(value);
          } else if (value is MultipartFile) {
            hasFile = true;
          }
        });
        if (hasFile) {
          data = FormData.fromMap(data);
          options.headers ??= {};
          options.headers![Headers.contentTypeHeader] = formData;
        }
      }
      method ??= dio.options.method;
      method = method.toLowerCase();
      options.method = method;

      var query = method == 'get' ? data : null;

      response = await dio.request(
        path,
        data: query == null ? data : null,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      Logger.log(e);
      response = e.response ?? Response(requestOptions: e.requestOptions, statusMessage: e.message);
    }
    return response;
  }

  static Future<MultipartFile> asMultipartFile(File file) async {
    return await MultipartFile.fromFile(
      file.path,
      contentType: parseMediaType(file),
    );
  }
}

void _logger(Object object) {
  // Logger.log('[Dio] $object'.replaceAll('\n', '\n\t\t\t'));
  Logger.log(object);
}

MediaType parseMediaType(File file) {
  if (file.path.isEmpty) {
    return MediaType('application', 'octet-stream');
  }
  var extensionIndex = file.path.lastIndexOf('.');
  if (extensionIndex == -1 || extensionIndex == file.path.length - 1) {
    return MediaType('application', 'octet-stream');
  }
  var extension = file.path.substring(extensionIndex + 1).toLowerCase();

  MediaType? mediaType;
  if (mimeTypes.containsKey(extension)) {
    var split = mimeTypes[extension]?.split('/');
    mediaType = split == null ? null : MediaType(split[0], split[1]);
  }
  return mediaType ?? MediaType('application', 'octet-stream');
}
