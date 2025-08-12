import 'dart:collection';

class EvaluationOptions {
  final Map<String, dynamic> _properties;

  Map<String, dynamic> get properties => UnmodifiableMapView(_properties);

  const EvaluationOptions.empty() : _properties = const {};

  factory EvaluationOptions([Map<String, dynamic> properties = const {}]) {
    return EvaluationOptions._(
        Map.unmodifiable(Map<String, dynamic>.from(properties)));
  }

  Map<String, dynamic> toJson() => {
        'properties': _properties,
      };

  const EvaluationOptions._(this._properties);
}
