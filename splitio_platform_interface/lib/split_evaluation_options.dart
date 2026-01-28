import 'dart:collection';

/// Options for evaluation.
class EvaluationOptions {
  final Map<String, dynamic> _properties;

  /// Impression properties.
  Map<String, dynamic> get properties => UnmodifiableMapView(_properties);

  /// Creates a new EvaluationOptions instance.
  const EvaluationOptions.empty() : _properties = const {};

  /// Creates a new EvaluationOptions instance.
  factory EvaluationOptions([Map<String, dynamic> properties = const {}]) {
    return EvaluationOptions._(
        Map.unmodifiable(Map<String, dynamic>.from(properties)));
  }

  /// Converts the EvaluationOptions to a JSON map.
  Map<String, dynamic> toJson() => {
        'properties': _properties,
      };

  const EvaluationOptions._(this._properties);
}
