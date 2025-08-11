import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_prerequisite.dart';

void main() {
  group('Prerequisite', () {
    test('fromEntry creates correct instance', () {
      final entry = {
        'n': 'feature1',
        't': ['on', 'off']
      };
      final prereq = Prerequisite.fromEntry(entry);
      expect(prereq.name, 'feature1');
      expect(prereq.treatments, {'on', 'off'});
    });

    test('equality and hashCode', () {
      final a = Prerequisite('feat', {'a', 'b'});
      final b = Prerequisite('feat', {'b', 'a'});
      final c = Prerequisite('feat2', {'a', 'b'});
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('toString contains name and treatments', () {
      final prereq = Prerequisite('myFeature', {'t1'});
      final str = prereq.toString();
      expect(str, contains('myFeature'));
      expect(str, contains('t1'));
    });
  });
}
