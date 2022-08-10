import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/method_call_handler.dart';

class ImpressionsMethodCallHandler extends StreamMethodCallHandler<Impression> {
  final _streamController = StreamController<Impression>();

  @override
  Future<void> handle(MethodCall call) async {
    if (call.method == 'impressionLog') {
      _streamController.add(
          Impression.fromMap(Map<String, dynamic>.from(call.arguments ?? {})));
    }
  }

  @override
  Stream<Impression> stream() {
    return _streamController.stream;
  }
}

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
