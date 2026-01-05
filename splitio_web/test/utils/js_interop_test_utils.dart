import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('Promise.resolve')
external JSPromise<Null> _promiseResolve();

class SplitioMock {
  final List<({String methodName, List<JSAny?> methodArguments})> calls = [];
  final JSObject splitio = JSObject();
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
    final mockManager = JSObject();
    mockManager['split'] = (JSString splitName) {
      calls.add((methodName: 'split', methodArguments: [splitName]));

      if (splitName.toDart == 'inexistent_split') {
        return null;
      }
      return _createSplitViewJSObject(splitName);
    }.toJS;
    mockManager['splits'] = () {
      calls.add((methodName: 'splits', methodArguments: []));
      return [
        _createSplitViewJSObject('split1'.toJS),
        _createSplitViewJSObject('split2'.toJS),
      ].jsify();
    }.toJS;
    mockManager['names'] = () {
      calls.add((methodName: 'names', methodArguments: []));
      return ['split1'.toJS, 'split2'.toJS].jsify();
    }.toJS;

    final mockClient = JSObject();
    mockClient['getTreatment'] =
        (JSAny? flagName, JSAny? attributes, JSAny? evaluationOptions) {
      calls.add((
        methodName: 'getTreatment',
        methodArguments: [flagName, attributes, evaluationOptions]
      ));
      return 'on'.toJS;
    }.toJS;
    mockClient['getTreatments'] =
        (JSAny? flagNames, JSAny? attributes, JSAny? evaluationOptions) {
      calls.add((
        methodName: 'getTreatments',
        methodArguments: [flagNames, attributes, evaluationOptions]
      ));
      if (flagNames is JSArray) {
        return flagNames.toDart.fold(JSObject(), (previousValue, element) {
          if (element is JSString) {
            previousValue.setProperty(element, 'on'.toJS);
          }
          return previousValue;
        });
      }
      return JSObject();
    }.toJS;
    mockClient['getTreatmentWithConfig'] =
        (JSAny? flagName, JSAny? attributes, JSAny? evaluationOptions) {
      calls.add((
        methodName: 'getTreatmentWithConfig',
        methodArguments: [flagName, attributes, evaluationOptions]
      ));
      final result = JSObject();
      result.setProperty('treatment'.toJS, 'on'.toJS);
      result.setProperty('config'.toJS, 'some-config'.toJS);
      return result;
    }.toJS;
    mockClient['getTreatmentsWithConfig'] =
        (JSAny? flagNames, JSAny? attributes, JSAny? evaluationOptions) {
      calls.add((
        methodName: 'getTreatmentsWithConfig',
        methodArguments: [flagNames, attributes, evaluationOptions]
      ));
      if (flagNames is JSArray) {
        return flagNames.toDart.fold(JSObject(), (previousValue, element) {
          if (element is JSString) {
            final result = JSObject();
            result.setProperty('treatment'.toJS, 'on'.toJS);
            result.setProperty('config'.toJS, 'some-config'.toJS);
            previousValue.setProperty(element, result);
          }
          return previousValue;
        });
      }
      return JSObject();
    }.toJS;
    mockClient['getTreatmentsByFlagSet'] =
        (JSAny? flagSetName, JSAny? attributes, JSAny? evaluationOptions) {
      calls.add((
        methodName: 'getTreatmentsByFlagSet',
        methodArguments: [flagSetName, attributes, evaluationOptions]
      ));
      final result = JSObject();
      result.setProperty('split1'.toJS, 'on'.toJS);
      result.setProperty('split2'.toJS, 'on'.toJS);
      return result;
    }.toJS;
    mockClient['getTreatmentsByFlagSets'] =
        (JSAny? flagSetNames, JSAny? attributes, JSAny? evaluationOptions) {
      calls.add((
        methodName: 'getTreatmentsByFlagSets',
        methodArguments: [flagSetNames, attributes, evaluationOptions]
      ));
      final result = JSObject();
      result.setProperty('split1'.toJS, 'on'.toJS);
      result.setProperty('split2'.toJS, 'on'.toJS);
      return result;
    }.toJS;
    mockClient['getTreatmentsWithConfigByFlagSet'] =
        (JSAny? flagSetName, JSAny? attributes, JSAny? evaluationOptions) {
      calls.add((
        methodName: 'getTreatmentsWithConfigByFlagSet',
        methodArguments: [flagSetName, attributes, evaluationOptions]
      ));

      final treatmentWithConfig = JSObject();
      treatmentWithConfig.setProperty('treatment'.toJS, 'on'.toJS);
      treatmentWithConfig.setProperty('config'.toJS, 'some-config'.toJS);

      final result = JSObject();
      result.setProperty('split1'.toJS, treatmentWithConfig);
      result.setProperty('split2'.toJS, treatmentWithConfig);
      return result;
    }.toJS;
    mockClient['getTreatmentsWithConfigByFlagSets'] =
        (JSAny? flagSetNames, JSAny? attributes, JSAny? evaluationOptions) {
      calls.add((
        methodName: 'getTreatmentsWithConfigByFlagSets',
        methodArguments: [flagSetNames, attributes, evaluationOptions]
      ));

      final treatmentWithConfig = JSObject();
      treatmentWithConfig.setProperty('treatment'.toJS, 'on'.toJS);
      treatmentWithConfig.setProperty('config'.toJS, 'some-config'.toJS);

      final result = JSObject();
      result.setProperty('split1'.toJS, treatmentWithConfig);
      result.setProperty('split2'.toJS, treatmentWithConfig);
      return result;
    }.toJS;
    mockClient['track'] = (JSAny? trafficType, JSAny? eventType, JSAny? value,
        JSAny? properties) {
      calls.add((
        methodName: 'track',
        methodArguments: [trafficType, eventType, value, properties]
      ));
      return trafficType != null ? true.toJS : false.toJS;
    }.toJS;
    mockClient['setAttribute'] = (JSAny? attributeName, JSAny? attributeValue) {
      calls.add((
        methodName: 'setAttribute',
        methodArguments: [attributeName, attributeValue]
      ));
      return true.toJS;
    }.toJS;
    mockClient['getAttribute'] = (JSAny? attributeName) {
      calls.add((methodName: 'getAttribute', methodArguments: [attributeName]));
      return 'attr-value'.toJS;
    }.toJS;
    mockClient['removeAttribute'] = (JSAny? attributeName) {
      calls.add(
          (methodName: 'removeAttribute', methodArguments: [attributeName]));
      return true.toJS;
    }.toJS;
    mockClient['setAttributes'] = (JSAny? attributes) {
      calls.add((methodName: 'setAttributes', methodArguments: [attributes]));
      return true.toJS;
    }.toJS;
    mockClient['getAttributes'] = () {
      calls.add((methodName: 'getAttributes', methodArguments: []));
      return {
        'attrBool': true,
        'attrString': 'value',
        'attrInt': 1,
        'attrDouble': 1.1,
        'attrList': ['value1', 100, false],
      }.jsify();
    }.toJS;
    mockClient['clearAttributes'] = () {
      calls.add((methodName: 'clearAttributes', methodArguments: []));
      return true.toJS;
    }.toJS;
    mockClient['flush'] = () {
      calls.add((methodName: 'flush', methodArguments: []));
      return _promiseResolve();
    }.toJS;
    mockClient['destroy'] = () {
      calls.add((methodName: 'destroy', methodArguments: []));
      return _promiseResolve();
    }.toJS;

    final mockLog = JSObject();
    mockLog['warn'] = (JSAny? arg1) {
      calls.add((methodName: 'warn', methodArguments: [arg1]));
    }.toJS;

    final mockUserConsent = JSObject();
    mockUserConsent['setStatus'] = (JSBoolean arg1) {
      _userConsent = arg1.toDart ? 'GRANTED'.toJS : 'DECLINED'.toJS;
      calls.add((methodName: 'setStatus', methodArguments: [arg1]));
      return true.toJS;
    }.toJS;
    mockUserConsent['getStatus'] = () {
      calls.add((methodName: 'getStatus', methodArguments: []));
      return _userConsent;
    }.toJS;

    final mockSettings = JSObject();
    mockSettings['log'] = mockLog;

    final mockFactory = JSObject();
    mockFactory['settings'] = mockSettings;
    mockFactory['client'] = (JSAny? splitKey) {
      calls.add((methodName: 'client', methodArguments: [splitKey]));
      return mockClient;
    }.toJS;
    mockFactory['manager'] = () {
      calls.add((methodName: 'manager', methodArguments: []));
      return mockManager;
    }.toJS;
    mockFactory['UserConsent'] = mockUserConsent;

    splitio['SplitFactory'] = (JSAny? arg1) {
      calls.add((methodName: 'SplitFactory', methodArguments: [arg1]));
      return mockFactory;
    }.toJS;
  }
}
