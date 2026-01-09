import 'dart:async';

import 'package:splitio/split_client.dart';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

export 'package:splitio/split_client.dart';
export 'package:splitio_platform_interface/split_configuration.dart';
export 'package:splitio_platform_interface/split_impression.dart';
export 'package:splitio_platform_interface/split_result.dart';
export 'package:splitio_platform_interface/split_sync_config.dart';
export 'package:splitio_platform_interface/split_view.dart';
export 'package:splitio_platform_interface/split_certificate_pinning_configuration.dart';
export 'package:splitio_platform_interface/split_evaluation_options.dart';
export 'package:splitio_platform_interface/split_rollout_cache_configuration.dart';

typedef ClientReadinessCallback = void Function(SplitClient splitClient);

class Splitio {
  final String _sdkKey;

  final String _defaultMatchingKey;

  late String? _defaultBucketingKey;

  late SplitConfiguration? _splitConfiguration;

  final SplitioPlatform _platform = SplitioPlatform.instance;

  /// SDK instance constructor.
  ///
  /// Use [_sdkKey] to specify your Split SDK key.
  ///
  /// Use [_defaultMatchingKey] to specify a default matching key. The default
  /// client will be associated with it.
  ///
  /// An optional [bucketingKey] can also be specified.
  ///
  /// Use the optional [configuration] parameter to fine tune configuration options.
  Splitio(this._sdkKey, this._defaultMatchingKey,
      {String? bucketingKey, SplitConfiguration? configuration}) {
    _defaultBucketingKey = bucketingKey;
    if (configuration != null) {
      _splitConfiguration = configuration;
    } else {
      _splitConfiguration = SplitConfiguration();
    }

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
  /// new feature flags or modifying segments.
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
    _platform.getClient(matchingKey: key, bucketingKey: bucketingKey);

    var client = DefaultSplitClient(_platform, key, bucketingKey);
    if (onReady != null) {
      _platform
          .onReady(matchingKey: key, bucketingKey: bucketingKey)
          ?.then((val) => onReady.call(client));
    }

    if (onReadyFromCache != null) {
      _platform
          .onReadyFromCache(matchingKey: key, bucketingKey: bucketingKey)
          ?.then((val) => onReadyFromCache.call(client));
    }

    if (onTimeout != null) {
      _platform
          .onTimeout(matchingKey: key, bucketingKey: bucketingKey)
          ?.then((val) => onTimeout.call(client));
    }

    if (onUpdated != null) {
      _platform
          .onUpdated(matchingKey: key, bucketingKey: bucketingKey)
          ?.listen((event) => onUpdated.call(client));
    }

    return client;
  }

  Future<List<String>> splitNames() async {
    List<String> splitNames = await _platform.splitNames();

    return splitNames;
  }

  Future<List<SplitView>> splits() async {
    return _platform.splits();
  }

  /// If the impressionListener configuration has been enabled,
  /// generated impressions will be streamed here.
  Stream<Impression> impressionsStream() {
    return _platform.impressionsStream();
  }

  Future<SplitView?> split(String splitName) async {
    return _platform.split(splitName: splitName);
  }

  Future<UserConsent> getUserConsent() async {
    return _platform.getUserConsent();
  }

  Future<void> setUserConsent(bool enabled) async {
    return _platform.setUserConsent(enabled);
  }

  Future<void> _init() {
    return _platform.init(
        apiKey: _sdkKey,
        matchingKey: _defaultMatchingKey,
        bucketingKey: _defaultBucketingKey,
        sdkConfiguration: _splitConfiguration);
  }
}
