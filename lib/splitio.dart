import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_configuration.dart';
import 'package:splitio/split_view.dart';

class Splitio {
  static const MethodChannel _channel = MethodChannel('splitio');

  String? _defaultMatchingKey;

  Future<void> init(String apiKey, String matchingKey,
      {String? bucketingKey, SplitConfiguration? configuration}) async {
    _defaultMatchingKey = matchingKey;

    var arguments = {
      'apiKey': apiKey,
      'matchingKey': matchingKey,
      'sdkConfiguration': configuration?.configurationMap ?? {},
    };

    if (bucketingKey != null) {
      arguments.addAll({'bucketingKey': bucketingKey});
    }
    await _channel.invokeMethod('init', arguments);
  }

  Future<SplitClient?> client(
      {String? matchingKey,
      String? bucketingKey,
      bool waitForReady = false}) async {
    String? key = matchingKey ?? _defaultMatchingKey;
    if (key == null) {
      return null;
    }

    var arguments = {
      'matchingKey': key,
      'waitForReady': waitForReady,
    };

    if (bucketingKey != null) {
      arguments.addAll({'bucketingKey': bucketingKey});
    }

    final Map<String, dynamic>? result =
        await _channel.invokeMethod('getClient', arguments);
    if (result == null) {
      return null;
    }

    return SplitClient(key, bucketingKey);
  }

  Future<List<SplitView>> splits() async {
    List<SplitView> list = [];
    await _channel.invokeMethod('splits').then((value) {});
    return list; //TODO
  }

  Future<SplitView?> split(String featureName) async {
    return _channel
        .invokeMethod('split', {'featureName': featureName}).then((value) {
      return null; //TODO
    });
  }

  Future<List<String>> splitNames() async {
    return _channel.invokeMethod('splitNames').then((value) {
      return []; //TODO
    });
  }
}
