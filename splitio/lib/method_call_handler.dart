import 'package:flutter/services.dart';

abstract class MethodCallHandler {
  Future<void> handle(MethodCall call);
}

abstract class StreamMethodCallHandler<T> extends MethodCallHandler {
  Stream<T> stream();
}
