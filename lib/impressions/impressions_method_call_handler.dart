import 'dart:async';

import 'package:flutter/services.dart';
import 'package:splitio/impressions/split_impression.dart';
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
