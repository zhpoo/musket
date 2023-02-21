import 'dart:convert';

import 'package:dio/dio.dart';

/// [LogInterceptorPlus] is used to print logs during network requests.
/// It's better to add [LogInterceptorPlus] to the tail of the interceptor queue,
/// otherwise the changes made in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.
class LogInterceptorPlus extends Interceptor {
  LogInterceptorPlus({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.error = true,
    this.logPrint = print,
  });

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogInterceptor(buffer.writeln: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  StringBuffer logBuffer(RequestOptions options) {
    options.extra['logBuffer'] ??= StringBuffer();
    return options.extra['logBuffer'];
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var buffer = logBuffer(options);

    buffer.writeln('[Http ${options.method}] ${Uri.decodeFull(options.uri.toString())}');

    if (request) {
      _printKV('responseType', options.responseType.toString(), buffer);
      _printKV('followRedirects', options.followRedirects, buffer);
      _printKV('connectTimeout', options.connectTimeout, buffer);
      _printKV('sendTimeout', options.sendTimeout, buffer);
      _printKV('receiveTimeout', options.receiveTimeout, buffer);
      _printKV('receiveDataWhenStatusError', options.receiveDataWhenStatusError, buffer);
      options.extra.remove('logBuffer');
      _printKV('extra', options.extra, buffer);
      options.extra['logBuffer'] = buffer;
    }
    if (requestHeader) {
      buffer.writeln('[Request Headers]:');
      options.headers.forEach((key, v) => _printKV(' $key', v.join('\r\n\t'), buffer));
    }
    if (requestBody) {
      buffer.writeln('[Request Data]:');
      buffer.writeln(_toJson(options.data));
    }
    options.extra['logStartTime'] = DateTime.now();

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    var buffer = logBuffer(response.requestOptions);
    buffer.writeln('[Http Response]');
    _printResponse(response, buffer);
    _printEnd(response.requestOptions);

    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    var buffer = logBuffer(err.requestOptions);
    if (error) {
      buffer.writeln('[Request Error]:');
      buffer.writeln('$err');
      if (err.response != null) {
        _printResponse(err.response!, buffer);
      }
    }
    _printEnd(err.requestOptions);

    handler.next(err);
  }

  void _printResponse(Response response, StringBuffer buffer) {
    if (responseHeader) {
      _printKV('statusCode', response.statusCode, buffer);
      if (response.isRedirect == true) {
        _printKV('redirect', response.realUri, buffer);
      }

      buffer.writeln('[Response Headers]:');
      response.headers.forEach((key, v) => _printKV(' $key', v.join('\r\n\t'), buffer));
    }
    if (responseBody) {
      buffer.writeln('[Response Data]:');
      switch (response.requestOptions.responseType) {
        case ResponseType.json:
          buffer.writeln(_toJson(response.data));
          break;
        case ResponseType.stream:
          buffer.writeln('(stream omitted)');
          break;
        case ResponseType.plain:
          buffer.writeln(response);
          break;
        case ResponseType.bytes:
          buffer.writeln('(bytes omitted)');
          break;
      }
    }
  }

  void _printEnd(RequestOptions options) {
    var buffer = logBuffer(options);
    var url = Uri.decodeFull(options.uri.toString());
    var costTime = DateTime.now().difference(options.extra['logStartTime']).inMilliseconds;
    buffer.writeln('[End Http][${costTime}ms] $url');

    logPrint(buffer);

    options.extra.remove('logBuffer');
    options.extra.remove('logStartTime');
  }

  void _printKV(String key, Object? v, StringBuffer buffer) {
    buffer.writeln('$key: $v');
  }

  String _toJson(data) {
    return '${const JsonEncoder.withIndent(' ').convert(data)}';
  }
}
