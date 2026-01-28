import 'dart:js_interop';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

// JS SDK types

/// SplitIO.ImpressionDTO
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

/// SplitIO.ImpressionData
@JS()
extension type JSImpressionData._(JSObject _) implements JSObject {
  external JSImpressionDTO impression;
  external JSObject? attributes;
  external JSAny ip; // string | false
  external JSAny hostname; // string | false
  external JSString sdkLanguageVersion;
}

/// SplitIO.ILogger
@JS()
extension type JSILogger._(JSObject _) implements JSObject {
  /// Log a debug level message
  external JSAny? debug(JSString message);

  /// Log an info level message
  external JSAny? info(JSString message);

  /// Log a warning level message
  external JSAny? warn(JSString message);

  /// Log an error level message
  external JSAny? error(JSString message);
}

/// SplitIO.IImpressionListener
@JS()
extension type JSImpressionListener._(JSObject _) implements JSObject {
  /// Log an impression
  external JSVoid logImpression(JSImpressionData impression);
}

/// SplitIO.IClientSideSettings['core']
@JS()
extension type JSConfigurationCore._(JSObject _) implements JSObject {
  external JSString authorizationKey;
  external JSAny key; // string | SplitKey
}

/// SplitIO.IClientSideSettings['startup']
@JS()
extension type JSConfigurationStartup._(JSObject _) implements JSObject {
  external JSNumber? readyTimeout;
}

/// SplitIO.IClientSideSettings['scheduler']
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

/// SplitIO.IClientSideSettings['urls']
@JS()
extension type JSConfigurationUrls._(JSObject _) implements JSObject {
  external JSString? sdk;
  external JSString? events;
  external JSString? auth;
  external JSString? streaming;
  external JSString? telemetry;
}

/// SplitIO.IClientSideSettings['sync']['splitFilters']
@JS()
extension type JSSplitFilter._(JSObject _) implements JSObject {
  external JSString type;
  external JSArray<JSString> values;
}

/// SplitIO.IClientSideSettings['sync']
@JS()
extension type JSConfigurationSync._(JSObject _) implements JSObject {
  external JSString? impressionsMode;
  external JSBoolean? enabled;
  external JSArray<JSSplitFilter>? splitFilters;
}

/// SplitIO.IClientSideSettings['storage']
@JS()
extension type JSConfigurationStorage._(JSObject _) implements JSObject {
  external JSString? type;
  external JSNumber? expirationDays;
  external JSBoolean? clearOnInit;
}

/// SplitIO.IClientSideSettings['fallbackTreatments']
@JS()
extension type JSFallbackTreatmentsConfiguration._(JSObject _)
    implements JSObject {
  external JSTreatmentWithConfig? global;
  external JSObject? byFlag;
}

/// SplitIO.IClientSideSettings
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

/// SplitIO.ISettings
@JS()
extension type JSISettings._(JSObject _) implements JSConfiguration {
  external JSILogger log;
  external JSImpressionListener? impressionListener;
}

/// SplitIO.IUserConsentAPI
@JS()
extension type JSIUserConsentAPI._(JSObject _) implements JSObject {
  /// SplitIO.IUserConsentAPI['setStatus']
  external JSBoolean setStatus(JSBoolean userConsent);

  /// SplitIO.IUserConsentAPI['getStatus']
  external JSString getStatus();
}

/// SplitIO.EventConsts
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

/// SplitIO.ReadinessStatus
@JS()
extension type JSReadinessStatus._(JSObject _) implements JSObject {
  external JSBoolean isReady;
  external JSBoolean isReadyFromCache;
  external JSBoolean hasTimedout;
}

/// SplitIO.TreatmentWithConfig
@JS()
extension type JSTreatmentWithConfig._(JSObject _) implements JSObject {
  external JSString treatment;
  external JSString? config;
}

/// SplitIO.SplitView['prerequisites']
@JS()
extension type JSPrerequisite._(JSObject _) implements JSObject {
  external JSString flagName;
  external JSArray<JSString> treatments;
}

/// SplitIO.SplitView
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

/// SplitIO.EvaluationOptions
@JS()
extension type JSEvaluationOptions._(JSObject _) implements JSObject {
  external JSObject properties;
}

/// SplitIO.IBrowserClient
@JS()
extension type JSIBrowserClient._(JSObject _) implements JSObject {
  /// SplitIO.IBrowserClient['getTreatment']
  external JSString getTreatment(JSString flagName, JSObject attributes,
      JSEvaluationOptions evaluationOptions);

  /// SplitIO.IBrowserClient['getTreatments']
  external JSObject getTreatments(JSArray<JSString> flagNames,
      JSObject attributes, JSEvaluationOptions evaluationOptions);

  /// SplitIO.IBrowserClient['getTreatmentWithConfig']
  external JSTreatmentWithConfig getTreatmentWithConfig(JSString flagName,
      JSObject attributes, JSEvaluationOptions evaluationOptions);

  /// SplitIO.IBrowserClient['getTreatmentsWithConfig']
  external JSObject getTreatmentsWithConfig(JSArray<JSString> flagNames,
      JSObject attributes, JSEvaluationOptions evaluationOptions);

  /// SplitIO.IBrowserClient['getTreatmentsByFlagSet']
  external JSObject getTreatmentsByFlagSet(JSString flagSetName,
      JSObject attributes, JSEvaluationOptions evaluationOptions);

  /// SplitIO.IBrowserClient['getTreatmentsByFlagSets']
  external JSObject getTreatmentsByFlagSets(JSArray<JSString> flagSetNames,
      JSObject attributes, JSEvaluationOptions evaluationOptions);

  /// SplitIO.IBrowserClient['getTreatmentsWithConfigByFlagSet']
  external JSObject getTreatmentsWithConfigByFlagSet(JSString flagSetName,
      JSObject attributes, JSEvaluationOptions evaluationOptions);

  /// SplitIO.IBrowserClient['getTreatmentsWithConfigByFlagSets']
  external JSObject getTreatmentsWithConfigByFlagSets(
      JSArray<JSString> flagSetNames,
      JSObject attributes,
      JSEvaluationOptions evaluationOptions);

  /// SplitIO.IBrowserClient['track']
  external JSBoolean track(JSString? trafficType, JSString eventType,
      JSNumber? value, JSObject? attributes);

  /// SplitIO.IBrowserClient['setAttribute']
  external JSBoolean setAttribute(
      JSString attributeName, JSAny? attributeValue);

  /// SplitIO.IBrowserClient['getAttribute']
  external JSAny getAttribute(JSString attributeName);

  /// SplitIO.IBrowserClient['removeAttribute']
  external JSBoolean removeAttribute(JSString attributeName);

  /// SplitIO.IBrowserClient['setAttributes']
  external JSBoolean setAttributes(JSObject attributes);

  /// SplitIO.IBrowserClient['getAttributes']
  external JSObject getAttributes();

  /// SplitIO.IBrowserClient['clearAttributes']
  external JSBoolean clearAttributes();

  /// SplitIO.IBrowserClient['flush']
  external JSPromise flush();

  /// SplitIO.IBrowserClient['destroy']
  external JSPromise destroy();

  /// SplitIO.IBrowserClient['on']
  external JSVoid on(JSString event, JSFunction listener);

  /// SplitIO.IBrowserClient['off']
  external JSVoid off(JSString event, JSFunction listener);

  /// SplitIO.IBrowserClient['emit']
  external JSVoid emit(JSString event);
  // ignore: non_constant_identifier_names
  external JSEventConsts Event;

  /// SplitIO.IBrowserClient['getStatus']
  external JSReadinessStatus getStatus();
}

/// SplitIO.IManager
@JS()
extension type JSIManager._(JSObject _) implements JSObject {
  /// SplitIO.IManager['names']
  external JSArray<JSString> names();

  /// SplitIO.IManager['split']
  external JSSplitView? split(JSString name);

  /// SplitIO.IManager['splits']
  external JSArray<JSSplitView> splits();
}

/// SplitIO.IBrowserSDK
@JS()
extension type JSIBrowserSDK._(JSObject _) implements JSObject {
  /// SplitIO.IBrowserSDK['client']
  external JSIBrowserClient client(JSAny? key);

  /// SplitIO.IBrowserSDK['manager']
  external JSIManager manager();

  /// SplitIO.IBrowserSDK['settings']
  external JSISettings settings;
  // ignore: non_constant_identifier_names
  external JSIUserConsentAPI UserConsent;
}

/// SplitIO.LoggerFactory
@JS()
extension type JSLoggerFactory._(JSFunction _) implements JSFunction {
  /// A callable function
  external JSObject call();
}

/// Type of the `window.splitio` object
@JS()
extension type JSBrowserSDKPackage._(JSObject _) implements JSObject {
  /// Browser SDK factory constructor
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

/// Get the keys of a JavaScript object
@JS('Object.keys')
external JSArray<JSString> objectKeys(JSObject obj);

/// Get a property from a JavaScript object
@JS('Reflect.get')
external JSAny? reflectGet(JSObject target, JSString propertyKey);

/// Set a property on a JavaScript object
@JS('Reflect.set')
external JSAny? reflectSet(JSObject target, JSString propertyKey, JSAny? value);

/// Parse a JSON string into a JavaScript object
@JS('JSON.parse')
external JSObject jsonParse(JSString obj);

/// Convert a JavaScript array to a Dart list
List<dynamic> jsArrayToList(JSArray<JSAny?> obj) =>
    (obj.dartify() as List).cast<dynamic>();

/// Convert a JavaScript object to a Dart map
Map<String, dynamic> jsObjectToMap(JSObject obj) =>
    (obj.dartify() as Map).cast<String, dynamic>();

/// Convert a JavaScript value to a Dart value
Object? jsAnyToDart(JSAny? value) => value.dartify();

// Conversion utils: JS SDK to Flutter SDK types

/// Convert a JavaScript SplitIO.Treatments object to a Dart map
Map<String, String> jsTreatmentsToMap(JSObject obj) {
  return jsObjectToMap(obj).map((k, v) => MapEntry(k, v as String));
}

/// Convert a JavaScript SplitIO.TreatmentsWithConfig object to a Dart map
Map<String, SplitResult> jsTreatmentsWithConfigToMap(JSObject obj) {
  return jsObjectToMap(obj).map((k, v) => MapEntry(
      k, SplitResult(v['treatment'] as String, v['config'] as String?)));
}

/// Convert a JavaScript SplitIO.TreatmentWithConfig object to a Dart SplitResult
SplitResult jsTreatmentWithConfigToSplitResult(JSTreatmentWithConfig obj) {
  return SplitResult(obj.treatment.toDart, obj.config?.toDart);
}

/// Convert a JavaScript prerequisite object to a Dart Prerequisite
Prerequisite jsPrerequisiteToPrerequisite(JSPrerequisite obj) {
  return Prerequisite(
    obj.flagName.toDart,
    jsArrayToList(obj.treatments).toSet().cast<String>(),
  );
}

/// Convert a JavaScript SplitIO.SplitView object to a Dart SplitView
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

/// Convert a JavaScript SplitIO.ImpressionData object to a Dart Impression
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

/// Build a JavaScript SplitIO.SplitKey object from a matching key and optional bucketing key
JSAny buildJsKey(String matchingKey, String? bucketingKey) {
  if (bucketingKey != null) {
    return {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
    }.jsify()!;
  }
  return matchingKey.toJS;
}

/// Build a string index from a matching key and optional bucketing key
String buildKeyString(String matchingKey, String? bucketingKey) {
  return bucketingKey == null ? matchingKey : '${matchingKey}_$bucketingKey';
}
