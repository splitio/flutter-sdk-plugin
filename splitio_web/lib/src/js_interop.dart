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
extension type JS_ConfigurationCore._(JSObject _) implements JSObject {
  external JSString authorizationKey;
  external JSAny key; // string | SplitKey
}

@JS()
extension type JS_ConfigurationStartup._(JSObject _) implements JSObject {
  external JSNumber? readyTimeout;
}

@JS()
extension type JS_ConfigurationScheduler._(JSObject _) implements JSObject {
  external JSNumber? featuresRefreshRate;
  external JSNumber? segmentsRefreshRate;
  external JSNumber? impressionsRefreshRate;
  external JSNumber? eventsRefreshRate;
  external JSNumber? telemetryRefreshRate;
  external JSNumber? eventsQueueSize;
  external JSNumber? impressionsQueueSize;
  external JSNumber? eventsPushRate;
}

@JS()
extension type JS_ConfigurationUrls._(JSObject _) implements JSObject {
  external JSString? sdk;
  external JSString? events;
  external JSString? auth;
  external JSString? streaming;
  external JSString? telemetry;
}

@JS()
extension type JS_SplitFilter._(JSObject _) implements JSObject {
  external JSString type;
  external JSArray<JSString> values;
}

@JS()
extension type JS_ConfigurationSync._(JSObject _) implements JSObject {
  external JSString? impressionsMode;
  external JSBoolean? enabled;
  external JSArray<JS_SplitFilter>? splitFilters;
}

@JS()
extension type JS_ConfigurationStorage._(JSObject _) implements JSObject {
  external JSString? type;
  external JSNumber? expirationDays;
  external JSBoolean? clearOnInit;
}

@JS()
extension type JS_Configuration._(JSObject _) implements JSObject {
  external JS_ConfigurationCore core;
  external JS_ConfigurationStartup? startup;
  external JS_ConfigurationScheduler? scheduler;
  external JS_ConfigurationUrls? urls;
  external JS_ConfigurationSync? sync;
  external JSBoolean? streamingEnabled;
  external JSString? userConsent;
  external JS_IImpressionListener? impressionListener;
  external JSAny? debug;
  external JSAny? storage;
}

@JS()
extension type JS_ISettings._(JSObject _) implements JS_Configuration {
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
extension type JS_TreatmentWithConfig._(JSObject _) implements JSObject {
  external JSString treatment;
  external JSString? config;
}

@JS()
extension type JS_Prerequisite._(JSObject _) implements JSObject {
  external JSString flagName;
  external JSArray<JSString> treatments;
}

@JS()
extension type JS_SplitView._(JSObject _) implements JSObject {
  external JSString name;
  external JSString trafficType;
  external JSBoolean killed;
  external JSArray<JSString> treatments;
  external JSNumber changeNumber;
  external JSObject configs;
  external JSArray<JSString> sets;
  external JSString defaultTreatment;
  external JSBoolean impressionsDisabled;
  external JSArray<JS_Prerequisite> prerequisites;
}

@JS()
extension type JS_EvaluationOptions._(JSObject _) implements JSObject {
  external JSObject properties;
}

@JS()
extension type JS_IBrowserClient._(JSObject _) implements JSObject {
  external JSString getTreatment(JSString flagName, JSObject attributes,
      JS_EvaluationOptions evaluationOptions);
  external JSObject getTreatments(JSArray<JSString> flagNames,
      JSObject attributes, JS_EvaluationOptions evaluationOptions);
  external JS_TreatmentWithConfig getTreatmentWithConfig(JSString flagName,
      JSObject attributes, JS_EvaluationOptions evaluationOptions);
  external JSObject getTreatmentsWithConfig(JSArray<JSString> flagNames,
      JSObject attributes, JS_EvaluationOptions evaluationOptions);
  external JSObject getTreatmentsByFlagSet(JSString flagSetName,
      JSObject attributes, JS_EvaluationOptions evaluationOptions);
  external JSObject getTreatmentsByFlagSets(JSArray<JSString> flagSetNames,
      JSObject attributes, JS_EvaluationOptions evaluationOptions);
  external JSObject getTreatmentsWithConfigByFlagSet(JSString flagSetName,
      JSObject attributes, JS_EvaluationOptions evaluationOptions);
  external JSObject getTreatmentsWithConfigByFlagSets(
      JSArray<JSString> flagSetNames,
      JSObject attributes,
      JS_EvaluationOptions evaluationOptions);
  external JSBoolean track(JSString? trafficType, JSString eventType,
      JSNumber? value, JSObject? attributes);
  external JSBoolean setAttribute(
      JSString attributeName, JSAny? attributeValue);
  external JSAny getAttribute(JSString attributeName);
  external JSBoolean removeAttribute(JSString attributeName);
  external JSBoolean setAttributes(JSObject attributes);
  external JSObject getAttributes();
  external JSBoolean clearAttributes();
  external JSPromise<Null> flush();
  external JSPromise<Null> destroy();
  external JSVoid on(JSString event, JSFunction listener);
  external JSVoid off(JSString event, JSFunction listener);
  external JSVoid emit(JSString event);
  external JS_EventConsts Event;
  external JS_ReadinessStatus getStatus();
}

@JS()
extension type JS_IManager._(JSObject _) implements JSObject {
  external JSArray<JSString> names();
  external JS_SplitView? split(JSString name);
  external JSArray<JS_SplitView> splits();
}

@JS()
extension type JS_IBrowserSDK._(JSObject _) implements JSObject {
  external JS_IBrowserClient client(JSAny? key);
  external JS_IManager manager();
  external JS_ISettings settings;
  external JS_IUserConsentAPI UserConsent;
}

@JS()
extension type JS_BrowserSDKPackage._(JSObject _) implements JSObject {
  external JS_IBrowserSDK SplitFactory(JS_Configuration config);
  external JSFunction? InLocalStorage;
  external JSFunction? DebugLogger;
  external JSFunction? InfoLogger;
  external JSFunction? WarnLogger;
  external JSFunction? ErrorLogger;
}

// Conversion utils: JS to Dart types

@JS('Object.keys')
external JSArray<JSString> objectKeys(JSObject obj);

@JS('Reflect.get')
external JSAny? reflectGet(JSObject target, JSAny propertyKey);

@JS('Reflect.set')
external JSAny? reflectSet(JSObject target, JSAny propertyKey, JSAny value);

@JS('JSON.parse')
external JSObject jsonParse(JSString obj);

List<dynamic> jsArrayToList(JSArray obj) {
  return obj.toDart.map(jsAnyToDart).toList();
}

Map<String, dynamic> jsObjectToMap(JSObject obj) {
  return {
    for (final jsKey in objectKeys(obj).toDart)
      jsKey.toDart: jsAnyToDart(reflectGet(obj, jsKey)),
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

SplitResult jsTreatmentWithConfigToSplitResult(JS_TreatmentWithConfig obj) {
  return SplitResult(obj.treatment.toDart,
      (obj.config is JSString) ? obj.config!.toDart : null);
}

Prerequisite jsPrerequisiteToPrerequisite(JS_Prerequisite obj) {
  return Prerequisite(
    obj.flagName.toDart,
    jsArrayToList(obj.treatments).toSet().cast<String>(),
  );
}

SplitView jsSplitViewToSplitView(JS_SplitView obj) {
  return SplitView(
      obj.name.toDart,
      obj.trafficType.toDart,
      obj.killed.toDart,
      jsArrayToList(obj.treatments).cast<String>(),
      obj.changeNumber.toDartInt,
      jsObjectToMap(obj.configs).cast<String, String>(),
      obj.defaultTreatment.toDart,
      jsArrayToList(obj.sets).cast<String>(),
      obj.impressionsDisabled.toDart,
      obj.prerequisites.toDart.map(jsPrerequisiteToPrerequisite).toSet());
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
        ? jsObjectToMap(jsonParse(obj.impression.properties!))
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

({String matchingKey, String? bucketingKey}) buildDartKey(JSAny splitKey) {
  return splitKey is JSString
      ? (matchingKey: splitKey.toDart, bucketingKey: null)
      : (
          matchingKey:
              (reflectGet(splitKey as JSObject, 'matchingKey'.toJS) as JSString)
                  .toDart,
          bucketingKey:
              (reflectGet(splitKey, 'bucketingKey'.toJS) as JSString).toDart,
        );
}

String buildKeyString(String matchingKey, String? bucketingKey) {
  return bucketingKey == null ? matchingKey : '${matchingKey}_$bucketingKey';
}
