import 'dart:core';

class SplitView {
  String name;
  String trafficType;
  bool killed = false;
  List<String> treatments = [];
  int changeNumber;
  Map<String, String> configs = {};
  String defaultTreatment;
  List<String> sets = [];

  SplitView(this.name, this.trafficType, this.killed, this.treatments,
      this.changeNumber, this.configs,
      [this.defaultTreatment = '', this.sets = const []]);

  static SplitView? fromEntry(Map<dynamic, dynamic>? entry) {
    if (entry == null || entry.isEmpty) {
      return null;
    }

    final Map<String, String> mappedConfig = {};
    entry['configs']?.entries.forEach((MapEntry<dynamic, dynamic> entry) => {
          mappedConfig.addAll({entry.key.toString(): entry.value.toString()})
        });

    if (entry['treatments'] == null) {
      entry['treatments'] = entry['treatments'] ?? [];
    }

    if (entry['sets'] == null) {
      entry['sets'] = [];
    }

    return SplitView(
        entry['name'],
        entry['trafficType'],
        entry['killed'],
        (entry['treatments'] as List).map((el) => el as String).toList(),
        entry['changeNumber'],
        mappedConfig,
        entry['defaultTreatment'] ?? '',
        (entry['sets'] as List).map((el) => el as String).toList()
    );
  }

  @override
  String toString() {
    return '''SplitView = {
      name: $name,
      trafficType: $trafficType,
      killed: $killed,
      treatments: ${treatments.toString()},
      changeNumber: $changeNumber,
      config: $configs,
      defaultTreatment: $defaultTreatment,
      sets: ${sets.toString()}
    }''';
  }
}
