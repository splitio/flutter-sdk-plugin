import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show Registrar;
import 'package:splitio_platform_interface/splitio_platform_interface.dart';
import 'package:splitio_web/src/js_interop.dart';
import 'package:web/web.dart';

extension on Window {
  @JS()
  external JS_BrowserSDKPackage? splitio;
}

/// Web implementation of [SplitioPlatform].
class SplitioWeb extends SplitioPlatform {
  /// Registers this class as the default platform implementation.
  static void registerWith(Registrar registrar) {
    SplitioPlatform.instance = SplitioWeb();
  }

  // Future to queue method calls until SDK is initialized
  Future<void>? _initFuture;

  late JS_IBrowserSDK _factory;
  String? _trafficType;
  bool _impressionListener = false;

  final Map<String, JS_IBrowserClient> _clients = {};

  @override
  Future<void> init({
    required String apiKey,
    required String matchingKey,
    required String? bucketingKey,
    SplitConfiguration? sdkConfiguration,
  }) async {
    if (_initFuture == null) {
      _initFuture = this._init(
          apiKey: apiKey,
          matchingKey: matchingKey,
          bucketingKey: bucketingKey,
          sdkConfiguration: sdkConfiguration);
    }
    return _initFuture;
  }

  Future<void> _init({
    required String apiKey,
    required String matchingKey,
    required String? bucketingKey,
    SplitConfiguration? sdkConfiguration,
  }) async {
    await _loadSplitSdk();

    final config =
        _buildConfig(apiKey, matchingKey, bucketingKey, sdkConfiguration);

    // Create factory instance
    this._factory = window.splitio!.SplitFactory.callAsFunction(null, config)
        as JS_IBrowserSDK;

    if (sdkConfiguration != null) {
      if (sdkConfiguration.configurationMap['trafficType'] is String) {
        this._trafficType = sdkConfiguration.configurationMap['trafficType'];
      }

      if (sdkConfiguration.configurationMap['impressionListener'] is bool) {
        this._impressionListener =
            sdkConfiguration.configurationMap['impressionListener'];
      }

      // Log warnings regarding unsupported configs. Not done in _buildConfig to reuse the factory logger
      final unsupportedConfigs = [
        'certificatePinningConfiguration',
        'encryptionEnabled',
        'eventsPerPush',
        'persistentAttributesEnabled'
      ];
      for (final configName in unsupportedConfigs) {
        if (sdkConfiguration.configurationMap[configName] != null) {
          this._factory.settings.log.warn.callAsFunction(
              this._factory.settings.log,
              'Config $configName is not supported by the Web package. This config will be ignored.'
                  .toJS);
        }
      }
    }

    return;
  }

  // Checks whether the Split Browser SDK was manually loaded (`window.splitio != null`).
  // If not, loads it by injecting a script tag.
  static Future<void> _loadSplitSdk() async {
    if (window.splitio != null) {
      return; // Already loaded
    }

    // Create and inject script tag
    final script = document.createElement('script') as HTMLScriptElement;
    script.type = 'text/javascript';
    script.src = 'packages/splitio_web/web/split-browser-1.6.0.full.min.js';

    // Wait for script to load
    final completer = Completer<void>();

    script.onload = (Event event) {
      completer.complete();
    }.toJS;

    script.onerror = (Event event) {
      completer.completeError(
          Exception('Failed to load Split SDK, with error: $event'));
    }.toJS;

    document.head!.appendChild(script);

    await completer.future;

    if (window.splitio == null) {
      throw Exception('Split Browser SDK failed to initialize after loading');
    }
  }

  // Map SplitConfiguration to JS equivalent object
  static JSObject _buildConfig(String apiKey, String matchingKey,
      String? bucketingKey, SplitConfiguration? configuration) {
    final config = JSObject();

    final core = JSObject();
    core.setProperty('authorizationKey'.toJS, apiKey.toJS);
    core.setProperty('key'.toJS, _buildKey(matchingKey, bucketingKey));
    config.setProperty('core'.toJS, core);

    if (configuration != null) {
      final scheduler = JSObject();
      if (configuration.configurationMap.containsKey('featuresRefreshRate'))
        scheduler.setProperty(
            'featuresRefreshRate'.toJS,
            (configuration.configurationMap['featuresRefreshRate'] as int)
                .toJS);
      if (configuration.configurationMap.containsKey('segmentsRefreshRate'))
        scheduler.setProperty(
            'segmentsRefreshRate'.toJS,
            (configuration.configurationMap['segmentsRefreshRate'] as int)
                .toJS);
      if (configuration.configurationMap.containsKey('impressionsRefreshRate'))
        scheduler.setProperty(
            'impressionsRefreshRate'.toJS,
            (configuration.configurationMap['impressionsRefreshRate'] as int)
                .toJS);
      if (configuration.configurationMap.containsKey('telemetryRefreshRate'))
        scheduler.setProperty(
            'telemetryRefreshRate'.toJS,
            (configuration.configurationMap['telemetryRefreshRate'] as int)
                .toJS);
      if (configuration.configurationMap.containsKey('eventsQueueSize'))
        scheduler.setProperty('eventsQueueSize'.toJS,
            (configuration.configurationMap['eventsQueueSize'] as int).toJS);
      if (configuration.configurationMap.containsKey('impressionsQueueSize'))
        scheduler.setProperty(
            'impressionsQueueSize'.toJS,
            (configuration.configurationMap['impressionsQueueSize'] as int)
                .toJS);
      if (configuration.configurationMap.containsKey('eventFlushInterval'))
        scheduler.setProperty('eventsPushRate'.toJS,
            (configuration.configurationMap['eventFlushInterval'] as int).toJS);
      config.setProperty('scheduler'.toJS, scheduler);

      if (configuration.configurationMap.containsKey('streamingEnabled'))
        config.setProperty('streamingEnabled'.toJS,
            (configuration.configurationMap['streamingEnabled'] as bool).toJS);

      final urls = JSObject();
      if (configuration.configurationMap.containsKey('sdkEndpoint'))
        urls.setProperty('sdk'.toJS,
            (configuration.configurationMap['sdkEndpoint'] as String).toJS);
      if (configuration.configurationMap.containsKey('eventsEndpoint'))
        urls.setProperty('events'.toJS,
            (configuration.configurationMap['eventsEndpoint'] as String).toJS);
      if (configuration.configurationMap.containsKey('authServiceEndpoint'))
        urls.setProperty(
            'auth'.toJS,
            (configuration.configurationMap['authServiceEndpoint'] as String)
                .toJS);
      if (configuration.configurationMap
          .containsKey('streamingServiceEndpoint'))
        urls.setProperty(
            'streaming'.toJS,
            (configuration.configurationMap['streamingServiceEndpoint']
                    as String)
                .toJS);
      if (configuration.configurationMap
          .containsKey('telemetryServiceEndpoint'))
        urls.setProperty(
            'telemetry'.toJS,
            (configuration.configurationMap['telemetryServiceEndpoint']
                    as String)
                .toJS);
      config.setProperty('urls'.toJS, urls);

      final sync = JSObject();
      if (configuration.configurationMap['impressionsMode'] != null) {
        sync.setProperty(
            'impressionsMode'.toJS,
            (configuration.configurationMap['impressionsMode'] as String)
                .toUpperCase()
                .toJS);
      }

      if (configuration.configurationMap['syncEnabled'] != null) {
        sync.setProperty('enabled'.toJS,
            (configuration.configurationMap['syncEnabled'] as bool).toJS);
      }

      if (configuration.configurationMap['syncConfig'] != null) {
        final syncConfig = configuration.configurationMap['syncConfig']
            as Map<String, List<String>>;
        final List<Map<String, dynamic>> splitFilters = [];

        if (syncConfig['syncConfigNames'] != null &&
            syncConfig['syncConfigNames']!.isNotEmpty) {
          splitFilters
              .add({'type': 'byName', 'values': syncConfig['syncConfigNames']});
        }

        if (syncConfig['syncConfigPrefixes'] != null &&
            syncConfig['syncConfigPrefixes']!.isNotEmpty) {
          splitFilters.add(
              {'type': 'byPrefix', 'values': syncConfig['syncConfigPrefixes']});
        }

        if (syncConfig['syncConfigFlagSets'] != null &&
            syncConfig['syncConfigFlagSets']!.isNotEmpty) {
          splitFilters.add(
              {'type': 'bySet', 'values': syncConfig['syncConfigFlagSets']});
        }
        sync.setProperty('splitFilters'.toJS, splitFilters.jsify());
      }
      config.setProperty('sync'.toJS, sync);

      if (configuration.configurationMap['userConsent'] != null) {
        config.setProperty(
            'userConsent'.toJS,
            (configuration.configurationMap['userConsent'] as String)
                .toUpperCase()
                .toJS);
      }

      final logLevel = configuration.configurationMap['logLevel'];
      if (logLevel is String) {
        final logger = logLevel == SplitLogLevel.verbose.toString() ||
                logLevel == SplitLogLevel.debug.toString()
            ? window.splitio!.DebugLogger?.callAsFunction(null)
            : logLevel == SplitLogLevel.info.toString()
                ? window.splitio!.InfoLogger?.callAsFunction(null)
                : logLevel == SplitLogLevel.warning.toString()
                    ? window.splitio!.WarnLogger?.callAsFunction(null)
                    : logLevel == SplitLogLevel.error.toString()
                        ? window.splitio!.ErrorLogger?.callAsFunction(null)
                        : null;
        if (logger != null) {
          config.setProperty('debug'.toJS, logger); // Browser SDK
        } else {
          config.setProperty(
              'debug'.toJS, logLevel.toUpperCase().toJS); // JS SDK
        }
      } else if (configuration.configurationMap['enableDebug'] == true) {
        config.setProperty(
            'debug'.toJS, window.splitio!.DebugLogger?.callAsFunction(null));
      }

      if (configuration.configurationMap['readyTimeout'] != null) {
        final startup = JSObject();
        startup.setProperty('readyTimeout'.toJS,
            (configuration.configurationMap['readyTimeout'] as int).toJS);
        config.setProperty('startup'.toJS, startup);
      }

      final storageOptions = JSObject();
      storageOptions.setProperty('type'.toJS, 'LOCALSTORAGE'.toJS);
      if (configuration.configurationMap['rolloutCacheConfiguration'] != null) {
        final rolloutCacheConfiguration =
            configuration.configurationMap['rolloutCacheConfiguration']
                as Map<String, dynamic>;
        if (rolloutCacheConfiguration['expirationDays'] != null) {
          storageOptions.setProperty('expirationDays'.toJS,
              (rolloutCacheConfiguration['expirationDays'] as int).toJS);
        }
        if (rolloutCacheConfiguration['clearOnInit'] != null) {
          storageOptions.setProperty('clearOnInit'.toJS,
              (rolloutCacheConfiguration['clearOnInit'] as bool).toJS);
        }
      }
      if (window.splitio!.InLocalStorage != null) {
        config.setProperty(
            'storage'.toJS,
            window.splitio!.InLocalStorage
                ?.callAsFunction(null, storageOptions)); // Browser SDK
      } else {
        config.setProperty('storage'.toJS, storageOptions); // JS SDK
      }
    }

    return config;
  }

  static JSAny _buildKey(String matchingKey, String? bucketingKey) {
    if (bucketingKey != null) {
      final splitKey = JSObject();
      splitKey.setProperty('matchingKey'.toJS, matchingKey.toJS);
      splitKey.setProperty('bucketingKey'.toJS, bucketingKey.toJS);
      return splitKey;
    }
    return matchingKey.toJS;
  }

  static String _buildKeyString(String matchingKey, String? bucketingKey) {
    return bucketingKey == null ? matchingKey : '${matchingKey}_$bucketingKey';
  }

  @override
  Future<void> getClient({
    required String matchingKey,
    required String? bucketingKey,
  }) async {
    await this._initFuture;

    final key = _buildKeyString(matchingKey, bucketingKey);

    if (_clients.containsKey(key)) {
      return;
    }

    final client = this._factory.client.callAsFunction(
        null, _buildKey(matchingKey, bucketingKey)) as JS_IBrowserClient;

    _clients[key] = client;
  }

  Future<JS_IBrowserClient> _getClient({
    required String matchingKey,
    required String? bucketingKey,
  }) async {
    await getClient(matchingKey: matchingKey, bucketingKey: bucketingKey);

    final key = _buildKeyString(matchingKey, bucketingKey);

    return _clients[key]!;
  }

  JSAny? _convertValue(dynamic value, bool isAttribute) {
    if (value is bool) return value.toJS;
    if (value is num) return value.toJS; // covers int + double
    if (value is String) return value.toJS;

    // properties do not support lists and sets
    if (isAttribute) {
      if (value is List) return value.jsify();
      if (value is Set) return value.jsify();
    }

    return null;
  }

  JSObject _convertMap(Map<String, dynamic> dartMap, bool isAttribute) {
    final jsMap = JSObject();

    dartMap.forEach((key, value) {
      final jsValue = _convertValue(value, isAttribute);

      if (jsValue != null) {
        jsMap.setProperty(key.toJS, jsValue);
      } else {
        this._factory.settings.log.warn.callAsFunction(
            null,
            'Invalid ${isAttribute ? 'attribute' : 'property'} value: $value, for key: $key, will be ignored'
                .toJS);
      }
    });

    return jsMap;
  }

  JSObject _convertEvaluationOptions(EvaluationOptions evaluationOptions) {
    final jsEvalOptions = JSObject();

    if (evaluationOptions.properties.isNotEmpty) {
      jsEvalOptions.setProperty(
          'properties'.toJS, _convertMap(evaluationOptions.properties, false));
    }

    return jsEvalOptions;
  }

  @override
  Future<String> getTreatment({
    required String matchingKey,
    required String? bucketingKey,
    required String splitName,
    Map<String, dynamic> attributes = const {},
    EvaluationOptions evaluationOptions = const EvaluationOptions.empty(),
  }) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getTreatment.callAsFunction(
        null,
        splitName.toJS,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions)) as JSString;

    return result.toDart;
  }

  @override
  Future<Map<String, String>> getTreatments({
    required String matchingKey,
    required String? bucketingKey,
    required List<String> splitNames,
    Map<String, dynamic> attributes = const {},
    EvaluationOptions evaluationOptions = const EvaluationOptions.empty(),
  }) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getTreatments.callAsFunction(
        null,
        splitNames.jsify(),
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions)) as JSObject;

    return jsTreatmentsToMap(result);
  }

  @override
  Future<SplitResult> getTreatmentWithConfig({
    required String matchingKey,
    required String? bucketingKey,
    required String splitName,
    Map<String, dynamic> attributes = const {},
    EvaluationOptions evaluationOptions = const EvaluationOptions.empty(),
  }) async {
    await this._initFuture;
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getTreatmentWithConfig.callAsFunction(
        null,
        splitName.toJS,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions)) as JSObject;

    return jsTreatmentWithConfigToSplitResult(result);
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfig({
    required String matchingKey,
    required String? bucketingKey,
    required List<String> splitNames,
    Map<String, dynamic> attributes = const {},
    EvaluationOptions evaluationOptions = const EvaluationOptions.empty(),
  }) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getTreatmentsWithConfig.callAsFunction(
        null,
        splitNames.jsify(),
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions)) as JSObject;

    return jsTreatmentsWithConfigToMap(result);
  }

  @override
  Future<Map<String, String>> getTreatmentsByFlagSet(
      {required String matchingKey,
      required String? bucketingKey,
      required String flagSet,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions =
          const EvaluationOptions.empty()}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getTreatmentsByFlagSet.callAsFunction(
        null,
        flagSet.toJS,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions)) as JSObject;

    return jsTreatmentsToMap(result);
  }

  @override
  Future<Map<String, String>> getTreatmentsByFlagSets(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> flagSets,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions =
          const EvaluationOptions.empty()}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getTreatmentsByFlagSets.callAsFunction(
        null,
        flagSets.jsify(),
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions)) as JSObject;

    return jsTreatmentsToMap(result);
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfigByFlagSet(
      {required String matchingKey,
      required String? bucketingKey,
      required String flagSet,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions =
          const EvaluationOptions.empty()}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getTreatmentsWithConfigByFlagSet.callAsFunction(
        null,
        flagSet.toJS,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions)) as JSObject;

    return jsTreatmentsWithConfigToMap(result);
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfigByFlagSets(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> flagSets,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions =
          const EvaluationOptions.empty()}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getTreatmentsWithConfigByFlagSets.callAsFunction(
        null,
        flagSets.jsify(),
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions)) as JSObject;

    return jsTreatmentsWithConfigToMap(result);
  }

  @override
  Future<bool> track(
      {required String matchingKey,
      required String? bucketingKey,
      required String eventType,
      String? trafficType,
      double? value,
      Map<String, dynamic> properties = const {}}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.track.callAsFunction(
        null,
        trafficType != null
            ? trafficType.toJS
            : this._trafficType != null
                ? this._trafficType!.toJS
                : null,
        eventType.toJS,
        value != null ? value.toJS : null,
        _convertMap(properties, false)) as JSBoolean;

    return result.toDart;
  }

  @override
  Future<Map<String, dynamic>> getAllAttributes(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getAttributes.callAsFunction(null) as JSObject;

    return jsObjectToMap(result);
  }

  @override
  Future<bool> setAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName,
      required dynamic value}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.setAttribute.callAsFunction(
        null, attributeName.toJS, _convertValue(value, true)) as JSBoolean;

    return result.toDart;
  }

  @override
  Future<bool> setAttributes(
      {required String matchingKey,
      required String? bucketingKey,
      required Map<String, dynamic> attributes}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.setAttributes
        .callAsFunction(null, _convertMap(attributes, true)) as JSBoolean;

    return result.toDart;
  }

  @override
  Future<dynamic> getAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getAttribute.callAsFunction(null, attributeName.toJS);

    return jsAnyToDart(result);
  }

  @override
  Future<bool> removeAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.removeAttribute
        .callAsFunction(null, attributeName.toJS) as JSBoolean;

    return result.toDart;
  }

  @override
  Future<bool> clearAttributes(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.clearAttributes.callAsFunction(null) as JSBoolean;

    return result.toDart;
  }

  @override
  Future<void> flush(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.flush.callAsFunction(null) as JSPromise<Null>;

    return result.toDart;
  }

  @override
  Future<void> destroy(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.destroy.callAsFunction(null) as JSPromise<Null>;

    return result.toDart;
  }

  @override
  Future<UserConsent> getUserConsent() async {
    await this._initFuture;

    final userConsentStatus =
        _factory.UserConsent.getStatus.callAsFunction(null) as JSString;

    switch (userConsentStatus.toDart) {
      case 'GRANTED':
        return UserConsent.granted;
      case 'DECLINED':
        return UserConsent.declined;
      default:
        return UserConsent.unknown;
    }
  }

  @override
  Future<void> setUserConsent(bool enabled) async {
    await this._initFuture;

    _factory.UserConsent.setStatus.callAsFunction(null, enabled.toJS);
  }
}
