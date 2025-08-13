import 'package:flutter_test/flutter_test.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

import 'splitio_platform_stub.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  SplitioPlatformStub _platform = SplitioPlatformStub();

  SplitClient _getClient([SplitioPlatform? platform]) {
    if (platform != null) {
      return DefaultSplitClient(platform, 'matching-key', 'bucketing-key');
    }

    return DefaultSplitClient(_platform, 'matching-key', 'bucketing-key');
  }

  setUp(() {
    _platform = SplitioPlatformStub();
  });

  group('evaluationOptions tests', () {
    test('getTreatment includes evaluationOptions when non-empty', () async {
      final client = _getClient();
      final eo = EvaluationOptions({'x': 1, 'y': 'z'});

      await client.getTreatment('split', {}, eo);

      expect(_platform.methodName, 'getTreatment');
      expect(_platform.methodArguments, {
        'splitName': 'split',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {},
        'evaluationOptions': {
          'properties': {'x': 1, 'y': 'z'}
        }
      });
    });

    test('getTreatmentWithConfig includes evaluationOptions when non-empty',
        () async {
      final client = _getClient();
      final eo = EvaluationOptions({'x': 1, 'y': 'z'});

      await client.getTreatmentWithConfig('split1', {}, eo);

      expect(_platform.methodName, 'getTreatmentWithConfig');
      expect(_platform.methodArguments, {
        'splitName': 'split1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {},
        'evaluationOptions': {
          'properties': {'x': 1, 'y': 'z'}
        }
      });
    });

    test('getTreatments includes evaluationOptions when non-empty', () async {
      final client = _getClient();
      final eo = EvaluationOptions({'x': 1, 'y': 'z'});

      await client.getTreatments(['split1', 'split2'], {}, eo);

      expect(_platform.methodName, 'getTreatments');
      expect(_platform.methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {},
        'evaluationOptions': {
          'properties': {'x': 1, 'y': 'z'}
        }
      });
    });

    test('getTreatmentsWithConfig includes evaluationOptions when non-empty',
        () async {
      final client = _getClient();
      final eo = EvaluationOptions({'x': 1, 'y': 'z'});

      await client.getTreatmentsWithConfig(['split1', 'split2'], {}, eo);

      expect(_platform.methodName, 'getTreatmentsWithConfig');
      expect(_platform.methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {},
        'evaluationOptions': {
          'properties': {'x': 1, 'y': 'z'}
        }
      });
    });

    test('getTreatmentsByFlagSet includes evaluationOptions when non-empty',
        () async {
      final client = _getClient();
      final eo = EvaluationOptions({'x': 1, 'y': 'z'});

      await client.getTreatmentsByFlagSet('set_1', {}, eo);

      expect(_platform.methodName, 'getTreatmentsByFlagSet');
      expect(_platform.methodArguments, {
        'flagSet': 'set_1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {},
        'evaluationOptions': {
          'properties': {'x': 1, 'y': 'z'}
        }
      });
    });

    test('getTreatmentsByFlagSets includes evaluationOptions when non-empty',
        () async {
      final client = _getClient();
      final eo = EvaluationOptions({'x': 1, 'y': 'z'});

      await client.getTreatmentsByFlagSets(['set_1', 'set_2'], {}, eo);

      expect(_platform.methodName, 'getTreatmentsByFlagSets');
      expect(_platform.methodArguments, {
        'flagSets': ['set_1', 'set_2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {},
        'evaluationOptions': {
          'properties': {'x': 1, 'y': 'z'}
        }
      });
    });

    test(
        'getTreatmentsWithConfigByFlagSet includes evaluationOptions when non-empty',
        () async {
      final client = _getClient();
      final eo = EvaluationOptions({'x': 1, 'y': 'z'});

      await client.getTreatmentsWithConfigByFlagSet('set_1', {}, eo);

      expect(_platform.methodName, 'getTreatmentsWithConfigByFlagSet');
      expect(_platform.methodArguments, {
        'flagSet': 'set_1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {},
        'evaluationOptions': {
          'properties': {'x': 1, 'y': 'z'}
        }
      });
    });

    test(
        'getTreatmentsWithConfigByFlagSets includes evaluationOptions when non-empty',
        () async {
      final client = _getClient();
      final eo = EvaluationOptions({'x': 1, 'y': 'z'});

      await client
          .getTreatmentsWithConfigByFlagSets(['set_1', 'set_2'], {}, eo);

      expect(_platform.methodName, 'getTreatmentsWithConfigByFlagSets');
      expect(_platform.methodArguments, {
        'flagSets': ['set_1', 'set_2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {},
        'evaluationOptions': {
          'properties': {'x': 1, 'y': 'z'}
        }
      });
    });
  });

  group('evaluation', () {
    test('getTreatment without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatment('split');

      expect(_platform.methodName, 'getTreatment');
      expect(_platform.methodArguments, {
        'splitName': 'split',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatment with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatment('split', {'attr1': true});

      expect(_platform.methodName, 'getTreatment');
      expect(_platform.methodArguments, {
        'splitName': 'split',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatments without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatments(['split1', 'split2']);

      expect(_platform.methodName, 'getTreatments');
      expect(_platform.methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatments with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatments(['split1', 'split2'], {'attr1': true});

      expect(_platform.methodName, 'getTreatments');
      expect(_platform.methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentWithConfig with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentWithConfig('split1', {'attr1': true});

      expect(_platform.methodName, 'getTreatmentWithConfig');
      expect(_platform.methodArguments, {
        'splitName': 'split1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentWithConfig without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentWithConfig('split1');

      expect(_platform.methodName, 'getTreatmentWithConfig');
      expect(_platform.methodArguments, {
        'splitName': 'split1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatmentsWithConfig without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsWithConfig(['split1', 'split2']);

      expect(_platform.methodName, 'getTreatmentsWithConfig');
      expect(_platform.methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatmentsWithConfig with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsWithConfig(['split1', 'split2'], {'attr1': true});

      expect(_platform.methodName, 'getTreatmentsWithConfig');
      expect(_platform.methodArguments, {
        'splitName': ['split1', 'split2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentsByFlagSet without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsByFlagSet('set_1');

      expect(_platform.methodName, 'getTreatmentsByFlagSet');
      expect(_platform.methodArguments, {
        'flagSet': 'set_1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatmentsByFlagSet with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsByFlagSet('set_1', {'attr1': true});

      expect(_platform.methodName, 'getTreatmentsByFlagSet');
      expect(_platform.methodArguments, {
        'flagSet': 'set_1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentsByFlagSets without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsByFlagSets(['set_1', 'set_2']);

      expect(_platform.methodName, 'getTreatmentsByFlagSets');
      expect(_platform.methodArguments, {
        'flagSets': ['set_1', 'set_2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatmentsByFlagSets with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsByFlagSets(['set_1', 'set_2'], {'attr1': true});

      expect(_platform.methodName, 'getTreatmentsByFlagSets');
      expect(_platform.methodArguments, {
        'flagSets': ['set_1', 'set_2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentsWithConfigByFlagSet without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsWithConfigByFlagSet('set_1');

      expect(_platform.methodName, 'getTreatmentsWithConfigByFlagSet');
      expect(_platform.methodArguments, {
        'flagSet': 'set_1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatmentsWithConfigByFlagSet with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsWithConfigByFlagSet('set_1', {'attr1': true});

      expect(_platform.methodName, 'getTreatmentsWithConfigByFlagSet');
      expect(_platform.methodArguments, {
        'flagSet': 'set_1',
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {'attr1': true}
      });
    });

    test('getTreatmentsWithConfigByFlagSets without attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsWithConfigByFlagSets(['set_1', 'set_2']);

      expect(_platform.methodName, 'getTreatmentsWithConfigByFlagSets');
      expect(_platform.methodArguments, {
        'flagSets': ['set_1', 'set_2'],
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributes': {}
      });
    });

    test('getTreatmentsWithConfigByFlagSets with attributes', () async {
      SplitClient client = _getClient();

      client.getTreatmentsWithConfigByFlagSets(
          ['set_1', 'set_2'], {'attr1': true});

      expect(_platform.methodName, 'getTreatmentsWithConfigByFlagSets');
      expect(_platform.methodArguments, {
        'flagSets': ['set_1', 'set_2'],
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
      expect(_platform.methodName, 'track');
      expect(_platform.methodArguments, {
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
      expect(_platform.methodName, 'track');
      expect(_platform.methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'eventType': 'my_event',
        'value': 25.10
      });
    });

    test('track with traffic type', () async {
      SplitClient client = _getClient();

      client.track('my_event', trafficType: 'my_traffic_type');
      expect(_platform.methodName, 'track');
      expect(_platform.methodArguments, {
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
      expect(_platform.methodName, 'getAttribute');
      expect(_platform.methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributeName': 'attribute-name',
      });
    });

    test('get all attributes', () async {
      SplitClient client = _getClient();

      client.getAttributes();
      expect(_platform.methodName, 'getAllAttributes');
      expect(_platform.methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });

    test('set attribute', () async {
      SplitClient client = _getClient();

      client.setAttribute('my_attr', 'attr_value');
      expect(_platform.methodName, 'setAttribute');
      expect(_platform.methodArguments, {
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
      expect(_platform.methodName, 'setAttributes');
      expect(_platform.methodArguments, {
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
      expect(_platform.methodName, 'removeAttribute');
      expect(_platform.methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
        'attributeName': 'attr-name',
      });
    });

    test('clear attributes', () async {
      SplitClient client = _getClient();

      client.clearAttributes();
      expect(_platform.methodName, 'clearAttributes');
      expect(_platform.methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });

    test('flush', () async {
      SplitClient client = _getClient();

      client.flush();
      expect(_platform.methodName, 'flush');
      expect(_platform.methodArguments, {
        'matchingKey': 'matching-key',
        'bucketingKey': 'bucketing-key',
      });
    });

    test('destroy', () {
      _platform.destroy(
          matchingKey: 'matching-key', bucketingKey: 'bucketing-key');

      expect(_platform.methodName, 'destroy');
      expect(_platform.methodArguments,
          {'matchingKey': 'matching-key', 'bucketingKey': 'bucketing-key'});
    });
  });

  group('events', () {
    test('onReady', () {
      _platform.onReady(
          matchingKey: 'matching-key', bucketingKey: 'bucketing-key');

      expect(_platform.methodName, 'onReady');
      expect(_platform.methodArguments,
          {'matchingKey': 'matching-key', 'bucketingKey': 'bucketing-key'});
    });

    test('onReadyFromCache', () {
      _platform.onReadyFromCache(
          matchingKey: 'matching-key', bucketingKey: 'bucketing-key');

      expect(_platform.methodName, 'onReadyFromCache');
      expect(_platform.methodArguments,
          {'matchingKey': 'matching-key', 'bucketingKey': 'bucketing-key'});
    });

    test('onTimeout', () {
      _platform.onTimeout(
          matchingKey: 'matching-key', bucketingKey: 'bucketing-key');

      expect(_platform.methodName, 'onTimeout');
      expect(_platform.methodArguments,
          {'matchingKey': 'matching-key', 'bucketingKey': 'bucketing-key'});
    });

    test('onUpdated', () {
      _platform.onUpdated(
          matchingKey: 'matching-key', bucketingKey: 'bucketing-key');

      expect(_platform.methodName, 'onUpdated');
      expect(_platform.methodArguments,
          {'matchingKey': 'matching-key', 'bucketingKey': 'bucketing-key'});
    });
  });
}
