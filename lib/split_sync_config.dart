class SyncConfig {
  late final Set<String> _names;
  late final Set<String> _prefixes;

  Set<String> get names => _names;

  Set<String> get prefixes => _prefixes;

  SyncConfig({Set<String> names = const {}, Set<String> prefixes = const {}}) {
    _names = names;
    _prefixes = prefixes;
  }
}
