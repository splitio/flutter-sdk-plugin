import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_fallback_treatment.dart';
import 'package:splitio_platform_interface/split_fallback_treatments_configuration.dart';

void main() {
  test('global and by flag fallback treatments', () {
    var config = FallbackTreatmentsConfiguration(
        global: const FallbackTreatment('custom-treatment'));

    expect(config.global,
        equals({'treatment': 'custom-treatment', 'config': null}));
    expect(config.byFlag, null);

    config = FallbackTreatmentsConfiguration(byFlag: {
      'flag1': const FallbackTreatment('custom-treatment-1', 'custom-config-1'),
      'flag2': const FallbackTreatment('custom-treatment-2', 'custom-config-2')
    });
    expect(
        config.byFlag,
        equals({
          'flag1': {
            'treatment': 'custom-treatment-1',
            'config': 'custom-config-1'
          },
          'flag2': {
            'treatment': 'custom-treatment-2',
            'config': 'custom-config-2'
          }
        }));
    expect(config.global, null);
  });

  test('default values', () {
    var config = FallbackTreatmentsConfiguration();

    expect(config.global, null);
    expect(config.byFlag, null);
  });
}
