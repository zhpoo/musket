import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:musket/common/base_config.dart';
import 'package:musket/common/logger.dart';

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
  HttpOptions options = new HttpOptions();

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
      _params[key] = MultipartFile.fromFileSync(file.path, filename: basename(file.path));
    });
  }

  static ResultData _responseError(DioError e) {
    Response errorResponse;
    if (e.response != null) {
      errorResponse = e.response;
    } else {
      errorResponse = new Response(statusCode: Code.failed, request: e.request);
    }
    if (e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT) {
      errorResponse.statusCode = Code.networkTimeout;
    }
    return new ResultData(e.message, false, errorResponse.statusCode);
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
  Dio dio = new Dio();
  dio.options.headers[Headers.contentTypeHeader] = Headers.formUrlEncodedContentType;
  dio.options.headers[Headers.acceptHeader] = Headers.jsonContentType;
  dio.options.connectTimeout = BaseConfig.httpConnectTimeout;
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

void _logger(Object object) {
  Logger.log('[Dio] $object'.replaceAll('\n', '\n\t\t\t'));
}
