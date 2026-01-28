/// Sync configuration class for controlling which feature flags to fetch.
class SyncConfig {
  late Set<String> _names;
  late Set<String> _prefixes;
  late Set<String> _sets;

  /// Names of the feature flags to fetch.
  Set<String> get names => _names;

  /// Prefixes of the feature flags to fetch.
  Set<String> get prefixes => _prefixes;

  /// Flag sets of the feature flags to fetch.
  Set<String> get sets => _sets;

  /// Creates a new SyncConfig instance passing an optional list of names and prefixes.
  SyncConfig(
      {List<String> names = const [], List<String> prefixes = const []}) {
    _names = names.toSet();
    _prefixes = prefixes.toSet();
    _sets = <String>{};
  }

  /// Creates a new SyncConfig instance passing an optional set of names and prefixes.
  SyncConfig.fromSet(
      {Set<String> names = const {}, Set<String> prefixes = const {}}) {
    _names = names;
    _prefixes = prefixes;
  }

  /// Creates a new SyncConfig instance passing a list of flag sets.
  SyncConfig.flagSets(List<String> sets) {
    _sets = sets.toSet();
    _names = <String>{};
    _prefixes = <String>{};
  }
}
