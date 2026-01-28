/// Rollout cache configuration class.
class RolloutCacheConfiguration {
  late int _expirationDays;
  late bool _clearOnInit;

  /// The expiration days of the cache.
  int get expirationDays => _expirationDays;

  /// Whether to clear the cache on initialization.
  bool get clearOnInit => _clearOnInit;

  /// Creates a new RolloutCacheConfiguration instance.
  RolloutCacheConfiguration(
      {int expirationDays = 10, bool clearOnInit = false}) {
    if (expirationDays < 1) {
      expirationDays = 10;
    }
    _expirationDays = expirationDays;
    _clearOnInit = clearOnInit;
  }
}
