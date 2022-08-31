import 'dart:async';

import 'package:splitio/channel/method_channel_manager.dart';
import 'package:splitio/impressions/impressions_method_call_handler.dart';
import 'package:splitio/impressions/split_impression.dart';
import 'package:splitio/method_call_handler.dart';
import 'package:splitio/platform/common_platform.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_configuration.dart';
import 'package:splitio/split_view.dart';

export 'package:splitio/impressions/split_impression.dart';
export 'package:splitio/split_client.dart';
export 'package:splitio/split_configuration.dart';
export 'package:splitio/split_result.dart';
export 'package:splitio/split_sync_config.dart';
export 'package:splitio/split_view.dart';

typedef ClientReadinessCallback = void Function(SplitClient splitClient);

class Splitio {
  final String _apiKey;

  final String _defaultMatchingKey;

  late final String? _defaultBucketingKey;

  late final SplitConfiguration? _splitConfiguration;

  late final StreamMethodCallHandler<Impression> _impressionsMethodCallHandler;

  final MethodChannelManager _methodChannelManager =
      MethodChannelManager(SplitioPlatform.instance);

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

    _methodChannelManager.getClient(
        matchingKey: key, bucketingKey: bucketingKey);

    return client;
  }

  Future<List<String>> splitNames() async {
    List<String> splitNames = await _methodChannelManager.splitNames(
        matchingKey: _defaultMatchingKey, bucketingKey: _defaultBucketingKey);

    return splitNames;
  }

  Future<List<SplitView>> splits() async {
    return _methodChannelManager.splits(
        matchingKey: _defaultMatchingKey, bucketingKey: _defaultBucketingKey);
  }

  /// If the impressionListener configuration has been enabled,
  /// generated impressions will be streamed here.
  Stream<Impression> impressionsStream() {
    return _impressionsMethodCallHandler.stream();
  }

  Future<SplitView?> split(String splitName) async {
    return _methodChannelManager.split(
        matchingKey: _defaultMatchingKey,
        bucketingKey: _defaultBucketingKey,
        splitName: splitName);
  }

  Future<void> _init() {
    return _methodChannelManager.init(
        apiKey: _apiKey,
        matchingKey: _defaultMatchingKey,
        bucketingKey: _defaultBucketingKey,
        sdkConfiguration: _splitConfiguration);
  }
}
