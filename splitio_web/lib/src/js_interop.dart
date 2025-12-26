import 'dart:js_interop';
import 'package:splitio_platform_interface/split_result.dart';

// JS SDK types

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
  external JSFunction getTreatments;
  external JSFunction getTreatmentWithConfig;
  external JSFunction getTreatmentsWithConfig;
  external JSFunction getTreatmentsByFlagSet;
  external JSFunction getTreatmentsByFlagSets;
  external JSFunction getTreatmentWithConfigByFlagSet;
  external JSFunction getTreatmentsWithConfigByFlagSets;
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

// Conversion utils: JS to Dart types

@JS('Object.keys')
external JSArray<JSString> _objectKeys(JSObject obj);

@JS('Reflect.get')
external JSAny? _reflectGet(JSObject target, JSAny propertyKey);

List<dynamic> jsArrayToList(JSArray obj) {
  return obj.toDart.map(jsAnyToDart).toList();
}

Map<String, dynamic> jsObjectToMap(JSObject obj) {
  return {
    for (final jsKey in _objectKeys(obj).toDart)
      // @TODO _reflectGet (js_interop) vs obj.getProperty (js_interop_unsafe)
      jsKey.toDart: jsAnyToDart(_reflectGet(obj, jsKey)),
  };
}

dynamic jsAnyToDart(JSAny? value) {
  if (value is JSArray) {
    return jsArrayToList(value);
  } else if (value is JSObject) {
    return jsObjectToMap(value);
  } else if (value is JSString) {
    return value.toDart;
  } else if (value is JSNumber) {
    return value.toDartDouble;
  } else if (value is JSBoolean) {
    return value.toDart;
  } else {
    return value; // JS null and undefined are null in Dart
  }
}

// Conversion utils: JS SDK to Flutter SDK types

Map<String, String> jsTreatmentsToMap(JSObject obj) {
  return jsObjectToMap(obj).map((k, v) => MapEntry(k, v as String));
}

Map<String, SplitResult> jsTreatmentsWithConfigToMap(JSObject obj) {
  return jsObjectToMap(obj).map((k, v) => MapEntry(k, SplitResult(v['treatment'] as String, v['config'] as String?)));
}

SplitResult jsTreatmentWithConfigToSplitResult(JSObject obj) {
  final config = _reflectGet(obj, 'config'.toJS);
  return SplitResult((_reflectGet(obj, 'treatment'.toJS) as JSString).toDart, (config is JSString) ? config.toDart : null);
}
