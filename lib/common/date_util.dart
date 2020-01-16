import 'package:musket/common/utils.dart';

bool isToday(int time) {
  if (time == null) {
    return false;
  }
  if ('$time'.length == 10) {
    time *= 1000;
  }
  return isSameDay(time, DateTime.now());
}

bool isYesterday(int time) {
  if (time == null) {
    return false;
  }
  if ('$time'.length == 10) {
    time *= 1000;
  }
  return isSameDay(time, DateTime.now().subtract(Duration(days: 1)));
}

bool isBeforeYesterday(int time) {
  if (time == null) {
    return true;
  }
  if ('$time'.length == 10) {
    // time is in seconds.
    time *= 1000;
  }
  var date = DateTime.fromMillisecondsSinceEpoch(time);
  var yesterdayNow = DateTime.now().subtract(Duration(days: 1));
  var yesterday = DateTime(yesterdayNow.year, yesterdayNow.month, yesterdayNow.day);
  return date.isBefore(yesterday);
}
