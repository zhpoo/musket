import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:musket/common/logger.dart';
import 'package:musket/network/dio/mime_types.dart';
import 'package:path/path.dart';

import 'code.dart';
import 'dio_wrapper.dart';
import 'response_interceptor.dart';
import 'result_data.dart';

const contentTypeFormData = 'multipart/form-data';

class Http {
  String url;
  Method method;
  Map<String, File> _files = {};
  Map<String, dynamic> _params = {};
  HttpOptions options = HttpOptions();
  dynamic _body;

  HttpCancelToken? cancelToken;
  HttpProgressCallback? onSendProgress;
  HttpProgressCallback? onReceiveProgress;

  Http({required this.method, required this.url});

  Http.get([String url = '']) : this(method: Method.get, url: url);

  Http.post([String url = '']) : this(method: Method.post, url: url);

  Http.delete([String url = '']) : this(method: Method.delete, url: url);

  Http.put([String url = '']) : this(method: Method.put, url: url);

  Http addHeader(String key, dynamic value) {
    options.headers ??= <String, dynamic>{};
    options.headers![key] = value;
    return this;
  }

  Http asFormData() {
    method = Method.post; // form-data must use post method.
    addHeader(Headers.contentTypeHeader, contentTypeFormData);
    return this;
  }

  Http addFile(String key, File file) {
    _files[key] = file;
    return this;
  }

  Http addParam(String key, dynamic value) {
    if (value is File) {
      return addFile(key, value);
    }
    _params[key] = value;
    return this;
  }

  Http addParams(Map<String, dynamic> params) {
    params.forEach(addParam);
    return this;
  }

  Http body(dynamic body) {
    this._body = body;
    return this;
  }

  /// see [ResponseInterceptor]
  Future<ResultData?> call<T>() async {
    var data;
    if (_files.isNotEmpty) {
      asFormData();
      await _createMultipartFiles();
    }
    if (method != Method.get && _body != null) {
      data = _body;
    } else if (options.headers?[Headers.contentTypeHeader] == contentTypeFormData) {
      data = FormData.fromMap(_params);
    } else {
      data = _params;
    }
    options.method = _methodToString(method);

    try {
      Response<ResultData?> response = await dioHttp.request<ResultData>(
        url,
        data: method == Method.get ? null : data,
        queryParameters: method == Method.get ? data : null,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioError catch (e) {
      return _responseError(e);
    }
  }

  _createMultipartFiles() async {
    _files.forEach((key, file) {
      _params[key] = MultipartFile.fromFileSync(
        file.path,
        filename: basename(file.path),
        contentType: parseMediaType(file),
      );
    });
  }

  static ResultData _responseError(DioError e) {
    Response errorResponse;
    if (e.response != null) {
      errorResponse = e.response!;
    } else {
      errorResponse = Response(
        statusCode: Code.failed,
        requestOptions: e.requestOptions,
      );
      if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout) {
        errorResponse.statusCode = Code.networkTimeout;
      }
    }
    return ResultData(
      body: e.message,
      isSuccessful: false,
      statusCode: errorResponse.statusCode,
      error: e,
    );
  }
}

enum Method { get, post, delete, put }

String _methodToString(Method method) {
  switch (method) {
    case Method.get:
      return 'GET';
    case Method.post:
      return 'POST';
    case Method.put:
      return 'PUT';
    case Method.delete:
      return 'DELETE';
    default:
      throw '$method NOT support yet!';
  }
}

Dio? _dio;

Dio get dioHttp {
  if (_dio == null) {
    throw 'please call initHttp() first';
  }
  return _dio!;
}

void initHttp({
  TypeAdapter? typeAdapter,
}) {
  if (_dio != null) {
    return;
  }
  Dio dio = Dio();
  dio.options.headers[Headers.contentTypeHeader] = Headers.formUrlEncodedContentType;
  dio.options.headers[Headers.acceptHeader] = Headers.jsonContentType;
  // dio.options.connectTimeout = const Duration(seconds: 15);
  dio.options.connectTimeout = 15000;
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      logPrint: _logger,
    ));
  }
  // ResponseInterceptor 需要放到 LogInterceptor 后面，否则打印不出 response 的 log
  if (typeAdapter != null) {
    dio.interceptors.add(ResponseInterceptor(typeAdapter: typeAdapter));
  }
  _dio = dio;
}

void mergeDioBaseOptions({
  String? baseUrl,
  Method? method,
  Map<String, dynamic>? queryParameters,
  String? path,
  int? connectTimeout,
  int? receiveTimeout,
  int? sendTimeout,
  Map<String, dynamic>? extra,
  Map<String, dynamic>? headers,
  String? contentType,
  ValidateStatus? validateStatus,
  bool? receiveDataWhenStatusError,
  bool? followRedirects,
  int? maxRedirects,
}) {
  dioHttp.options = dioHttp.options.copyWith(
    method: method == null ? null : _methodToString(method),
    baseUrl: baseUrl,
    queryParameters: queryParameters,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
    sendTimeout: sendTimeout,
    extra: extra,
    headers: headers,
    contentType: contentType,
    validateStatus: validateStatus,
    receiveDataWhenStatusError: receiveDataWhenStatusError,
    followRedirects: followRedirects,
    maxRedirects: maxRedirects,
  );
}

void _logger(Object object) {
  Logger.log('[Dio] $object'.replaceAll('\n', '\n\t\t\t'));
}

MediaType parseMediaType(File file) {
  if (file.path.isEmpty) return MediaType('application', 'octet-stream');
  var extensionIndex = file.path.lastIndexOf('.');
  if (extensionIndex == -1 || extensionIndex == file.path.length - 1) return MediaType('application', 'octet-stream');
  var extension = file.path.substring(extensionIndex + 1).toLowerCase();

  MediaType? mediaType;
  if (mimeTypes.containsKey(extension)) {
    var split = mimeTypes[extension]?.split('/');
    mediaType = split == null ? null : MediaType(split[0], split[1]);
  }
  return mediaType ?? MediaType('application', 'octet-stream');
}
