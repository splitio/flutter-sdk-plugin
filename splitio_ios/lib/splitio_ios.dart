import 'package:flutter/services.dart';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

const MethodChannel _methodChannel = MethodChannel('split.io/splitio_ios');

/// Implementation for iOS of [SplitioPlatform].
class SplitioIOS extends MethodChannelPlatform {
  /// Registers this class as the default platform implementation.
  static void registerWith() {
    SplitioPlatform.instance = SplitioIOS();
  }

  @override
  MethodChannel get methodChannel => _methodChannel;
}
