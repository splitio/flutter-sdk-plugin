import 'package:flutter_test/flutter_test.dart';
import 'package:splitio_platform_interface/split_evaluation_options.dart';

void main() {
  group('EvaluationOptions', () {
    test('default constructor has empty properties and is unmodifiable', () {
      final eo = EvaluationOptions();
      expect(eo.properties, isEmpty);
      expect(() => eo.properties['x'] = 1, throwsA(isA<UnsupportedError>()));
      expect(() => eo.properties.remove('x'), throwsA(isA<UnsupportedError>()));
      expect(() => eo.properties.clear(), throwsA(isA<UnsupportedError>()));
    });

    test('constructor with properties stores them', () {
      final props = {'a': 1, 'b': true, 'c': 'x'};
      final eo = EvaluationOptions(props);
      expect(eo.properties, equals(props));
    });

    test('internal map is decoupled from external map (defensive copy)', () {
      final props = {'k': 42};
      final eo = EvaluationOptions(props);
      // Not the same instance
      expect(identical(eo.properties, props), isFalse);
      // Mutating the original does not change eo.properties
      props['k'] = 99;
      expect(eo.properties['k'], 42);
    });

    test('properties getter is unmodifiable (cannot mutate through accessor)',
        () {
      final eo = EvaluationOptions({'k': 1});
      expect(() => eo.properties['k'] = 2, throwsA(isA<UnsupportedError>()));
      expect(() => eo.properties.addAll({'z': 0}),
          throwsA(isA<UnsupportedError>()));
    });

    test('toJson returns a map with properties key', () {
      final props = {'x': 1, 'y': 'z'};
      final eo = EvaluationOptions(props);
      final json = eo.toJson();
      expect(json.keys, contains('properties'));
      expect(json['properties'], equals(props));
    });

    test('toJson returns empty properties for empty options', () {
      const eo = EvaluationOptions.empty();
      final json = eo.toJson();
      expect(json, equals({'properties': const {}}));
    });
  });
}
