import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_fallback_treatments_configuration.dart';
import 'package:splitio_platform_interface/split_result.dart';

void main() {
  test('global and by flag fallback treatments', () {
    var config = FallbackTreatmentsConfiguration(global: const SplitResult('custom-treatment', null));

    expect(config.global, equals({'treatment': 'custom-treatment', 'config': null}));
    expect(config.byFlag, null);

    config = FallbackTreatmentsConfiguration(byFlag: {'flag1': const SplitResult('custom-treatment', 'custom-config')});
    expect(config.byFlag, equals({'flag1': {'treatment': 'custom-treatment', 'config': 'custom-config'}}));
    expect(config.global, null);
  });

  test('default values', () {
    var config = FallbackTreatmentsConfiguration();

    expect(config.global, null);
    expect(config.byFlag, null);
  });
}