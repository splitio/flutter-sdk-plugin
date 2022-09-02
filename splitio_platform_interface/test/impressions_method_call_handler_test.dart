import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splitio/impressions/impressions_method_call_handler.dart';
import 'package:splitio/impressions/split_impression.dart';

void main() {
  test('correct impressionLog method call emits value on stream', () async {
    const Map<String, Object> sourceMap = {
      'key': 'key',
      'bucketingKey': 'bucketingKey',
      'split': 'split',
      'treatment': 'treatment',
      'time': 186839639,
      'appliedRule': 'appliedRule',
      'changeNumber': 12512512,
      'attributes': {'good': true},
    };

    ImpressionsMethodCallHandler impressionsMethodCallHandler =
        ImpressionsMethodCallHandler();

    final Impression expectedImpression = Impression.fromMap(sourceMap);

    impressionsMethodCallHandler.stream().listen(
      expectAsync1((impression) {
        expect(impression.key, expectedImpression.key);
        expect(impression.bucketingKey, expectedImpression.bucketingKey);
        expect(impression.split, expectedImpression.split);
        expect(impression.treatment, expectedImpression.treatment);
        expect(impression.time, expectedImpression.time);
        expect(impression.appliedRule, expectedImpression.appliedRule);
        expect(impression.changeNumber, expectedImpression.changeNumber);
        expect(impression.attributes, expectedImpression.attributes);
      }),
    );

    impressionsMethodCallHandler
        .handle(const MethodCall('impressionLog', sourceMap));
  });

  test('other method names are ignored', () async {
    ImpressionsMethodCallHandler impressionsMethodCallHandler =
        ImpressionsMethodCallHandler();

    impressionsMethodCallHandler.stream().listen(
          expectAsync1((event) {
            expect(event, null);
          }, count: 0),
        );
    impressionsMethodCallHandler.handle(const MethodCall('clientReady'));
  });
}
