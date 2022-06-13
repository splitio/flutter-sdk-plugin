import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_configuration.dart';
import 'package:splitio/split_view.dart';

class Splitio {
  static const MethodChannel _channel = MethodChannel('splitio');

  final String _apiKey;
  final String _defaultMatchingKey;
  String? _defaultBucketingKey;
  SplitConfiguration? _splitConfiguration;

  Splitio(this._apiKey, this._defaultMatchingKey,
      {String? bucketingKey, SplitConfiguration? configuration}) {
    _defaultBucketingKey = bucketingKey;
    _splitConfiguration = configuration;
  }

  Future<void> init() async {
    Map<String, Object?> arguments = {
      'apiKey': _apiKey,
      'matchingKey': _defaultMatchingKey,
      'sdkConfiguration': _splitConfiguration?.configurationMap ?? {},
    };

    if (_defaultBucketingKey != null) {
      arguments.addAll({'bucketingKey': _defaultBucketingKey});
    }
    await _channel.invokeMethod('init', arguments);
  }

  Future<SplitClient> client(
      {String? matchingKey,
      String? bucketingKey,
      bool waitForReady = false}) async {
    String? key = matchingKey ?? _defaultMatchingKey;

    var arguments = {
      'matchingKey': key,
      'waitForReady': waitForReady,
    };

    if (bucketingKey != null) {
      arguments.addAll({'bucketingKey': bucketingKey});
    }

    final Map<String, dynamic>? result =
        await _channel.invokeMethod('getClient', arguments);

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
