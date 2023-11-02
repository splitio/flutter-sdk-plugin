import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_sync_config.dart';

void main() {
  test('names and prefixes can be added simultaneously', () {
    var syncConfig = SyncConfig(names: ['name1'], prefixes: ['prefix1']);

    expect(syncConfig.names, ['name1']);
    expect(syncConfig.prefixes, ['prefix1']);
    expect(syncConfig.sets, []);
  });

  test('flagSets constructor allows only sets', () {
    var syncConfig = SyncConfig.flagSets(['set1','set2']);

    expect(syncConfig.names, []);
    expect(syncConfig.prefixes, []);
    expect(syncConfig.sets, ['set1','set2']);
  });
}
