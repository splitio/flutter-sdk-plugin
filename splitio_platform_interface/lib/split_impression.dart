/// Represents an impression when a feature flag is evaluated.
class Impression {
  /// The traffic matching key.
  final String? key;

  /// The traffic bucketing key.
  final String? bucketingKey;

  /// The name of the feature flag.
  final String? split;

  /// The treatment value.
  final String? treatment;

  /// The impression timestamp.
  final num? time;

  /// The rule label.
  final String? appliedRule;

  /// The version of the feature flag.
  final num? changeNumber;

  /// The attributes.
  final Map<String, dynamic> attributes;

  /// The impression properties.
  final Map<String, dynamic>? properties;

  /// Creates a new Impression instance.
  Impression(this.key, this.bucketingKey, this.split, this.treatment, this.time,
      this.appliedRule, this.changeNumber, this.attributes, this.properties);

  /// Creates a new Impression instance from a map.
  static Impression fromMap(Map<dynamic, dynamic> map) {
    Map<String, dynamic>? properties;
    if (map['properties'] != null) {
      properties = Map<String, dynamic>.from(map['properties'] as Map);
    }
    return Impression(
        map['key'] as String?,
        map['bucketingKey'] as String?,
        map['split'] as String?,
        map['treatment'] as String?,
        map['time'] as num?,
        map['appliedRule'] as String?,
        map['changeNumber'] as num?,
        Map<String, dynamic>.from(map['attributes'] as Map),
        properties);
  }

  @override
  String toString() {
    return 'Impression = {"key":$key, "bucketingKey":$bucketingKey, "split":$split, "treatment":$treatment, "time":$time, "appliedRule": $appliedRule, "changeNumber":$changeNumber, "attributes":$attributes, "properties":$properties}';
  }
}
