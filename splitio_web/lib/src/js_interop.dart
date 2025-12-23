import 'dart:js_interop';

@JS()
extension type JS_Logger._(JSObject _) implements JSObject {
  external JSFunction warn;
}

@JS()
extension type JS_ISettings._(JSObject _) implements JSObject {
  external JS_Logger log;
}

@JS()
extension type JS_IBrowserClient._(JSObject _) implements JSObject {
  external JSFunction getTreatment;
}

@JS()
extension type JS_IBrowserSDK._(JSObject _) implements JSObject {
  external JSFunction client;
  external JS_ISettings settings;
}

@JS()
extension type JS_BrowserSDKPackage._(JSObject _) implements JSObject {
  external JSFunction SplitFactory;
  external JSFunction? InLocalStorage;
  external JSFunction? DebugLogger;
  external JSFunction? InfoLogger;
  external JSFunction? WarnLogger;
  external JSFunction? ErrorLogger;
}
