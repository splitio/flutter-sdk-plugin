import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_impression.dart';

void main() {
  test('from map creates correct Impression', () {
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

    Impression expectedImpression = Impression(
      'key',
      'bucketingKey',
      'split',
      'treatment',
      186839639,
      'appliedRule',
      12512512,
      {'good': true},
    );

    Impression impression = Impression.fromMap(sourceMap);
    expect(impression.key, expectedImpression.key);
    expect(impression.bucketingKey, expectedImpression.bucketingKey);
    expect(impression.split, expectedImpression.split);
    expect(impression.treatment, expectedImpression.treatment);
    expect(impression.time, expectedImpression.time);
    expect(impression.appliedRule, expectedImpression.appliedRule);
    expect(impression.changeNumber, expectedImpression.changeNumber);
    expect(impression.attributes, expectedImpression.attributes);
  });
}
