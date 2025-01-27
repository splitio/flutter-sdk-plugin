import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_rollout_cache_configuration.dart';

void main() {
  test('negative expirationDays defaults to 10', () {
    var config = RolloutCacheConfiguration(expirationDays: -1);

    expect(config.expirationDays, 10);
  });

  test('zero expirationDays defaults to 10', () {
    var config = RolloutCacheConfiguration(expirationDays: 0);

    expect(config.expirationDays, 10);
  });

  test('default values', () {
    var config = RolloutCacheConfiguration();

    expect(config.expirationDays, 10);
    expect(config.clearOnInit, false);
  });
}