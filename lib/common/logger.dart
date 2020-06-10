import 'package:flutter/material.dart';

import 'package:musket/common/base_config.dart';

class Logger {
  static void log(object) {
    if (!BaseConfig.debug) {
      return;
    }
    debugPrint('$object');
  }
}
