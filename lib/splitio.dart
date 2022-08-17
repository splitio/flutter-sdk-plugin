import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/channel/method_channel_manager.dart';
import 'package:splitio/impressions/impressions_method_call_handler.dart';
import 'package:splitio/impressions/split_impression.dart';
import 'package:splitio/method_call_handler.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_configuration.dart';
import 'package:splitio/split_view.dart';

export 'package:splitio/impressions/split_impression.dart';
export 'package:splitio/split_client.dart';
export 'package:splitio/split_configuration.dart';
export 'package:splitio/split_result.dart';
export 'package:splitio/split_view.dart';

typedef ClientReadinessCallback = void Function(SplitClient splitClient);

class Splitio {
  final String _apiKey;
  final String _defaultMatchingKey;
  late final String? _defaultBucketingKey;
  late final SplitConfiguration? _splitConfiguration;
  late final StreamMethodCallHandler<Impression> _impressionsMethodCallHandler;
  final MethodChannelManager _methodChannelManager =
      MethodChannelManager(const MethodChannel('splitio'));

  /// SDK instance constructor.
  ///
  /// Use [_apiKey] to specify your Split API key.
  ///
  /// Use [_defaultMatchingKey] to specify a default matching key. The default
  /// client will be associated with it.
  ///
  /// An optional [bucketingKey] can also be specified.
  ///
  /// Use the optional [configuration] parameter to fine tune configuration options.
  Splitio(this._apiKey, this._defaultMatchingKey,
      {String? bucketingKey, SplitConfiguration? configuration}) {
    _defaultBucketingKey = bucketingKey;
    _splitConfiguration = configuration;
    _impressionsMethodCallHandler = ImpressionsMethodCallHandler();
    _methodChannelManager.addHandler(_impressionsMethodCallHandler);

    _init();
  }

  /// Gets a [SplitClient] to interact with the SDK.
  ///
  /// Optionally provide a [matchingKey], otherwise the key used when creating
  /// the SDK instance will be used.
  ///
  /// An optional [bucketingKey] can also be specified.
  ///
  /// While this method returns a valid [SplitClient] object, it may not be
  /// initialized right away. To listen for specific client readiness events,
  /// the optional callback parameters can be used:
  ///
  /// [onReady] is executed when the most up-to-date information has been
  /// retrieved from the Split cloud.
  ///
  /// [onReadyFromCache] is executed once the SDK has been able to load
  /// definitions from cache. This information is not guaranteed to be the most
  /// up-to-date, but all the functionality will be available.
  ///
  /// [onUpdated] is executed when changes have been made, such as creating
  /// new splits or modifying segments.
  ///
  /// [onTimeout] is executed if the SDK has not been able to get ready in time.
  SplitClient client(
      {String? matchingKey,
      String? bucketingKey,
      ClientReadinessCallback? onReady,
      ClientReadinessCallback? onReadyFromCache,
      ClientReadinessCallback? onUpdated,
      ClientReadinessCallback? onTimeout}) {
    String? key = matchingKey ?? _defaultMatchingKey;

    var client = DefaultSplitClient(_methodChannelManager, key, bucketingKey);
    if (onReady != null) {
      client.whenReady().then((client) => onReady.call(client));
    }

    if (onReadyFromCache != null) {
      client
          .whenReadyFromCache()
          .then((client) => onReadyFromCache.call(client));
    }

    if (onTimeout != null) {
      client.whenTimeout().then((client) => onTimeout.call(client));
    }

    if (onUpdated != null) {
      client.whenUpdated().listen((client) => onUpdated.call(client));
    }

    _methodChannelManager.invokeMethod(
        'getClient', _buildGetClientArguments(key, bucketingKey));

    return client;
  }

  Future<List<String>> splitNames() async {
    List<String> splitNames =
        await _methodChannelManager.invokeListMethod<String>('splitNames') ??
            [];

    return splitNames;
  }

  Future<List<SplitView>> splits() async {
    List<Map> callResult = (await _methodChannelManager
            .invokeListMethod<Map<dynamic, dynamic>>('splits') ??
        []);

    List<SplitView> splits = [];
    for (var element in callResult) {
      SplitView? splitView = SplitView.fromEntry(element);
      if (splitView != null) {
        splits.add(splitView);
      }
    }

    return Future.value(splits);
  }

  /// If the impressionListener configuration has been enabled,
  /// generated impressions will be streamed here.
  Stream<Impression> impressionsStream() {
    return _impressionsMethodCallHandler.stream();
  }

  Future<SplitView?> split(String splitName) async {
    Map? mapResult = await _methodChannelManager
        .invokeMapMethod('split', {'splitName': splitName});

    if (mapResult == null) {
      return null;
    }

    return SplitView.fromEntry(mapResult);
  }

  Future<void> _init() {
    Map<String, Object?> arguments = {
      'apiKey': _apiKey,
      'matchingKey': _defaultMatchingKey,
      'sdkConfiguration': _splitConfiguration?.configurationMap ?? {},
    };

    if (_defaultBucketingKey != null) {
      arguments.addAll({'bucketingKey': _defaultBucketingKey});
    }

    return _methodChannelManager.invokeMethod('init', arguments);
  }

  Map<String, Object> _buildGetClientArguments(
      String key, String? bucketingKey) {
    var arguments = {
      'matchingKey': key,
    };

    if (bucketingKey != null) {
      arguments.addAll({'bucketingKey': bucketingKey});
    }

    return arguments;
  }
}
