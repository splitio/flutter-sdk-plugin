import 'dart:core';

import 'package:splitio_platform_interface/split_prerequisite.dart';

/// Represents a feature flag
class SplitView {
  static const String _keyName = 'name';
  static const String _keyTrafficType = 'trafficType';
  static const String _keyKilled = 'killed';
  static const String _keyTreatments = 'treatments';
  static const String _keyChangeNumber = 'changeNumber';
  static const String _keyConfigs = 'configs';
  static const String _keyDefaultTreatment = 'defaultTreatment';
  static const String _keySets = 'sets';
  static const String _keyImpressionsDisabled = 'impressionsDisabled';
  static const String _keyPrerequisites = 'prerequisites';

  /// The name of the feature flag.
  String name;

  /// The traffic type of the feature flag.
  String trafficType;

  /// Whether the feature flag is killed.
  bool killed = false;

  /// The treatments of the feature flag.
  List<String> treatments = [];

  /// The change number of the feature flag.
  int? changeNumber;

  /// The configurations per treatment of the feature flag.
  Map<String, String> configs = {};

  /// The default treatment of the feature flag.
  String defaultTreatment;

  /// The sets of the feature flag.
  List<String> sets = [];

  /// Whether impressions are disabled for the feature flag.
  bool impressionsDisabled = false;

  /// The prerequisites of the feature flag.
  Set<Prerequisite> prerequisites = <Prerequisite>{};

  /// Creates a new SplitView instance.
  SplitView(this.name, this.trafficType, this.killed, this.treatments,
      this.changeNumber, this.configs,
      [this.defaultTreatment = '',
      this.sets = const [],
      this.impressionsDisabled = false,
      this.prerequisites = const <Prerequisite>{}]);

  /// Creates a SplitView instance from a map entry.
  static SplitView? fromEntry(Map<dynamic, dynamic>? entry) {
    if (entry == null || entry.isEmpty) {
      return null;
    }

    final Map<String, String> mappedConfig = {};
    entry[_keyConfigs]?.entries.forEach((MapEntry<dynamic, dynamic> entry) => {
          mappedConfig.addAll({entry.key.toString(): entry.value.toString()})
        });

    if (entry[_keyTreatments] == null) {
      entry[_keyTreatments] = entry[_keyTreatments] ?? [];
    }

    if (entry[_keySets] == null) {
      entry[_keySets] = [];
    }

    if (entry[_keyImpressionsDisabled] == null) {
      entry[_keyImpressionsDisabled] = false;
    }

    if (entry[_keyPrerequisites] == null) {
      entry[_keyPrerequisites] = [];
    }

    final List<dynamic> prereqRaw = (entry[_keyPrerequisites] as List?) ?? [];
    final Set<Prerequisite> prerequisites =
        prereqRaw.map((el) => Prerequisite.fromEntry(el)).toSet();

    return SplitView(
        entry[_keyName],
        entry[_keyTrafficType],
        entry[_keyKilled],
        (entry[_keyTreatments] as List).map((el) => el as String).toList(),
        entry[_keyChangeNumber],
        mappedConfig,
        entry[_keyDefaultTreatment] ?? '',
        (entry[_keySets] as List).map((el) => el as String).toList(),
        entry[_keyImpressionsDisabled] ?? false,
        prerequisites);
  }

  @override
  String toString() {
    return '''SplitView = {
      $_keyName: $name,
      $_keyTrafficType: $trafficType,
      $_keyKilled: $killed,
      $_keyTreatments: ${treatments.toString()},
      $_keyChangeNumber: $changeNumber,
      $_keyConfigs: $configs,
      $_keyDefaultTreatment: $defaultTreatment,
      $_keySets: ${sets.toString()},
      $_keyImpressionsDisabled: $impressionsDisabled
    }''';
  }
}
