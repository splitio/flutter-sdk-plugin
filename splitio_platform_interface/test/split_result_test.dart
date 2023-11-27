import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_result.dart';

void main() {
  test('result with config', () {
    const result = SplitResult('on', 'config');

    expect(result.treatment, 'on');
    expect(result.config, 'config');
    expect(result.toString(), '{"treatment": "on", config: "config"}');
  });

  test('result with null config', () {
    const result = SplitResult('on', null);

    expect(result.treatment, 'on');
    expect(result.config, null);
    expect(result.toString(), '{"treatment": "on", config: null}');
  });
}
