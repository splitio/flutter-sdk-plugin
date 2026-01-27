import 'dart:js_interop';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

// JS SDK types

@JS()
extension type JSImpressionDTO._(JSObject _) implements JSObject {
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
extension type JSImpressionData._(JSObject _) implements JSObject {
  external JSImpressionDTO impression;
  external JSObject? attributes;
  external JSAny ip; // string | false
  external JSAny hostname; // string | false
  external JSString sdkLanguageVersion;
}

@JS()
extension type JSILogger._(JSObject _) implements JSObject {
  external JSAny? debug(JSString message);
  external JSAny? info(JSString message);
  external JSAny? warn(JSString message);
  external JSAny? error(JSString message);
}

@JS()
extension type JSImpressionListener._(JSObject _) implements JSObject {
  external JSVoid logImpression(JSImpressionData impression);
}

@JS()
extension type JSConfigurationCore._(JSObject _) implements JSObject {
  external JSString authorizationKey;
  external JSAny key; // string | SplitKey
}

@JS()
extension type JSConfigurationStartup._(JSObject _) implements JSObject {
  external JSNumber? readyTimeout;
}

@JS()
extension type JSConfigurationScheduler._(JSObject _) implements JSObject {
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
extension type JSConfigurationUrls._(JSObject _) implements JSObject {
  external JSString? sdk;
  external JSString? events;
  external JSString? auth;
  external JSString? streaming;
  external JSString? telemetry;
}

@JS()
extension type JSSplitFilter._(JSObject _) implements JSObject {
  external JSString type;
  external JSArray<JSString> values;
}

@JS()
extension type JSConfigurationSync._(JSObject _) implements JSObject {
  external JSString? impressionsMode;
  external JSBoolean? enabled;
  external JSArray<JSSplitFilter>? splitFilters;
}

@JS()
extension type JSConfigurationStorage._(JSObject _) implements JSObject {
  external JSString? type;
  external JSNumber? expirationDays;
  external JSBoolean? clearOnInit;
}

@JS()
extension type JSFallbackTreatmentsConfiguration._(JSObject _) implements JSObject {
  external JSTreatmentWithConfig? global;
  external JSObject? byFlag;
}

@JS()
extension type JSConfiguration._(JSObject _) implements JSObject {
  external JSConfigurationCore core;
  external JSConfigurationStartup? startup;
  external JSConfigurationScheduler? scheduler;
  external JSConfigurationUrls? urls;
  external JSConfigurationSync? sync;
  external JSBoolean? streamingEnabled;
  external JSString? userConsent;
  external JSImpressionListener? impressionListener;
  external JSAny? debug;
  external JSAny? storage;
  external JSFallbackTreatmentsConfiguration? fallbackTreatments;
}

@JS()
extension type JSISettings._(JSObject _) implements JSConfiguration {
  external JSILogger log;
  external JSImpressionListener? impressionListener;
}

@JS()
extension type JSIUserConsentAPI._(JSObject _) implements JSObject {
  external JSBoolean setStatus(JSBoolean userConsent);
  external JSString getStatus();
}

@JS()
extension type JSEventConsts._(JSObject _) implements JSObject {
  // ignore: non_constant_identifier_names
  external JSString SDK_READY;
  // ignore: non_constant_identifier_names
  external JSString SDK_READY_FROM_CACHE;
  // ignore: non_constant_identifier_names
  external JSString SDK_READY_TIMED_OUT;
  // ignore: non_constant_identifier_names
  external JSString SDK_UPDATE;
}

@JS()
extension type JSReadinessStatus._(JSObject _) implements JSObject {
  external JSBoolean isReady;
  external JSBoolean isReadyFromCache;
  external JSBoolean hasTimedout;
}

@JS()
extension type JSTreatmentWithConfig._(JSObject _) implements JSObject {
  external JSString treatment;
  external JSString? config;
}

@JS()
extension type JSPrerequisite._(JSObject _) implements JSObject {
  external JSString flagName;
  external JSArray<JSString> treatments;
}

@JS()
extension type JSSplitView._(JSObject _) implements JSObject {
  external JSString name;
  external JSString trafficType;
  external JSBoolean killed;
  external JSArray<JSString> treatments;
  external JSNumber changeNumber;
  external JSObject configs;
  external JSArray<JSString> sets;
  external JSString defaultTreatment;
  external JSBoolean impressionsDisabled;
  external JSArray<JSPrerequisite> prerequisites;
}

@JS()
extension type JSEvaluationOptions._(JSObject _) implements JSObject {
  external JSObject properties;
}

@JS()
extension type JSIBrowserClient._(JSObject _) implements JSObject {
  external JSString getTreatment(JSString flagName, JSObject attributes,
      JSEvaluationOptions evaluationOptions);
  external JSObject getTreatments(JSArray<JSString> flagNames,
      JSObject attributes, JSEvaluationOptions evaluationOptions);
  external JSTreatmentWithConfig getTreatmentWithConfig(JSString flagName,
      JSObject attributes, JSEvaluationOptions evaluationOptions);
  external JSObject getTreatmentsWithConfig(JSArray<JSString> flagNames,
      JSObject attributes, JSEvaluationOptions evaluationOptions);
  external JSObject getTreatmentsByFlagSet(JSString flagSetName,
      JSObject attributes, JSEvaluationOptions evaluationOptions);
  external JSObject getTreatmentsByFlagSets(JSArray<JSString> flagSetNames,
      JSObject attributes, JSEvaluationOptions evaluationOptions);
  external JSObject getTreatmentsWithConfigByFlagSet(JSString flagSetName,
      JSObject attributes, JSEvaluationOptions evaluationOptions);
  external JSObject getTreatmentsWithConfigByFlagSets(
      JSArray<JSString> flagSetNames,
      JSObject attributes,
      JSEvaluationOptions evaluationOptions);
  external JSBoolean track(JSString? trafficType, JSString eventType,
      JSNumber? value, JSObject? attributes);
  external JSBoolean setAttribute(
      JSString attributeName, JSAny? attributeValue);
  external JSAny getAttribute(JSString attributeName);
  external JSBoolean removeAttribute(JSString attributeName);
  external JSBoolean setAttributes(JSObject attributes);
  external JSObject getAttributes();
  external JSBoolean clearAttributes();
  external JSPromise flush();
  external JSPromise destroy();
  external JSVoid on(JSString event, JSFunction listener);
  external JSVoid off(JSString event, JSFunction listener);
  external JSVoid emit(JSString event);
  // ignore: non_constant_identifier_names
  external JSEventConsts Event;
  external JSReadinessStatus getStatus();
}

@JS()
extension type JSIManager._(JSObject _) implements JSObject {
  external JSArray<JSString> names();
  external JSSplitView? split(JSString name);
  external JSArray<JSSplitView> splits();
}

@JS()
extension type JSIBrowserSDK._(JSObject _) implements JSObject {
  external JSIBrowserClient client(JSAny? key);
  external JSIManager manager();
  external JSISettings settings;
  // ignore: non_constant_identifier_names
  external JSIUserConsentAPI UserConsent;
}

@JS()
extension type JSLoggerFactory._(JSFunction _) implements JSFunction {
  external JSObject call();
}

@JS()
extension type JSBrowserSDKPackage._(JSObject _) implements JSObject {
  // ignore: non_constant_identifier_names
  external JSIBrowserSDK SplitFactory(JSConfiguration config);
  // ignore: non_constant_identifier_names
  external JSFunction? InLocalStorage;
  // ignore: non_constant_identifier_names
  external JSLoggerFactory? DebugLogger;
  // ignore: non_constant_identifier_names
  external JSLoggerFactory? InfoLogger;
  // ignore: non_constant_identifier_names
  external JSLoggerFactory? WarnLogger;
  // ignore: non_constant_identifier_names
  external JSLoggerFactory? ErrorLogger;
}

// Conversion utils: JS to Dart types

@JS('Object.keys')
external JSArray<JSString> objectKeys(JSObject obj);

@JS('Reflect.get')
external JSAny? reflectGet(JSObject target, JSString propertyKey);

@JS('Reflect.set')
external JSAny? reflectSet(JSObject target, JSString propertyKey, JSAny? value);

@JS('JSON.parse')
external JSObject jsonParse(JSString obj);

List<dynamic> jsArrayToList(JSArray<JSAny?> obj) =>
    (obj.dartify() as List).cast<dynamic>();

Map<String, dynamic> jsObjectToMap(JSObject obj) =>
    (obj.dartify() as Map).cast<String, dynamic>();

Object? jsAnyToDart(JSAny? value) => value.dartify();

// Conversion utils: JS SDK to Flutter SDK types

Map<String, String> jsTreatmentsToMap(JSObject obj) {
  return jsObjectToMap(obj).map((k, v) => MapEntry(k, v as String));
}

Map<String, SplitResult> jsTreatmentsWithConfigToMap(JSObject obj) {
  return jsObjectToMap(obj).map((k, v) => MapEntry(
      k, SplitResult(v['treatment'] as String, v['config'] as String?)));
}

SplitResult jsTreatmentWithConfigToSplitResult(JSTreatmentWithConfig obj) {
  return SplitResult(obj.treatment.toDart, obj.config?.toDart);
}

Prerequisite jsPrerequisiteToPrerequisite(JSPrerequisite obj) {
  return Prerequisite(
    obj.flagName.toDart,
    jsArrayToList(obj.treatments).toSet().cast<String>(),
  );
}

SplitView jsSplitViewToSplitView(JSSplitView obj) {
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

Impression jsImpressionDataToImpression(JSImpressionData obj) {
  return Impression(
    obj.impression.keyName.toDart,
    obj.impression.bucketingKey?.toDart,
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

String buildKeyString(String matchingKey, String? bucketingKey) {
  return bucketingKey == null ? matchingKey : '${matchingKey}_$bucketingKey';
}
