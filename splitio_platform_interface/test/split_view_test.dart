import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_view.dart';

void main() {
  test('split view from empty map results in null object', () {
    var splitView = SplitView.fromEntry({});

    expect(splitView, null);
  });

  test('split view from null map results in null object', () {
    var splitView = SplitView.fromEntry(null);

    expect(splitView, null);
  });

  test('source values are mapped correctly', () {
    var splitView = SplitView.fromEntry({
      'name': 'my_split',
      'killed': true,
      'treatments': ['yes', 'no'],
      'configs': {'yes': '{"abc"}', 'no': '"wasd"'},
      'changeNumber': 156246,
      'trafficType': 'default',
    });

    expect(splitView?.name, 'my_split');
    expect(splitView?.killed, true);
    expect(splitView?.treatments, ['yes', 'no']);
    expect(splitView?.configs, {'yes': '{"abc"}', 'no': '"wasd"'});
    expect(splitView?.changeNumber, 156246);
    expect(splitView?.trafficType, 'default');
  });
}
