class RolloutCacheConfiguration {

  late int _expirationDays;
  late bool _clearOnInit;

  int get expirationDays => _expirationDays;
  bool get clearOnInit => _clearOnInit;

  RolloutCacheConfiguration({int expirationDays = 10, bool clearOnInit = false}) {
    if (expirationDays < 1) {
      expirationDays = 10;
    }
    _expirationDays = expirationDays;
    _clearOnInit = clearOnInit;
  }
}
