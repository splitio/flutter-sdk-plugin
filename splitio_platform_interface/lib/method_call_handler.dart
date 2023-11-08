abstract class MethodCallHandler {
  Future<void> handle(String methodName, dynamic methodArguments);
}

abstract class StreamMethodCallHandler<T> extends MethodCallHandler {
  Stream<T> stream();
}
