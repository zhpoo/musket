import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
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
    options.headers ??= <String, dynamic>{};
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
    if (options.headers != null && options.headers[Headers.contentTypeHeader] == contentTypeFormData) {
      data = FormData.fromMap(_params);
    } else {
      data = _params;
    }
    options.method = _methodToString(method);

    try {
      Response<ResultData> response = await _dio.request<ResultData>(
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
      errorResponse = e.response;
    } else {
      errorResponse = Response(statusCode: Code.failed, request: e.request);
    }
    if (e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT) {
      errorResponse.statusCode = Code.networkTimeout;
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

final _dio = _initDioInstance();

Dio _initDioInstance() {
  Dio dio = Dio();
  dio.options.headers[Headers.contentTypeHeader] = Headers.formUrlEncodedContentType;
  dio.options.headers[Headers.acceptHeader] = Headers.jsonContentType;
  dio.options.connectTimeout = 15 * 1000;
  if (kDebugMode) {
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
  if (extensionIndex == -1 || extensionIndex == file.path.length - 1) return null;
  var extension = file.path.substring(extensionIndex + 1).toLowerCase();

  MediaType mediaType;
  if (mimeTypes.containsKey(extension)) {
    var split = mimeTypes[extension].split('/');
    mediaType = MediaType(split[0], split[1]);
  }
  return mediaType ?? MediaType('application', 'octet-stream');
}

const Map<String, String> mimeTypes = const {
  "html": "text/html",
  "htm": "text/html",
  "shtml": "text/html",
  "css": "text/css",
  "xml": "text/xml",
  "gif": "image/gif",
  "jpeg": "image/jpeg",
  "jpg": "image/jpeg",
  "jpe": "image/jpeg",
  "js": "application/javascript",
  "atom": "application/atom+xml",
  "rss": "application/rss+xml",
  "mml": "text/mathml",
  "txt": "text/plain",
  "text": "text/plain",
  "conf": "text/plain",
  "def": "text/plain",
  "log": "text/plain",
  "in": "text/plain",
  "csv": "text/csv",
  "jad": "text/vnd.sun.j2me.app-descriptor",
  "wml": "text/vnd.wap.wml",
  "htc": "text/x-component",
  "png": "image/png",
  "tif": "image/tiff",
  "tiff": "image/tiff",
  "wbmp": "image/vnd.wap.wbmp",
  "ico": "image/x-icon",
  "jng": "image/x-jng",
  "bmp": "image/x-ms-bmp",
  "svg": "image/svg+xml",
  "svgz": "image/svg+xml",
  "webp": "image/webp",
  "woff": "application/font-woff",
  "jar": "application/java-archive",
  "war": "application/java-archive",
  "ear": "application/java-archive",
  "json": "application/json",
  "hqx": "application/mac-binhex40",
  "doc": "application/msword",
  "pdf": "application/pdf",
  "ps": "application/postscript",
  "eps": "application/postscript",
  "ai": "application/postscript",
  "rtf": "application/rtf",
  "m3u8": "application/vnd.apple.mpegurl",
  "xls": "application/vnd.ms-excel",
  "eot": "application/vnd.ms-fontobject",
  "ppt": "application/vnd.ms-powerpoint",
  "wmlc": "application/vnd.wap.wmlc",
  "kml": "application/vnd.google-earth.kml+xml",
  "kmz": "application/vnd.google-earth.kmz",
  "7z": "application/x-7z-compressed",
  "cco": "application/x-cocoa",
  "jardiff": "application/x-java-archive-diff",
  "jnlp": "application/x-java-jnlp-file",
  "run": "application/x-makeself",
  "pl": "application/x-perl",
  "pm": "application/x-perl",
  "prc": "application/x-pilot",
  "pdb": "application/x-pilot",
  "rar": "application/x-rar-compressed",
  "rpm": "application/x-redhat-package-manager",
  "sea": "application/x-sea",
  "swf": "application/x-shockwave-flash",
  "sit": "application/x-stuffit",
  "tcl": "application/x-tcl",
  "tk": "application/x-tcl",
  "der": "application/x-x509-ca-cert",
  "pem": "application/x-x509-ca-cert",
  "crt": "application/x-x509-ca-cert",
  "xpi": "application/x-xpinstall",
  "xhtml": "application/xhtml+xml",
  "xspf": "application/xspf+xml",
  "zip": "application/zip",
  "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
  "mid": "audio/midi",
  "midi": "audio/midi",
  "kar": "audio/midi",
  "mp3": "audio/mpeg",
  "ogg": "audio/ogg",
  "m4a": "audio/x-m4a",
  "ra": "audio/x-realaudio",
  "3gpp": "video/3gpp",
  "3gp": "video/3gpp",
  "ts": "video/mp2t",
  "mp4": "video/mp4",
  "mpeg": "video/mpeg",
  "mpg": "video/mpeg",
  "mov": "video/quicktime",
  "webm": "video/webm",
  "flv": "video/x-flv",
  "m4v": "video/x-m4v",
  "mng": "video/x-mng",
  "asx": "video/x-ms-asf",
  "asf": "video/x-ms-asf",
  "wmv": "video/x-ms-wmv",
  "avi": "video/x-msvideo"
};
