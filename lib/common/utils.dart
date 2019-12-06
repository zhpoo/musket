import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// 公共工具方法

/// 转换整型数字为字符串并用 0 补位
String toDigits(int value, [int digits = 2]) {
  if (value == null || digits < 2) return '$value';
  int digitsOfZero = digits - '$value'.length;
  String prefix = digitsOfZero > 0 ? '0' * digitsOfZero : '';
  return '$prefix$value';
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

String parseTime(BuildContext context, int time, String languageCode,
    {String datePattern = 'yyyy-MM-dd HH:mm:ss'}) {
  if ('$time'.length == 10) {
    time *= 1000;
  }

  var dateTime = DateTime.fromMillisecondsSinceEpoch(time);
  return parseDateTime(context, dateTime, languageCode, datePattern: datePattern);
}

String parseDateTime(BuildContext context, DateTime dateTime, String languageCode,
    {String datePattern = 'yyyy-MM-dd HH:mm:ss'}) {
  var dateFormat = DateFormat(datePattern, languageCode);
  return dateFormat.format(dateTime);
}

String fixedAmount(num value, [int fractionDigits = 2]) {
  return '${(value ?? 0).toStringAsFixed(fractionDigits)}';
}

String durationToString(Duration duration) {
  if (duration == null) return '00:00:00';
  String twoDigitsHours = toDigits(duration.inHours);
  String twoDigitMinutes = toDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  String twoDigitSeconds = toDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return '$twoDigitsHours:$twoDigitMinutes:$twoDigitSeconds';
}
