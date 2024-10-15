class CertificatePinningConfiguration {

  final Map<String, Set<String>> _pins = {};

  Map<String, Set<String>> get pins => _pins;

  CertificatePinningConfiguration addPin(String host, String pin) {
    pin = pin.trim();
    if (pin.isEmpty) {
      return this;
    }

    if (!_pins.containsKey(host)) {
      _pins[host] = <String>{};
    }

    _pins[host]?.add(pin);
    return this;
  }
}