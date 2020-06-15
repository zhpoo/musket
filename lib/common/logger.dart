import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:musket/common/base_config.dart';

class Logger {
  /// 设置是否默认使用[developer.log]来打印日志，[false]将默认使用 Flutter 的[debugPrint]来打印日志。
  /// 默认值为[true].
  static bool defaultUseDartLog = true;

  /// [useDartLog]:是否使用[developer.log]来打印日志，[false]将使用 Flutter 的[debugPrint]来打印日志
  /// [breakLength]:作为[debugPrint]的参数.
  static void log(object, {bool useDartLog, int breakLength = 1024 * 3}) {
    if (!BaseConfig.debug) {
      return;
    }
    if (useDartLog ?? defaultUseDartLog ?? true) {
      developer.log('$object');
    } else {
      debugPrint('$object', wrapWidth: breakLength);
    }
  }
}
