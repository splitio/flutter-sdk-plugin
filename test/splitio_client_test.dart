import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio/channel/method_channel_manager.dart';
import 'package:splitio/events/split_events_listener.dart';
import 'package:splitio/split_client.dart';

void main() {
  const MethodChannel _channel = MethodChannel('splitio');

  String methodName = '';
  dynamic methodArguments;

  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelManager _methodChannelWrapper = MethodChannelManager(_channel);

  SplitClient _getClient([SplitEventsListener? splitEventsListener]) {
    if (splitEventsListener != null) {
      return DefaultSplitClient.withEventListener(_methodChannelWrapper,
          'matching-key', 'bucketing-key', splitEventsListener);
    }

    return DefaultSplitClient(
        _methodChannelWrapper, 'matching-key', 'bucketing-key');
  }

  setUp(() {
    _channel.setMockMethodCallHandler((MethodCall methodCall) async {
      methodName = methodCall.method;
      methodArguments = methodCall.arguments;

      switch (methodCall.method) {
        case 'getTreatment':
          return '';
        case 'getTreatments':
          return {'split1': 'on', 'split2': 'off'};
        case 'getTreatmentsWithConfig':
          return {
            'split1': {'treatment': 'on', 'config': null},
            'split2': {'treatment': 'off', 'config': null}
          };
        case 'track':
          return true;
        case 'getAttribute':
          return true;
        case 'getAllAttributes':
          return {
            'attr_1': true,
            'attr_2': ['list-element'],
            'attr_3': 28.20
          };
        case 'setAttribute':
        case 'setAttributes':
        case 'removeAttribute':
        case 'clearAttributes':
          return true;
      }
    });
  });

  group('evaluation', () {
    test('getTreatment without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatment('split');

      expect(methodName, 'getTreatment');
      expect(methodArguments, {
        'splitName': 'split',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatment with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatment('split', {'attr1': true});

      expect(methodName, 'getTreatment');
      expect(methodArguments, {
        'splitName': 'split',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatments without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatments(['split1', 'split2']);

      expect(methodName, 'getTreatments');
      expect(methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatments with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatments(['split1', 'split2'], {'attr1': true});

      expect(methodName, 'getTreatments');
      expect(methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentWithConfig with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentWithConfig('split1', {'attr1': true});

      expect(methodName, 'getTreatmentWithConfig');
      expect(methodArguments, {
        'splitName': 'split1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentWithConfig without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentWithConfig('split1');

      expect(methodName, 'getTreatmentWithConfig');
      expect(methodArguments, {
        'splitName': 'split1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatmentsWithConfig without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsWithConfig(['split1', 'split2']);

      expect(methodName, 'getTreatmentsWithConfig');
      expect(methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatmentsWithConfig with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsWithConfig(['split1', 'split2'], {'attr1': true});

      expect(methodName, 'getTreatmentsWithConfig');
      expect(methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });
  });

  group('track', () {
    test('track with traffic type & value', () async {
      SplitClient client = _getClient();

      client.track('my_event', trafficType: 'my_traffic_type', value: 25.10);
      expect(methodName, 'track');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'eventType': 'my_event',
        'trafficType': 'my_traffic_type',
        'value': 25.10
      });
    });

    test('track with value', () async {
      SplitClient client = _getClient();

      client.track('my_event', value: 25.10);
      expect(methodName, 'track');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'eventType': 'my_event',
        'value': 25.10
      });
    });

    test('track with traffic type', () async {
      SplitClient client = _getClient();

      client.track('my_event', trafficType: 'my_traffic_type');
      expect(methodName, 'track');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'eventType': 'my_event',
        'trafficType': 'my_traffic_type',
      });
    });
  });

  group('attributes', () {
    test('get single attribute', () async {
      SplitClient client = _getClient();

      client.getAttribute('attribute-name');
      expect(methodName, 'getAttribute');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributeName': 'attribute-name',
      });
    });

    test('get all attributes', () async {
      SplitClient client = _getClient();

      client.getAttributes();
      expect(methodName, 'getAllAttributes');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });

    test('set attribute', () async {
      SplitClient client = _getClient();

      client.setAttribute('my_attr', 'attr_value');
      expect(methodName, 'setAttribute');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributeName': 'my_attr',
        'value': 'attr_value',
      });
    });

    test('set multiple attributes', () async {
      SplitClient client = _getClient();

      client.setAttributes({
        'bool_attr': true,
        'number_attr': 25.56,
        'string_attr': 'attr-value',
        'list_attr': ['one', 'two'],
      });
      expect(methodName, 'setAttributes');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {
          'bool_attr': true,
          'number_attr': 25.56,
          'string_attr': 'attr-value',
          'list_attr': ['one', 'two'],
        }
      });
    });

    test('remove attribute', () async {
      SplitClient client = _getClient();

      client.removeAttribute('attr-name');
      expect(methodName, 'removeAttribute');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributeName': 'attr-name',
      });
    });

    test('clear attributes', () async {
      SplitClient client = _getClient();

      client.clearAttributes();
      expect(methodName, 'clearAttributes');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });

    test('flush', () async {
      SplitClient client = _getClient();

      client.flush();
      expect(methodName, 'flush');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });

    test('destroy', () async {
      SplitClient client = _getClient();

      client.destroy();
      expect(methodName, 'destroy');
      expect(methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });
  });

  group('events', () {
    test('onReady is returned from events listener', () {
      var splitEventsListenerStub = SplitEventsListenerStub();
      SplitClient client = _getClient(splitEventsListenerStub);
      splitEventsListenerStub.attachClient(client);

      var future = client.whenReady().then((value) => client == value);
      expect(splitEventsListenerStub.calledMethods['onReady'], 1);
      expect(splitEventsListenerStub.calledMethods['onReadyFromCache'], null);
      expect(splitEventsListenerStub.calledMethods['onTimeout'], null);
      expect(splitEventsListenerStub.calledMethods['onUpdated'], null);
      expect(future, completion(equals(true)));
    });

    test('onReadyFromCache is returned from events listener', () {
      var splitEventsListenerStub = SplitEventsListenerStub();
      SplitClient client = _getClient(splitEventsListenerStub);
      splitEventsListenerStub.attachClient(client);

      var future = client.whenReadyFromCache().then((value) => client == value);
      expect(splitEventsListenerStub.calledMethods['onReady'], null);
      expect(splitEventsListenerStub.calledMethods['onReadyFromCache'], 1);
      expect(splitEventsListenerStub.calledMethods['onTimeout'], null);
      expect(splitEventsListenerStub.calledMethods['onUpdated'], null);
      expect(future, completion(equals(true)));
    });

    test('onTimeout is returned from events listener', () {
      var splitEventsListenerStub = SplitEventsListenerStub();
      SplitClient client = _getClient(splitEventsListenerStub);
      splitEventsListenerStub.attachClient(client);

      var future = client.whenTimeout().then((value) => client == value);
      expect(splitEventsListenerStub.calledMethods['onReady'], null);
      expect(splitEventsListenerStub.calledMethods['onReadyFromCache'], null);
      expect(splitEventsListenerStub.calledMethods['onTimeout'], 1);
      expect(splitEventsListenerStub.calledMethods['onUpdated'], null);
      expect(future, completion(equals(true)));
    });

    test('onUpdated is returned from events listener', () {
      var splitEventsListenerStub = SplitEventsListenerStub();
      SplitClient client = _getClient(splitEventsListenerStub);
      splitEventsListenerStub.attachClient(client);

      var future =
          client.whenUpdated().first.then(((value) => client == value));
      expect(splitEventsListenerStub.calledMethods['onReady'], null);
      expect(splitEventsListenerStub.calledMethods['onReadyFromCache'], null);
      expect(splitEventsListenerStub.calledMethods['onTimeout'], null);
      expect(splitEventsListenerStub.calledMethods['onUpdated'], 1);
      expect(future, completion(equals(true)));
    });
  });
}

class SplitEventsListenerStub extends SplitEventsListener {
  Map<String, int> calledMethods = {};

  late final Future<SplitClient> _clientFuture;

  void attachClient(SplitClient splitClient) {
    _clientFuture = Future.value(splitClient);
  }

  @override
  Future<SplitClient> onReady() {
    calledMethods.update('onReady', (value) => value + 1, ifAbsent: () => 1);
    return _clientFuture;
  }

  @override
  Future<SplitClient> onReadyFromCache() {
    calledMethods.update('onReadyFromCache', (value) => value + 1,
        ifAbsent: () => 1);
    return _clientFuture;
  }

  @override
  Future<SplitClient> onTimeout() {
    calledMethods.update('onTimeout', (value) => value + 1, ifAbsent: () => 1);
    return _clientFuture;
  }

  @override
  Stream<SplitClient> onUpdated() {
    calledMethods.update('onUpdated', (value) => value + 1, ifAbsent: () => 1);
    return Stream.fromFuture(_clientFuture);
  }
}
