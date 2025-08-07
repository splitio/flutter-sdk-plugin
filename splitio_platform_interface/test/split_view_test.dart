import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_prerequisite.dart';
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
      'defaultTreatment': 'on',
      'sets': ['set1', 'set2'],
      'impressionsDisabled': true,
      'prerequisites': [
        {
          'n:': 'pre1',
          't': ['on', 'off']
        },
        {
          'n': 'pre2',
          't': ['off']
        }
      ],
    });

    expect(splitView?.name, 'my_split');
    expect(splitView?.killed, true);
    expect(splitView?.treatments, ['yes', 'no']);
    expect(splitView?.configs, {'yes': '{"abc"}', 'no': '"wasd"'});
    expect(splitView?.changeNumber, 156246);
    expect(splitView?.trafficType, 'default');
    expect(splitView?.defaultTreatment, 'on');
    expect(splitView?.sets, ['set1', 'set2']);
    expect(splitView?.impressionsDisabled, true);
    expect(splitView?.prerequisites, {
      Prerequisite('pre1', {'on', 'off'}),
      Prerequisite('pre2', {'off'})
    });
  });
}
