/// Abstract class for handling method calls.
abstract class MethodCallHandler {
  /// Handles a method call with the given method name and arguments.
  Future<void> handle(String methodName, dynamic methodArguments);
}

/// Abstract class for handling stream method calls.
abstract class StreamMethodCallHandler<T> extends MethodCallHandler {
  /// Returns a stream of the given type.
  Stream<T> stream();
}
