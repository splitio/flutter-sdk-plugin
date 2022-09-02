class Impression {
  final String? key;
  final String? bucketingKey;
  final String? split;
  final String? treatment;
  final num? time;
  final String? appliedRule;
  final num? changeNumber;
  final Map<String, dynamic> attributes;

  Impression(this.key, this.bucketingKey, this.split, this.treatment, this.time,
      this.appliedRule, this.changeNumber, this.attributes);

  static Impression fromMap(Map<dynamic, dynamic> map) {
    return Impression(
        map['key'] as String?,
        map['bucketingKey'] as String?,
        map['split'] as String?,
        map['treatment'] as String?,
        map['time'] as num?,
        map['appliedRule'] as String?,
        map['changeNumber'] as num?,
        Map<String, dynamic>.from(map['attributes'] as Map));
  }

  @override
  String toString() {
    return 'Impression = {"key":$key, "bucketingKey":$bucketingKey, "split":$split, "treatment":$treatment, "time":$time, "appliedRule": $appliedRule, "changeNumber":$changeNumber, "attributes":$attributes}';
  }
}
