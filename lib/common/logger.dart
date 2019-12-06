import 'dart:developer' as developer;

import 'package:musket/common/base_config.dart';


class Logger {
  static void log(object) {
    if (!BaseConfig.debug) {
      return;
    }
    developer.log('$object');
  }
}
