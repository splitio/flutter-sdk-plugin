import 'dart:js_interop';
import 'package:splitio_web/src/js_interop.dart';

@JS('Promise.resolve')
external JSPromise<Null> _promiseResolve();

@JS('Object.assign')
external JSObject _objectAssign(JSObject target, JSObject source);

class SplitioMock {
  // JS Browser SDK API mock
  final JS_BrowserSDKPackage splitio = JSObject() as JS_BrowserSDKPackage;

  // Test utils
  final List<({String methodName, List<JSAny?> methodArguments})> calls = [];
  final JS_IBrowserSDK mockFactory = JSObject() as JS_IBrowserSDK;

  final _mockEvents = {
    'SDK_READY': 'init::ready',
    'SDK_READY_FROM_CACHE': 'init::cache-ready',
    'SDK_READY_TIMED_OUT': 'init::timeout',
    'SDK_UPDATE': 'state::update'
  }.jsify() as JS_EventConsts;
  final _mockClients = <String, JS_IBrowserClient>{};

  JS_Configuration? _config;
  JSString _userConsent = 'UNKNOWN'.toJS;

  JSObject _createSplitViewJSObject(JSString splitName) {
    return {
      "name": splitName.toDart,
      "trafficType": "user",
      "killed": false,
      "treatments": ["on", "off"],
      "changeNumber": 1478881219393,
      "configs": {"on": "\"color\": \"green\""},
      "defaultTreatment": "off",
      "sets": ["set_a"],
      "impressionsDisabled": false,
      "prerequisites": [
        {
          "flagName": "some_flag",
          "treatments": ["on"]
        }
      ]
    }.jsify() as JSObject;
  }

  SplitioMock() {
    final mockManager = JSObject() as JS_IManager;
    reflectSet(
        mockManager,
        'split'.toJS,
        (JSString splitName) {
          calls.add((methodName: 'split', methodArguments: [splitName]));

          if (splitName.toDart == 'inexistent_split') {
            return null;
          }
          return _createSplitViewJSObject(splitName);
        }.toJS);
    reflectSet(
        mockManager,
        'splits'.toJS,
        () {
          calls.add((methodName: 'splits', methodArguments: []));
          return [
            _createSplitViewJSObject('split1'.toJS),
            _createSplitViewJSObject('split2'.toJS),
          ].jsify();
        }.toJS);
    reflectSet(
        mockManager,
        'names'.toJS,
        () {
          calls.add((methodName: 'names', methodArguments: []));
          return ['split1'.toJS, 'split2'.toJS].jsify();
        }.toJS);

    final mockLog = JSObject() as JS_ILogger;
    reflectSet(
        mockLog,
        'warn'.toJS,
        (JSAny? arg1) {
          calls.add((methodName: 'warn', methodArguments: [arg1]));
        }.toJS);

    final mockUserConsent = JSObject() as JS_IUserConsentAPI;
    reflectSet(
        mockUserConsent,
        'setStatus'.toJS,
        (JSBoolean arg1) {
          _userConsent = arg1.toDart ? 'GRANTED'.toJS : 'DECLINED'.toJS;
          calls.add((methodName: 'setStatus', methodArguments: [arg1]));
          return true.toJS;
        }.toJS);
    reflectSet(
        mockUserConsent,
        'getStatus'.toJS,
        () {
          calls.add((methodName: 'getStatus', methodArguments: []));
          return _userConsent;
        }.toJS);

    reflectSet(
        mockFactory,
        'client'.toJS,
        (JSAny? splitKey) {
          calls.add((methodName: 'client', methodArguments: [splitKey]));

          final dartKey = buildDartKey(splitKey ?? _config!.core.key);
          final stringKey =
              buildKeyString(dartKey.matchingKey, dartKey.bucketingKey);
          _mockClients[stringKey] ??= _buildMockClient();
          return _mockClients[stringKey];
        }.toJS);
    reflectSet(
        mockFactory,
        'manager'.toJS,
        () {
          calls.add((methodName: 'manager', methodArguments: []));
          return mockManager;
        }.toJS);
    mockFactory.UserConsent = mockUserConsent;

    reflectSet(
        splitio,
        'SplitFactory'.toJS,
        (JS_Configuration config) {
          calls.add((methodName: 'SplitFactory', methodArguments: [config]));

          final mockSettings =
              _objectAssign(JSObject(), config) as JS_ISettings;
          mockSettings.log = mockLog;
          mockFactory.settings = mockSettings;

          _config = config;

          return mockFactory;
        }.toJS);
  }

  JS_IBrowserClient _buildMockClient() {
    final JS_ReadinessStatus _readinessStatus = {
      'isReady': false,
      'isReadyFromCache': false,
      'hasTimedout': false,
    }.jsify() as JS_ReadinessStatus;
    final Map<JSString, Set<JSFunction>> _eventListeners = {};
    final mockClient = JSObject() as JS_IBrowserClient;

    mockClient.Event = _mockEvents;
    reflectSet(
        mockClient,
        'on'.toJS,
        (JSString event, JSFunction listener) {
          calls.add((methodName: 'on', methodArguments: [event, listener]));
          _eventListeners[event] ??= Set();
          _eventListeners[event]!.add(listener);
        }.toJS);
    reflectSet(
        mockClient,
        'off'.toJS,
        (JSString event, JSFunction listener) {
          calls.add((methodName: 'off', methodArguments: [event, listener]));
          _eventListeners[event] ??= Set();
          _eventListeners[event]!.remove(listener);
        }.toJS);
    reflectSet(
        mockClient,
        'emit'.toJS,
        (JSString event) {
          calls.add((methodName: 'emit', methodArguments: [event]));
          _eventListeners[event]?.forEach((listener) {
            listener.callAsFunction(null, event);
          });
          if (event == _mockEvents.SDK_READY) {
            _readinessStatus.isReady = true.toJS;
          } else if (event == _mockEvents.SDK_READY_FROM_CACHE) {
            _readinessStatus.isReadyFromCache = true.toJS;
          } else if (event == _mockEvents.SDK_READY_TIMED_OUT) {
            _readinessStatus.hasTimedout = true.toJS;
          }
        }.toJS);
    reflectSet(
        mockClient,
        'getStatus'.toJS,
        () {
          calls.add((methodName: 'getStatus', methodArguments: []));
          return _readinessStatus;
        }.toJS);
    reflectSet(
        mockClient,
        'getTreatment'.toJS,
        (JSAny? flagName, JSAny? attributes, JSAny? evaluationOptions) {
          calls.add((
            methodName: 'getTreatment',
            methodArguments: [flagName, attributes, evaluationOptions]
          ));
          return 'on'.toJS;
        }.toJS);
    reflectSet(
        mockClient,
        'getTreatments'.toJS,
        (JSAny? flagNames, JSAny? attributes, JSAny? evaluationOptions) {
          calls.add((
            methodName: 'getTreatments',
            methodArguments: [flagNames, attributes, evaluationOptions]
          ));
          if (flagNames is JSArray) {
            return flagNames.toDart.fold(JSObject(), (previousValue, flagName) {
              if (flagName is JSString) {
                reflectSet(previousValue, flagName, 'on'.toJS);
              }
              return previousValue;
            });
          }
          return JSObject();
        }.toJS);
    reflectSet(
        mockClient,
        'getTreatmentWithConfig'.toJS,
        (JSAny? flagName, JSAny? attributes, JSAny? evaluationOptions) {
          calls.add((
            methodName: 'getTreatmentWithConfig',
            methodArguments: [flagName, attributes, evaluationOptions]
          ));
          final result = JSObject() as JS_TreatmentWithConfig;
          result.treatment = 'on'.toJS;
          result.config = 'some-config'.toJS;
          return result;
        }.toJS);
    reflectSet(
        mockClient,
        'getTreatmentsWithConfig'.toJS,
        (JSAny? flagNames, JSAny? attributes, JSAny? evaluationOptions) {
          calls.add((
            methodName: 'getTreatmentsWithConfig',
            methodArguments: [flagNames, attributes, evaluationOptions]
          ));
          if (flagNames is JSArray) {
            return flagNames.toDart.fold(JSObject(), (previousValue, flagName) {
              if (flagName is JSString) {
                final result = JSObject() as JS_TreatmentWithConfig;
                result.treatment = 'on'.toJS;
                result.config = 'some-config'.toJS;
                reflectSet(previousValue, flagName, result);
              }
              return previousValue;
            });
          }
          return JSObject();
        }.toJS);
    reflectSet(
        mockClient,
        'getTreatmentsByFlagSet'.toJS,
        (JSAny? flagSetName, JSAny? attributes, JSAny? evaluationOptions) {
          calls.add((
            methodName: 'getTreatmentsByFlagSet',
            methodArguments: [flagSetName, attributes, evaluationOptions]
          ));
          final result = JSObject();
          reflectSet(result, 'split1'.toJS, 'on'.toJS);
          reflectSet(result, 'split2'.toJS, 'on'.toJS);
          return result;
        }.toJS);
    reflectSet(
        mockClient,
        'getTreatmentsByFlagSets'.toJS,
        (JSAny? flagSetNames, JSAny? attributes, JSAny? evaluationOptions) {
          calls.add((
            methodName: 'getTreatmentsByFlagSets',
            methodArguments: [flagSetNames, attributes, evaluationOptions]
          ));
          final result = JSObject();
          reflectSet(result, 'split1'.toJS, 'on'.toJS);
          reflectSet(result, 'split2'.toJS, 'on'.toJS);
          return result;
        }.toJS);
    reflectSet(
        mockClient,
        'getTreatmentsWithConfigByFlagSet'.toJS,
        (JSAny? flagSetName, JSAny? attributes, JSAny? evaluationOptions) {
          calls.add((
            methodName: 'getTreatmentsWithConfigByFlagSet',
            methodArguments: [flagSetName, attributes, evaluationOptions]
          ));

          final treatmentWithConfig = JSObject() as JS_TreatmentWithConfig;
          treatmentWithConfig.treatment = 'on'.toJS;
          treatmentWithConfig.config = 'some-config'.toJS;

          final result = JSObject();
          reflectSet(result, 'split1'.toJS, treatmentWithConfig);
          reflectSet(result, 'split2'.toJS, treatmentWithConfig);
          return result;
        }.toJS);
    reflectSet(
        mockClient,
        'getTreatmentsWithConfigByFlagSets'.toJS,
        (JSAny? flagSetNames, JSAny? attributes, JSAny? evaluationOptions) {
          calls.add((
            methodName: 'getTreatmentsWithConfigByFlagSets',
            methodArguments: [flagSetNames, attributes, evaluationOptions]
          ));

          final treatmentWithConfig = JSObject() as JS_TreatmentWithConfig;
          treatmentWithConfig.treatment = 'on'.toJS;
          treatmentWithConfig.config = 'some-config'.toJS;

          final result = JSObject();
          reflectSet(result, 'split1'.toJS, treatmentWithConfig);
          reflectSet(result, 'split2'.toJS, treatmentWithConfig);
          return result;
        }.toJS);
    reflectSet(
        mockClient,
        'track'.toJS,
        (JSAny? trafficType, JSAny? eventType, JSAny? value,
            JSAny? properties) {
          calls.add((
            methodName: 'track',
            methodArguments: [trafficType, eventType, value, properties]
          ));
          return trafficType != null ? true.toJS : false.toJS;
        }.toJS);
    reflectSet(
        mockClient,
        'setAttribute'.toJS,
        (JSAny? attributeName, JSAny? attributeValue) {
          calls.add((
            methodName: 'setAttribute',
            methodArguments: [attributeName, attributeValue]
          ));
          return true.toJS;
        }.toJS);
    reflectSet(
        mockClient,
        'getAttribute'.toJS,
        (JSAny? attributeName) {
          calls.add(
              (methodName: 'getAttribute', methodArguments: [attributeName]));
          return 'attr-value'.toJS;
        }.toJS);
    reflectSet(
        mockClient,
        'removeAttribute'.toJS,
        (JSAny? attributeName) {
          calls.add((
            methodName: 'removeAttribute',
            methodArguments: [attributeName]
          ));
          return true.toJS;
        }.toJS);
    reflectSet(
        mockClient,
        'setAttributes'.toJS,
        (JSAny? attributes) {
          calls.add(
              (methodName: 'setAttributes', methodArguments: [attributes]));
          return true.toJS;
        }.toJS);
    reflectSet(
        mockClient,
        'getAttributes'.toJS,
        () {
          calls.add((methodName: 'getAttributes', methodArguments: []));
          return {
            'attrBool': true,
            'attrString': 'value',
            'attrInt': 1,
            'attrDouble': 1.1,
            'attrList': ['value1', 100, false],
          }.jsify();
        }.toJS);
    reflectSet(
        mockClient,
        'clearAttributes'.toJS,
        () {
          calls.add((methodName: 'clearAttributes', methodArguments: []));
          return true.toJS;
        }.toJS);
    reflectSet(
        mockClient,
        'flush'.toJS,
        () {
          calls.add((methodName: 'flush', methodArguments: []));
          return _promiseResolve();
        }.toJS);
    reflectSet(
        mockClient,
        'destroy'.toJS,
        () {
          calls.add((methodName: 'destroy', methodArguments: []));
          return _promiseResolve();
        }.toJS);

    return mockClient;
  }

  void addFactoryModules() {
    reflectSet(
        splitio,
        'DebugLogger'.toJS,
        () {
          calls.add((methodName: 'DebugLogger', methodArguments: []));
          return JSObject();
        }.toJS);
    reflectSet(
        splitio,
        'InfoLogger'.toJS,
        () {
          calls.add((methodName: 'InfoLogger', methodArguments: []));
          return JSObject();
        }.toJS);
    reflectSet(
        splitio,
        'WarnLogger'.toJS,
        () {
          calls.add((methodName: 'WarnLogger', methodArguments: []));
          return JSObject();
        }.toJS);
    reflectSet(
        splitio,
        'ErrorLogger'.toJS,
        () {
          calls.add((methodName: 'ErrorLogger', methodArguments: []));
          return JSObject();
        }.toJS);
  }

  void removeFactoryModules() {
    reflectSet(splitio, 'DebugLogger'.toJS, null);
    reflectSet(splitio, 'InfoLogger'.toJS, null);
    reflectSet(splitio, 'WarnLogger'.toJS, null);
    reflectSet(splitio, 'ErrorLogger'.toJS, null);
  }
}
