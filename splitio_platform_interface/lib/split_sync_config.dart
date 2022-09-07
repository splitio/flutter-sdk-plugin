class SyncConfig {
  late Set<String> _names;
  late Set<String> _prefixes;

  Set<String> get names => _names;

  Set<String> get prefixes => _prefixes;

  SyncConfig(
      {List<String> names = const [], List<String> prefixes = const []}) {
    _names = names.toSet();
    _prefixes = prefixes.toSet();
  }

  SyncConfig.fromSet(
      {Set<String> names = const {}, Set<String> prefixes = const {}}) {
    _names = names;
    _prefixes = prefixes;
  }
}
