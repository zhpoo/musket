import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../extensions/list_extension.dart';

/// 公共工具方法

/// 转换整型数字为字符串并用 0 补位
String toDigits(int value, [int digits = 2]) {
  return '$value'.padLeft(digits, '0');
  // if (value == null || digits < 2) return '$value';
  // int digitsOfZero = digits - '$value'.length;
  // String prefix = digitsOfZero > 0 ? '0' * digitsOfZero : '';
  // return '$prefix$value';
}

/// 判断是否是同一天，参数[day1] 与 [day2] 类型可以是[DataTime]或者时间戳毫秒值
bool isSameDay(dynamic day1, dynamic day2) {
  if (day1 is int) {
    day1 = DateTime.fromMillisecondsSinceEpoch(day1);
  }
  if (day2 is int) {
    day2 = DateTime.fromMillisecondsSinceEpoch(day2);
  }
  if (day1 is DateTime && day2 is DateTime) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }
  return false;
}

@Deprecated('use [formatTime] instead')
String parseTime(BuildContext context, int time, String languageCode, {String datePattern = 'yyyy-MM-dd HH:mm:ss'}) {
  return formatTime(time, datePattern, languageCode);
}

@Deprecated('use [formatDateTime] instead')
String parseDateTime(BuildContext context, DateTime dateTime, String languageCode,
    {String datePattern = 'yyyy-MM-dd HH:mm:ss'}) {
  var dateFormat = DateFormat(datePattern, languageCode);
  return dateFormat.format(dateTime);
}

String formatTime(int time, [String pattern = 'yyyy-MM-dd HH:mm:ss', String languageCode]) {
  if (time == null) {
    return '';
  }
  if ('$time'.length == 10) {
    time *= 1000;
  }
  var dateTime = DateTime.fromMillisecondsSinceEpoch(time);
  return formatDateTime(dateTime, pattern, languageCode);
}

String formatDateTime(DateTime dateTime, [String pattern = 'yyyy-MM-dd HH:mm:ss', String languageCode]) {
  return DateFormat(pattern, languageCode).format(dateTime);
}

String fixedAmount(num value, [int fractionDigits = 2]) {
  return formatAmount(value, fractionDigits, fractionDigits);
}

String formatAmount(num value, [int minDigits = 2, int maxDigits = 2]) {
  if (maxDigits < minDigits) maxDigits = minDigits;
  value ??= 0;
  if (maxDigits == 0) {
    value = value.floor();
  }
  var numberFormat = NumberFormat.decimalPattern()
    ..minimumFractionDigits = minDigits
    ..maximumFractionDigits = maxDigits;
  return numberFormat.format(value);
}

String durationToString(Duration duration) {
  if (duration == null || duration <= Duration.zero) return '00:00:00';
  String twoDigitsHours = toDigits(duration.inHours);
  String twoDigitMinutes = toDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  String twoDigitSeconds = toDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return '$twoDigitsHours:$twoDigitMinutes:$twoDigitSeconds';
}

final _zhRegExp = RegExp('[\u4e00-\u9fa5]');

bool matchChinese(String text) {
  return _zhRegExp.hasMatch(text);
}

/// 返回[text]中汉字的个数
int chineseCharactersCount(String text) {
  return _zhRegExp.allMatches(text)?.length ?? 0;
}

bool matchEmail(String email) {
  if (email?.isEmpty ?? true) return false;
  var regExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-_]+(\.[a-zA-Z0-9-_]+)*$');
  return regExp.hasMatch(email);
}

/// ETH address matcher
bool matchErc20(String address) {
  if (address?.isEmpty ?? true) return false;
  var regExp = RegExp(r'^0x[0-9a-fA-F]{40}$');
  return regExp.hasMatch(address);
}

bool matchBtc(String address) {
  if (address?.isEmpty ?? true) return false;
  var regExp = RegExp(r'^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$');
  return regExp.hasMatch(address);
}

void showKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.show');
}

void clearFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}

Widget wrapClearFocus(BuildContext context, {Widget child}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => clearFocus(context),
    child: child,
  );
}

void postFrameCallback(VoidCallback callback) {
  SchedulerBinding.instance.addPostFrameCallback((_) => callback());
}

List<T> map<E, T>(List<E> src, T indexMapper(E e, int index)) {
  return src?.mapIndex(indexMapper) ?? <T>[];
}

/// 随机 delay 一段时间，返回一个 Future
/// [max] 和 [min] 单位毫秒
Future<T> randomWait<T>({int min = 300, int max = 600, FutureOr<T> computation()}) {
  if (max <= min) max = min + 1;
  return Future<T>.delayed(Duration(milliseconds: Random().nextInt(max - min) + min), computation);
}
