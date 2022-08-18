class SyncConfig {
  late final Set<String> _names;
  late final Set<String> _prefixes;

  get names => _names;

  get prefixes => _prefixes;

  SyncConfig({Set<String> names = const {}, Set<String> prefixes = const {}}) {
    _names = names;
    _prefixes = prefixes;
  }
}
