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
      completer.completeError(Exception('Failed to load Split SDK'));
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
}
