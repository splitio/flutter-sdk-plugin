
import 'dart:async';

import 'package:flutter/services.dart';

class Splitio {
  static const MethodChannel _channel = MethodChannel('splitio');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
