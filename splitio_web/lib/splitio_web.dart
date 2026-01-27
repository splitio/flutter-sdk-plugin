import 'dart:async';
import 'dart:js_interop';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show Registrar;
import 'package:splitio_platform_interface/splitio_platform_interface.dart';
import 'package:splitio_web/src/js_interop.dart';
import 'package:web/web.dart';

extension on Window {
  @JS()
  external JSBrowserSDKPackage? splitio;
}

/// Web implementation of [SplitioPlatform].
class SplitioWeb extends SplitioPlatform {
  /// Registers this class as the default platform implementation.
  static void registerWith(Registrar registrar) {
    SplitioPlatform.instance = SplitioWeb();
  }

  // Future to queue method calls until SDK is initialized
  Future<void>? _initFuture;

  late JSIBrowserSDK _factory;
  String? _trafficType;
  // Broadcast to allow users to subscribe multiple listeners
  final StreamController<Impression> _impressionsStreamController =
      StreamController<Impression>.broadcast();

  final Map<String, JSIBrowserClient> _clients = {};

  @override
  Future<void> init({
    required String apiKey,
    required String matchingKey,
    required String? bucketingKey,
    SplitConfiguration? sdkConfiguration,
  }) {
    return _initFuture ??= _init(
        apiKey: apiKey,
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
        sdkConfiguration: sdkConfiguration);
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
    _factory = window.splitio!.SplitFactory(config);

    if (sdkConfiguration != null) {
      if (sdkConfiguration.configurationMap['trafficType'] is String) {
        _trafficType = sdkConfiguration.configurationMap['trafficType'];
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
          _factory.settings.log.warn(
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
      return; // Already loaded. JS SDK should not be manually loaded because `splitio.SplitFactory` is not available.
    }

    // Create and inject script tag
    final script = document.createElement('script') as HTMLScriptElement;
    script.type = 'text/javascript';
    script.src =
        'assets/packages/splitio_web/web/split-browser-1.6.0.full.min.js';

    // Wait for script to load
    final completer = Completer<void>();

    script.onload = (Event event) {
      completer.complete();
    }.toJS;

    script.onerror = (Event event) {
      completer.completeError(
          Exception('Failed to load Split Browser SDK, with error: $event'));
    }.toJS;

    document.head!.appendChild(script);

    await completer.future;

    if (window.splitio == null) {
      throw Exception('Split Browser SDK failed to initialize after loading');
    }
  }

  // Map SplitConfiguration to JS equivalent object
  JSConfiguration _buildConfig(String apiKey, String matchingKey,
      String? bucketingKey, SplitConfiguration? configuration) {
    final config = JSObject() as JSConfiguration;

    final core = JSObject() as JSConfigurationCore;
    core.authorizationKey = apiKey.toJS;
    core.key = buildJsKey(matchingKey, bucketingKey);
    config.core = core;

    if (configuration != null) {
      final scheduler = JSObject() as JSConfigurationScheduler;
      if (configuration.configurationMap.containsKey('featuresRefreshRate')) {
        scheduler.featuresRefreshRate =
            (configuration.configurationMap['featuresRefreshRate'] as int).toJS;
      }
      if (configuration.configurationMap.containsKey('segmentsRefreshRate')) {
        scheduler.segmentsRefreshRate =
            (configuration.configurationMap['segmentsRefreshRate'] as int).toJS;
      }
      if (configuration.configurationMap
          .containsKey('impressionsRefreshRate')) {
        scheduler.impressionsRefreshRate =
            (configuration.configurationMap['impressionsRefreshRate'] as int)
                .toJS;
      }
      if (configuration.configurationMap.containsKey('telemetryRefreshRate')) {
        scheduler.telemetryRefreshRate =
            (configuration.configurationMap['telemetryRefreshRate'] as int)
                .toJS;
      }
      if (configuration.configurationMap.containsKey('eventsQueueSize')) {
        scheduler.eventsQueueSize =
            (configuration.configurationMap['eventsQueueSize'] as int).toJS;
      }
      if (configuration.configurationMap.containsKey('impressionsQueueSize')) {
        scheduler.impressionsQueueSize =
            (configuration.configurationMap['impressionsQueueSize'] as int)
                .toJS;
      }
      if (configuration.configurationMap.containsKey('eventFlushInterval')) {
        scheduler.eventsPushRate =
            (configuration.configurationMap['eventFlushInterval'] as int).toJS;
      }
      config.scheduler = scheduler;

      if (configuration.configurationMap.containsKey('streamingEnabled')) {
        config.streamingEnabled =
            (configuration.configurationMap['streamingEnabled'] as bool).toJS;
      }

      final urls = JSObject() as JSConfigurationUrls;
      if (configuration.configurationMap.containsKey('sdkEndpoint')) {
        urls.sdk =
            (configuration.configurationMap['sdkEndpoint'] as String).toJS;
      }
      if (configuration.configurationMap.containsKey('eventsEndpoint')) {
        urls.events =
            (configuration.configurationMap['eventsEndpoint'] as String).toJS;
      }

      // Convert urls for consistency between Browser SDK and Android/iOS SDK
      if (configuration.configurationMap.containsKey('authServiceEndpoint')) {
        final auth =
            configuration.configurationMap['authServiceEndpoint'] as String;
        final jsAuth =
            auth.endsWith('/v2') ? auth.substring(0, auth.length - 3) : auth;
        urls.auth = jsAuth.toJS;
      }
      if (configuration.configurationMap
          .containsKey('streamingServiceEndpoint')) {
        final streaming = configuration
            .configurationMap['streamingServiceEndpoint'] as String;
        final jsStreaming = streaming.endsWith('/sse')
            ? streaming.substring(0, streaming.length - 4)
            : streaming;
        urls.streaming = jsStreaming.toJS;
      }
      if (configuration.configurationMap
          .containsKey('telemetryServiceEndpoint')) {
        final telemetry = configuration
            .configurationMap['telemetryServiceEndpoint'] as String;
        final jsTelemetry = telemetry.endsWith('/v1')
            ? telemetry.substring(0, telemetry.length - 3)
            : telemetry;
        urls.telemetry = jsTelemetry.toJS;
      }
      config.urls = urls;

      final sync = JSObject() as JSConfigurationSync;
      if (configuration.configurationMap['impressionsMode'] != null) {
        sync.impressionsMode =
            (configuration.configurationMap['impressionsMode'] as String)
                .toUpperCase()
                .toJS;
      }

      if (configuration.configurationMap['syncEnabled'] != null) {
        sync.enabled =
            (configuration.configurationMap['syncEnabled'] as bool).toJS;
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
        sync.splitFilters = splitFilters.jsify() as JSArray<JSSplitFilter>;
      }
      config.sync = sync;

      if (configuration.configurationMap['userConsent'] != null) {
        config.userConsent =
            (configuration.configurationMap['userConsent'] as String)
                .toUpperCase()
                .toJS;
      }

      final logLevel = configuration.configurationMap['logLevel'];
      if (logLevel is String) {
        switch (SplitLogLevel.values.firstWhere((e) => e.name == logLevel)) {
          case SplitLogLevel.verbose:
          case SplitLogLevel.debug:
            config.debug = window.splitio!.DebugLogger != null
                ? window.splitio!.DebugLogger!()
                : 'DEBUG'.toJS;
            break;
          case SplitLogLevel.info:
            config.debug = window.splitio!.InfoLogger != null
                ? window.splitio!.InfoLogger!()
                : 'INFO'.toJS;
            break;
          case SplitLogLevel.warning:
            config.debug = window.splitio!.WarnLogger != null
                ? window.splitio!.WarnLogger!()
                : 'WARNING'.toJS;
            break;
          case SplitLogLevel.error:
            config.debug = window.splitio!.ErrorLogger != null
                ? window.splitio!.ErrorLogger!()
                : 'ERROR'.toJS;
            break;
          default:
            break;
        }
      } else if (configuration.configurationMap['enableDebug'] == true) {
        config.debug = window.splitio!.DebugLogger != null
            ? window.splitio!.DebugLogger!()
            : 'DEBUG'.toJS;
      }

      if (configuration.configurationMap['readyTimeout'] != null) {
        final startup = JSObject() as JSConfigurationStartup;
        startup.readyTimeout =
            (configuration.configurationMap['readyTimeout'] as int).toJS;
        config.startup = startup;
      }

      final storageOptions = JSObject() as JSConfigurationStorage;
      storageOptions.type = 'LOCALSTORAGE'.toJS;
      if (configuration.configurationMap['rolloutCacheConfiguration'] != null) {
        final rolloutCacheConfiguration =
            configuration.configurationMap['rolloutCacheConfiguration']
                as Map<String, dynamic>;
        if (rolloutCacheConfiguration['expirationDays'] != null) {
          storageOptions.expirationDays =
              (rolloutCacheConfiguration['expirationDays'] as int).toJS;
        }
        if (rolloutCacheConfiguration['clearOnInit'] != null) {
          storageOptions.clearOnInit =
              (rolloutCacheConfiguration['clearOnInit'] as bool).toJS;
        }
      }
      if (window.splitio!.InLocalStorage != null) {
        config.storage = window.splitio!.InLocalStorage
            ?.callAsFunction(null, storageOptions); // Browser SDK
      } else {
        config.storage = storageOptions; // JS or slim Browser SDK
      }

      if (configuration.configurationMap['impressionListener'] is bool) {
        final JSFunction logImpression = ((JSImpressionData data) {
          _impressionsStreamController.add(jsImpressionDataToImpression(data));
        }).toJS;

        final impressionListener = JSObject() as JSImpressionListener;
        reflectSet(impressionListener, 'logImpression'.toJS, logImpression);

        config.impressionListener = impressionListener;
      }

      if (configuration.configurationMap['fallbackTreatments'] != null) {
        final fallbackTreatments = configuration.configurationMap['fallbackTreatments'] as Map<String, dynamic>;
        // FallbackTreatmentsConfiguration has a compatible structure with JSFallbackTreatmentsConfiguration
        config.fallbackTreatments = fallbackTreatments.jsify() as JSFallbackTreatmentsConfiguration;
      }
    }

    return config;
  }

  @override
  Future<void> getClient({
    required String matchingKey,
    required String? bucketingKey,
  }) async {
    await _getClient(matchingKey: matchingKey, bucketingKey: bucketingKey);
  }

  Future<JSIBrowserClient> _getClient({
    required String matchingKey,
    required String? bucketingKey,
  }) async {
    await _initFuture;

    final key = buildKeyString(matchingKey, bucketingKey);

    return (_clients[key] ??=
        _factory.client(buildJsKey(matchingKey, bucketingKey)));
  }

  Future<JSIManager> _getManager() async {
    await _initFuture;

    return _factory.manager();
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
        reflectSet(jsMap, key.toJS, jsValue);
      } else {
        _factory.settings.log.warn(
            'Invalid ${isAttribute ? 'attribute' : 'property'} value: $value, for key: $key, will be ignored'
                .toJS);
      }
    });

    return jsMap;
  }

  JSEvaluationOptions _convertEvaluationOptions(
      EvaluationOptions evaluationOptions) {
    final jsEvalOptions = JSObject() as JSEvaluationOptions;

    if (evaluationOptions.properties.isNotEmpty) {
      jsEvalOptions.properties =
          _convertMap(evaluationOptions.properties, false);
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

    final result = client.getTreatment(
        splitName.toJS,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions));

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

    final result = client.getTreatments(
        splitNames.jsify() as JSArray<JSString>,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions));

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
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getTreatmentWithConfig(
        splitName.toJS,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions));

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

    final result = client.getTreatmentsWithConfig(
        splitNames.jsify() as JSArray<JSString>,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions));

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

    final result = client.getTreatmentsByFlagSet(
        flagSet.toJS,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions));

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

    final result = client.getTreatmentsByFlagSets(
        flagSets.jsify() as JSArray<JSString>,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions));

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

    final result = client.getTreatmentsWithConfigByFlagSet(
        flagSet.toJS,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions));

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

    final result = client.getTreatmentsWithConfigByFlagSets(
        flagSets.jsify() as JSArray<JSString>,
        _convertMap(attributes, true),
        _convertEvaluationOptions(evaluationOptions));

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

    final result = client.track(
        trafficType != null ? trafficType.toJS : _trafficType?.toJS,
        eventType.toJS,
        value?.toJS,
        _convertMap(properties, false));

    return result.toDart;
  }

  @override
  Future<Map<String, dynamic>> getAllAttributes(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.getAttributes();

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

    final result =
        client.setAttribute(attributeName.toJS, _convertValue(value, true));

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

    final result = client.setAttributes(_convertMap(attributes, true));

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

    final result = client.getAttribute(attributeName.toJS);

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

    final result = client.removeAttribute(attributeName.toJS);

    return result.toDart;
  }

  @override
  Future<bool> clearAttributes(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    final result = client.clearAttributes();

    return result.toDart;
  }

  @override
  Future<void> flush(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    // `then` chain to ensure the return type is `Future<void>`
    return client.flush().toDart.then<void>((_) {});
  }

  @override
  Future<void> destroy(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    return client.destroy().toDart.then<void>((_) {});
  }

  @override
  Future<SplitView?> split({required String splitName}) async {
    final manager = await _getManager();

    final result = manager.split(splitName.toJS);

    return result != null ? jsSplitViewToSplitView(result) : null;
  }

  @override
  Future<List<SplitView>> splits() async {
    final manager = await _getManager();

    final result = manager.splits();

    return result.toDart.map(jsSplitViewToSplitView).toList();
  }

  @override
  Future<List<String>> splitNames() async {
    final manager = await _getManager();

    final result = manager.names();

    return jsArrayToList(result).cast<String>();
  }

  @override
  Future<UserConsent> getUserConsent() async {
    await _initFuture;

    final userConsentStatus = _factory.UserConsent.getStatus();

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
    await _initFuture;

    _factory.UserConsent.setStatus(enabled.toJS);
  }

  // To ensure the public `onXXX` callbacks and `whenXXX` methods work correctly,
  // the `onXXX` method implementations always return a Future or Stream that waits for the client to be initialized.

  @override
  Future<void> onReady(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    if (client.getStatus().isReady.toDart) {
      return;
    } else {
      final completer = Completer<void>();

      client.on(
          client.Event.SDK_READY,
          () {
            completer.complete();
          }.toJS);

      return completer.future;
    }
  }

  @override
  Future<void> onReadyFromCache(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    if (client.getStatus().isReadyFromCache.toDart) {
      return;
    } else {
      final completer = Completer<void>();

      client.on(
          client.Event.SDK_READY_FROM_CACHE,
          () {
            completer.complete();
          }.toJS);

      return completer.future;
    }
  }

  @override
  Future<void> onTimeout(
      {required String matchingKey, required String? bucketingKey}) async {
    final client = await _getClient(
      matchingKey: matchingKey,
      bucketingKey: bucketingKey,
    );

    if (client.getStatus().hasTimedout.toDart) {
      return;
    } else {
      final completer = Completer<void>();

      client.on(
          client.Event.SDK_READY_TIMED_OUT,
          () {
            completer.complete();
          }.toJS);

      return completer.future;
    }
  }

  @override
  Stream<void> onUpdated(
      {required String matchingKey, required String? bucketingKey}) {
    // To ensure the public `onUpdated` callback and `whenUpdated` method work correctly,
    // this method always return a stream, and the StreamController callbacks
    // are async to wait for the client to be initialized.

    late final StreamController<void> controller;
    final JSFunction jsCallback = (() {
      if (!controller.isClosed) {
        controller.add(null);
      }
    }).toJS;
    Future<void> registerJsCallback() async {
      final client = await _getClient(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
      );
      client.on(client.Event.SDK_UPDATE, jsCallback);
    }

    Future<void> deregisterJsCallback() async {
      final client = await _getClient(
        matchingKey: matchingKey,
        bucketingKey: bucketingKey,
      );
      client.off(client.Event.SDK_UPDATE, jsCallback);
    }

    // No broadcast to support pause and resume of individual subscriptions
    controller = StreamController<void>(
      onListen: registerJsCallback,
      onPause: deregisterJsCallback,
      onResume: registerJsCallback,
      onCancel: () async {
        await deregisterJsCallback();
        if (!controller.isClosed) {
          await controller.close();
        }
      },
    );

    return controller.stream;
  }

  @override
  Stream<Impression> impressionsStream() {
    return _impressionsStreamController.stream;
  }
}
