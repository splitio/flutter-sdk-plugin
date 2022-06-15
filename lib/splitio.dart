import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/split_configuration.dart';

class Splitio {
  static const MethodChannel _channel = MethodChannel('splitio');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> initializeSplit(String apiKey, String matchingKey,
      [String? bucketingKey, SplitConfiguration? configuration]) async {
    await _channel.invokeMethod('init', {
      'apiKey': apiKey,
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'sdkConfiguration': configuration?.configurationMap ?? {},
    });
  }
}
