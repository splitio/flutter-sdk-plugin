import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_certificate_pinning_configuration.dart';

void main() {
  test('single pin can be added', () {
    var config = CertificatePinningConfiguration();
    config.addPin('host', 'pin');

    expect(config.pins, {
      'host': {'pin'}
    });
  });

  test('multiple pins can be added for the same host', () {
    var config = CertificatePinningConfiguration();
    config.addPin('host', 'pin1');
    config.addPin('host', 'pin2');

    expect(config.pins, {
      'host': {'pin1', 'pin2'}
    });
  });

  test('multiple pins can be added for multiple hosts', () {
    var config = CertificatePinningConfiguration();
    config.addPin('host1', 'pin1');
    config.addPin('host2', 'pin2');
    config.addPin('host1', 'pin2');

    expect(config.pins, {
      'host1': {'pin1', 'pin2'},
      'host2': {'pin2'}
    });
  });

  test('same pin for same host is not duplicated', () {
    var config = CertificatePinningConfiguration();
    config.addPin('host', 'pin');
    config.addPin('host', 'pin');

    expect(config.pins, {
      'host': {'pin'}
    });
  });

  test('only whitespace pin is not added', () {
    var config = CertificatePinningConfiguration();
    config.addPin('host', ' ');

    expect(config.pins, {});
  });

  test('empty pin is not added', () {
    var config = CertificatePinningConfiguration();
    config.addPin('host', '');

    expect(config.pins, {});
  });
}
