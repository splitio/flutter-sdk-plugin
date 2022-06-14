import 'dart:core';

class SplitView {
  String? name;
  String? trafficType;
  bool? killed = false;
  List<String>? treatments = [];
  int? changeNumber;
  Map<String, String>? configs = {};

  SplitView(
      {this.name,
      this.trafficType,
      this.killed,
      this.treatments,
      this.changeNumber,
      this.configs});
}
