import 'dart:js_interop';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

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
extension type JS_IUserConsentAPI._(JSObject _) implements JSObject {
  external JSFunction setStatus;
  external JSFunction getStatus;
}

@JS()
extension type JS_IBrowserClient._(JSObject _) implements JSObject {
  external JSFunction getTreatment;
  external JSFunction getTreatments;
  external JSFunction getTreatmentWithConfig;
  external JSFunction getTreatmentsWithConfig;
  external JSFunction getTreatmentsByFlagSet;
  external JSFunction getTreatmentsByFlagSets;
  external JSFunction getTreatmentsWithConfigByFlagSet;
  external JSFunction getTreatmentsWithConfigByFlagSets;
  external JSFunction track;
  external JSFunction setAttribute;
  external JSFunction getAttribute;
  external JSFunction removeAttribute;
  external JSFunction setAttributes;
  external JSFunction getAttributes;
  external JSFunction clearAttributes;
  external JSFunction flush;
  external JSFunction destroy;
}

@JS()
extension type JS_IBrowserManager._(JSObject _) implements JSObject {
  external JSFunction names;
  external JSFunction split;
  external JSFunction splits;
}

@JS()
extension type JS_IBrowserSDK._(JSObject _) implements JSObject {
  external JSFunction client;
  external JSFunction manager;
  external JS_ISettings settings;
  external JS_IUserConsentAPI UserConsent;
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
  return jsObjectToMap(obj).map((k, v) => MapEntry(
      k, SplitResult(v['treatment'] as String, v['config'] as String?)));
}

SplitResult jsTreatmentWithConfigToSplitResult(JSObject obj) {
  final config = _reflectGet(obj, 'config'.toJS);
  return SplitResult((_reflectGet(obj, 'treatment'.toJS) as JSString).toDart,
      (config is JSString) ? config.toDart : null);
}

Prerequisite jsObjectToPrerequisite(JSObject obj) {
  return Prerequisite(
    (_reflectGet(obj, 'flagName'.toJS) as JSString).toDart,
    jsArrayToList(_reflectGet(obj, 'treatments'.toJS) as JSArray<JSString>)
        .toSet().cast<String>(),
  );
}

SplitView jsObjectToSplitView(JSObject obj) {
  return SplitView(
      (_reflectGet(obj, 'name'.toJS) as JSString).toDart,
      (_reflectGet(obj, 'trafficType'.toJS) as JSString).toDart,
      (_reflectGet(obj, 'killed'.toJS) as JSBoolean).toDart,
      jsArrayToList(_reflectGet(obj, 'treatments'.toJS) as JSArray<JSString>)
          .cast<String>(),
      (_reflectGet(obj, 'changeNumber'.toJS) as JSNumber).toDartInt,
      jsObjectToMap(_reflectGet(obj, 'configs'.toJS) as JSObject)
          .cast<String, String>(),
      (_reflectGet(obj, 'defaultTreatment'.toJS) as JSString).toDart,
      jsArrayToList(_reflectGet(obj, 'sets'.toJS) as JSArray<JSString>)
          .cast<String>(),
      (_reflectGet(obj, 'impressionsDisabled'.toJS) as JSBoolean).toDart,
      (_reflectGet(obj, 'prerequisites'.toJS) as JSArray<JSObject>)
          .toDart
          .map(jsObjectToPrerequisite)
          .toSet());
}
