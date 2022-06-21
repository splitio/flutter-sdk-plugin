import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_configuration.dart';
import 'package:splitio/split_view.dart';

typedef ClientReadinessCallback = void Function(SplitClient splitClient);
typedef CancelListening = void Function();

class Splitio {
  static const MethodChannel _channel = MethodChannel('splitio');

  final String _apiKey;
  final String _defaultMatchingKey;
  String? _defaultBucketingKey;
  SplitConfiguration? _splitConfiguration;
  final Map<String, ClientReadinessCallback?> _clientReadyCallbacks = {};

  Splitio(this._apiKey, this._defaultMatchingKey,
      {String? bucketingKey, SplitConfiguration? configuration}) {
    _defaultBucketingKey = bucketingKey;
    _splitConfiguration = configuration;

    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method == 'clientReady') {
      var matchingKey = call.arguments['matchingKey'];
      var bucketingKey = call.arguments['bucketingKey'] ?? 'null';
      String key = _buildKeyForCallbackMap(matchingKey, bucketingKey);

      if (_clientReadyCallbacks.containsKey(key)) {
        _clientReadyCallbacks[key]
            ?.call(SplitClient(matchingKey, bucketingKey));
      }
    }
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
    return _channel.invokeMethod('init', arguments);
  }

  Future<void> client(ClientReadinessCallback callback,
      {String? matchingKey,
      String? bucketingKey,
      bool waitForReady = false}) async {
    String? key = matchingKey ?? _defaultMatchingKey;

    _clientReadyCallbacks[_buildKeyForCallbackMap(key, bucketingKey)] =
        callback;

    var arguments = {
      'matchingKey': key,
      'waitForReady': waitForReady,
    };

    if (bucketingKey != null) {
      arguments.addAll({'bucketingKey': bucketingKey});
    }

    return _channel.invokeMethod('getClient', arguments);
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

  _buildKeyForCallbackMap(String matchingKey, String? bucketingKey) {
    return matchingKey + '_' + (bucketingKey ?? 'null');
  }
}
