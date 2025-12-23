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

  @override
  Future<void> init({
    required String apiKey,
    required String matchingKey,
    required String? bucketingKey,
    SplitConfiguration? sdkConfiguration,
  }) async {
    if (_initFuture == null) {
      _initFuture = this._init(apiKey: apiKey, matchingKey: matchingKey, bucketingKey: bucketingKey, sdkConfiguration: sdkConfiguration);
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

    final config = _buildConfig(apiKey, matchingKey, bucketingKey, sdkConfiguration);

    // Create factory instance
    this._factory = window.splitio!.SplitFactory.callAsFunction(null, config) as JS_IBrowserSDK;

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
  JSObject _buildConfig(String apiKey, String matchingKey, String? bucketingKey, SplitConfiguration? configuration) {
    final core = JSObject();
    core.setProperty('authorizationKey'.toJS, apiKey.toJS);
    // @TODO: set bucketingKey if provided
    core.setProperty('key'.toJS, matchingKey.toJS);

    final config = JSObject();
    config.setProperty('core'.toJS, core);

    // @TODO: complete config
    return config;
  }

}
