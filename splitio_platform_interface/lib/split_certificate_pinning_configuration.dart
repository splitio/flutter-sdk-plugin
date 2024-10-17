class CertificatePinningConfiguration {

  final Map<String, List<String>> _pins = {};

  Map<String, List<String>> get pins => _pins;

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