import 'dart:js_interop';
import 'dart:js_interop_unsafe';

class SplitioMock {
  final List<({String methodName, List<JSAny?> methodArguments})> calls = [];
  final JSObject splitio = JSObject();

  SplitioMock() {
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

    final mockLog = JSObject();
    mockLog['warn'] = (JSAny? arg1) {
      calls.add((methodName: 'warn', methodArguments: [arg1]));
    }.toJS;

    final mockSettings = JSObject();
    mockSettings['log'] = mockLog;

    final mockFactory = JSObject();
    mockFactory['settings'] = mockSettings;
    mockFactory['client'] = (JSAny? splitKey) {
      calls.add((methodName: 'client', methodArguments: [splitKey]));
      return mockClient;
    }.toJS;

    splitio['SplitFactory'] = (JSAny? arg1) {
      calls.add((methodName: 'SplitFactory', methodArguments: [arg1]));
      return mockFactory;
    }.toJS;
  }
}
