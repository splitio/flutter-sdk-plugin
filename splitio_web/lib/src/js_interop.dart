import 'dart:js_interop';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

// JS SDK types

@JS()
extension type JS_ImpressionDTO._(JSObject _) implements JSObject {
  external JSString feature;
  external JSString keyName;
  external JSString treatment;
  external JSNumber time;
  external JSString? bucketingKey;
  external JSString label;
  external JSNumber changeNumber;
  external JSNumber? pt;
  external JSString? properties;
}

@JS()
extension type JS_ImpressionData._(JSObject _) implements JSObject {
  external JS_ImpressionDTO impression;
  external JSObject? attributes;
  external JSAny ip; // string | false
  external JSAny hostname; // string | false
  external JSString sdkLanguageVersion;
}

@JS()
extension type JS_Logger._(JSObject _) implements JSObject {
  external JSAny? debug(JSString message);
  external JSAny? info(JSString message);
  external JSAny? warn(JSString message);
  external JSAny? error(JSString message);
}

@JS()
extension type JS_IImpressionListener._(JSObject _) implements JSObject {
  external JSVoid logImpression(JS_ImpressionData impression);
}

@JS()
extension type JS_ISettings._(JSObject _) implements JSObject {
  external JS_Logger log;
  external JS_IImpressionListener? impressionListener;
}

@JS()
extension type JS_IUserConsentAPI._(JSObject _) implements JSObject {
  external JSBoolean setStatus(JSBoolean userConsent);
  external JSString getStatus();
}

@JS()
extension type JS_EventConsts._(JSObject _) implements JSObject {
  external JSString SDK_READY;
  external JSString SDK_READY_FROM_CACHE;
  external JSString SDK_READY_TIMED_OUT;
  external JSString SDK_UPDATE;
}

@JS()
extension type JS_ReadinessStatus._(JSObject _) implements JSObject {
  external JSBoolean isReady;
  external JSBoolean isReadyFromCache;
  external JSBoolean hasTimedout;
}

@JS()
extension type JS_IBrowserClient._(JSObject _) implements JSObject {
  external JSString getTreatment(
      JSString flagName, JSObject attributes, JSObject evaluationOptions);
  external JSObject getTreatments(JSArray<JSString> flagNames, JSObject attributes, JSObject evaluationOptions);
  external JSObject getTreatmentWithConfig(JSString flagName, JSObject attributes, JSObject evaluationOptions);
  external JSObject getTreatmentsWithConfig(JSArray<JSString> flagNames, JSObject attributes, JSObject evaluationOptions);
  external JSObject getTreatmentsByFlagSet(JSString flagSetName, JSObject attributes, JSObject evaluationOptions);
  external JSObject getTreatmentsByFlagSets(JSArray<JSString> flagSetNames, JSObject attributes, JSObject evaluationOptions);
  external JSObject getTreatmentsWithConfigByFlagSet(JSString flagSetName, JSObject attributes, JSObject evaluationOptions);
  external JSObject getTreatmentsWithConfigByFlagSets(JSArray<JSString> flagSetNames, JSObject attributes, JSObject evaluationOptions);
  external JSBoolean track(JSString? trafficType, JSString eventType, JSNumber? value, JSObject? attributes);
  external JSBoolean setAttribute(JSString attributeName, JSAny? attributeValue);
  external JSAny getAttribute(JSString attributeName);
  external JSBoolean removeAttribute(JSString attributeName);
  external JSBoolean setAttributes(JSObject attributes);
  external JSObject getAttributes();
  external JSBoolean clearAttributes();
  external JSPromise<Null> flush();
  external JSPromise<Null> destroy();
  external JSFunction on;
  external JSFunction off;
  external JSFunction emit;
  external JS_EventConsts Event;
  external JSFunction getStatus;
}

@JS()
extension type JS_IBrowserManager._(JSObject _) implements JSObject {
  external JSArray<JSString> names();
  external JSObject? split(JSString name);
  external JSArray<JSObject> splits();
}

@JS()
extension type JS_IBrowserSDK._(JSObject _) implements JSObject {
  external JS_IBrowserClient client(JSAny? key);
  external JS_IBrowserManager manager();
  external JS_ISettings settings;
  external JS_IUserConsentAPI UserConsent;
}

@JS()
extension type JS_BrowserSDKPackage._(JSObject _) implements JSObject {
  external JS_IBrowserSDK SplitFactory(JSObject config);
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

@JS('JSON.parse')
external JSObject _jsonParse(JSString obj);

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
        .toSet()
        .cast<String>(),
  );
}

// @TODO: JS_SplitView
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

Impression jsImpressionDataToImpression(JS_ImpressionData obj) {
  return Impression(
    obj.impression.keyName.toDart,
    obj.impression.bucketingKey != null
        ? obj.impression.bucketingKey!.toDart
        : null,
    obj.impression.feature.toDart,
    obj.impression.treatment.toDart,
    obj.impression.time.toDartInt,
    obj.impression.label.toDart,
    obj.impression.changeNumber.toDartInt,
    obj.attributes != null ? jsObjectToMap(obj.attributes!) : {},
    obj.impression.properties != null
        ? jsObjectToMap(_jsonParse(obj.impression.properties!))
        : null,
  );
}

JSAny buildJsKey(String matchingKey, String? bucketingKey) {
  if (bucketingKey != null) {
    return {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
    }.jsify()!;
  }
  return matchingKey.toJS;
}
