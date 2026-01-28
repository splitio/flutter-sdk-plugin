/// Certificate pinning configuration.
class CertificatePinningConfiguration {
  final Map<String, List<String>> _pins = {};

  /// Returns the pins.
  Map<String, List<String>> get pins => _pins;

  /// Adds a pin for the given host.
  CertificatePinningConfiguration addPin(String host, String pin) {
    pin = pin.trim();
    if (pin.isEmpty) {
      return this;
    }

    if (!_pins.containsKey(host)) {
      _pins[host] = [];
    }

    _pins[host]?.add(pin);
    return this;
  }
}
