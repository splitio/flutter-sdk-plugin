import 'package:flutter_web_plugins/flutter_web_plugins.dart' show Registrar;
import 'package:splitio_platform_interface/splitio_platform_interface.dart';

/// Web implementation of [SplitioPlatform].
class SplitioWeb extends SplitioPlatform {
  /// Registers this class as the default platform implementation.
  static void registerWith(Registrar registrar) {
    SplitioPlatform.instance = SplitioWeb();
  }

}
