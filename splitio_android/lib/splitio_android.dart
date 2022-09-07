import 'package:flutter/services.dart';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

const MethodChannel _methodChannel =
    MethodChannel('splitio.io/splitio_android');

/// Implementation for Android of [SplitioPlatform].
class SplitioAndroid extends MethodChannelPlatform {
  /// Registers this class as the default platform implementation.
  static void registerWith() {
    SplitioPlatform.instance = SplitioAndroid();
  }

  @override
  MethodChannel get methodChannel => _methodChannel;
}
