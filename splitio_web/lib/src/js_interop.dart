import 'dart:js_interop';

@JS()
extension type JS_IBrowserSDK._(JSObject _) implements JSObject {
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
