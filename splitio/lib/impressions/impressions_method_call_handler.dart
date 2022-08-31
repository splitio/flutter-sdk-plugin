import 'dart:async';

import 'package:splitio/impressions/split_impression.dart';
import 'package:splitio/method_call_handler.dart';

class ImpressionsMethodCallHandler extends StreamMethodCallHandler<Impression> {
  final _streamController = StreamController<Impression>();

  @override
  Future<void> handle(String methodName, dynamic methodArguments) async {
    if (methodName == 'impressionLog') {
      if (_streamController.hasListener &&
          !_streamController.isPaused &&
          !_streamController.isClosed) {
        _streamController.add(Impression.fromMap(
            Map<String, dynamic>.from(methodArguments ?? {})));
      }
    }
  }

  @override
  Stream<Impression> stream() {
    return _streamController.stream;
  }
}
