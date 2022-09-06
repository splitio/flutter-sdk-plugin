import 'dart:async';

import 'package:splitio/split_client.dart';
import 'package:splitio_platform_interface/split_configuration.dart';
import 'package:splitio_platform_interface/split_impression.dart';
import 'package:splitio_platform_interface/split_view.dart';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

export 'package:splitio/split_client.dart';
export 'package:splitio_platform_interface/split_configuration.dart';
export 'package:splitio_platform_interface/split_impression.dart';
export 'package:splitio_platform_interface/split_view.dart';

typedef ClientReadinessCallback = void Function(SplitClient splitClient);

class Splitio {
  final String _apiKey;

  final String _defaultMatchingKey;

  late String? _defaultBucketingKey;

  late SplitConfiguration? _splitConfiguration;

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
    SplitioPlatform.instance
        .getClient(matchingKey: key, bucketingKey: bucketingKey);

    var client =
        DefaultSplitClient(SplitioPlatform.instance, key, bucketingKey);
    if (onReady != null) {
      SplitioPlatform.instance
          .onReady(matchingKey: key, bucketingKey: bucketingKey)
          ?.then((val) => onReady.call(client));
    }

    if (onReadyFromCache != null) {
      SplitioPlatform.instance
          .onReadyFromCache(matchingKey: key, bucketingKey: bucketingKey)
          ?.then((val) => onReadyFromCache.call(client));
    }

    if (onTimeout != null) {
      SplitioPlatform.instance
          .onTimeout(matchingKey: key, bucketingKey: bucketingKey)
          ?.then((val) => onTimeout.call(client));
    }

    if (onUpdated != null) {
      SplitioPlatform.instance
          .onUpdated(matchingKey: key, bucketingKey: bucketingKey)
          ?.listen((event) => onUpdated.call(client));
    }

    return client;
  }

  Future<List<String>> splitNames() async {
    List<String> splitNames = await SplitioPlatform.instance.splitNames();

    return splitNames;
  }

  Future<List<SplitView>> splits() async {
    return SplitioPlatform.instance.splits();
  }

  /// If the impressionListener configuration has been enabled,
  /// generated impressions will be streamed here.
  Stream<Impression> impressionsStream() {
    return SplitioPlatform.instance.impressionsStream();
  }

  Future<SplitView?> split(String splitName) async {
    return SplitioPlatform.instance.split(splitName: splitName);
  }

  Future<void> _init() {
    return SplitioPlatform.instance.init(
        apiKey: _apiKey,
        matchingKey: _defaultMatchingKey,
        bucketingKey: _defaultBucketingKey,
        sdkConfiguration: _splitConfiguration);
  }
}
