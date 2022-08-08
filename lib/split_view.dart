import 'dart:core';

class SplitView {
  String name;
  String trafficType;
  bool killed = false;
  List<String> treatments = [];
  int changeNumber;
  Map<String, String> configs = {};

  SplitView(this.name, this.trafficType, this.killed, this.treatments,
      this.changeNumber, this.configs);

  static SplitView? fromEntry(MapEntry? entry) {
    if (entry == null) {
      return null;
    }

    return SplitView(
        entry.key,
        entry.value['trafficType'],
        entry.value['killed'],
        entry.value['treatments'],
        entry.value['changeNumber'] ?? -1,
        entry.value['configs']);
  }
}
