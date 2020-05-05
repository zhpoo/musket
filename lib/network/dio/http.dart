import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:musket/common/base_config.dart';
import 'package:musket/common/logger.dart';
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

  HttpCancelToken cancelToken;
  HttpProgressCallback onSendProgress;
  HttpProgressCallback onReceiveProgress;

  Http({this.method, this.url});

  Http.get([this.url]) {
    method = Method.get;
  }

  Http.post([this.url]) {
    method = Method.post;
  }

  Http.delete([this.url]) {
    method = Method.delete;
  }

  Http.put([this.url]) {
    method = Method.put;
  }

  Http addHeader(String key, dynamic value) {
    if (options.headers == null) {
      options.headers = {};
    }
    options.headers[key] = value;
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

  /// see [ResponseInterceptor]
  Future<ResultData> call<T>() async {
    var data;
    if (_files.isNotEmpty) {
      asFormData();
      await _createMultipartFiles();
    }
    if (options.headers != null &&
        options.headers[Headers.contentTypeHeader] == contentTypeFormData) {
      data = FormData.fromMap(_params);
    } else {
      data = _params;
    }
    options.method = _methodToString(method);

    try {
      Response<ResultData> response = await _dio.request<ResultData>(url,
          data: method == Method.get ? null : data,
          queryParameters: method == Method.get ? data : null,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
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
      errorResponse = e.response;
    } else {
      errorResponse = Response(statusCode: Code.failed, request: e.request);
    }
    if (e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT) {
      errorResponse.statusCode = Code.networkTimeout;
    }
    return ResultData(e.message, false, errorResponse.statusCode);
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

final _dio = _initDioInstance();

Dio _initDioInstance() {
  Dio dio = Dio();
  dio.options.headers[Headers.contentTypeHeader] = Headers.formUrlEncodedContentType;
  dio.options.headers[Headers.acceptHeader] = Headers.jsonContentType;
  dio.options.connectTimeout = 15 * 1000;
  if (BaseConfig.debug) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      logPrint: _logger,
    ));
  }
  // ResponseInterceptor 需要放到 LogInterceptor 后面，否则打印不出 response 的 log
  dio.interceptors.add(ResponseInterceptor());
  return dio;
}

void mergeDioBaseOptions({
  String baseUrl,
  Method method,
  Map<String, dynamic> queryParameters,
  String path,
  int connectTimeout,
  int receiveTimeout,
  int sendTimeout,
  Map<String, dynamic> extra,
  Map<String, dynamic> headers,
  String contentType,
  bool validateStatus(int status),
  bool receiveDataWhenStatusError,
  bool followRedirects,
  int maxRedirects,
}) {
  _dio.options = _dio.options.merge(
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
  if (file?.path?.isEmpty ?? true) return null;
  var extensionIndex = file.path.lastIndexOf('.');
  if (extensionIndex == -1) return null;
  switch (file.path.substring(extensionIndex)) {
    case ".jpg":
    case ".jpeg":
    case ".jpe":
      return MediaType("image", "jpeg");
    case ".png":
      return MediaType("image", "png");
    case ".bmp":
      return MediaType("image", "bmp");
    case ".gif":
      return MediaType("image", "gif");
    case ".svg":
    case ".svgz":
      return MediaType("image", "svg+xml");
    case ".json":
      return MediaType("application", "json");
    case ".mp3":
      return MediaType("audio", "mpeg");
    case ".mp4":
      return MediaType("video", "mp4");
    case ".htm":
    case ".html":
      return MediaType("text", "html");
    case ".css":
      return MediaType("text", "css");
    case ".csv":
      return MediaType("text", "csv");
    case ".txt":
    case ".text":
    case ".conf":
    case ".def":
    case ".log":
    case ".in":
      return MediaType("text", "plain");
  }
  return null;
}
