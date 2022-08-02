import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_configuration.dart';
import 'package:splitio/split_native_method_parser.dart';

export 'package:splitio/split_client.dart';
export 'package:splitio/split_configuration.dart';
export 'package:splitio/split_result.dart';

typedef ClientReadinessCallback = void Function(SplitClient splitClient);

class Splitio {
  static const MethodChannel _channel = MethodChannel('splitio');

  final String _apiKey;
  final String _defaultMatchingKey;
  late final String? _defaultBucketingKey;
  late final SplitConfiguration? _splitConfiguration;
  late final SplitEventCallbackManagerImpl _nativeMethodParser;

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
    _nativeMethodParser = SplitEventCallbackManagerImpl();

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
  SplitClient client({String? matchingKey, String? bucketingKey}) {
    String? key = matchingKey ?? _defaultMatchingKey;

    _channel.invokeMethod(
        'getClient', _buildGetClientArguments(key, bucketingKey));

    return SplitClient(key, bucketingKey, _nativeMethodParser);
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
    return _channel.invokeMethod('init', arguments);
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
