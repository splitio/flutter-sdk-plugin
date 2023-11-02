class SyncConfig {
  late Set<String> _names;
  late Set<String> _prefixes;
  late Set<String> _sets;

  Set<String> get names => _names;

  Set<String> get prefixes => _prefixes;

  Set<String> get sets => _sets;

  SyncConfig(
      {List<String> names = const [], List<String> prefixes = const []}) {
    _names = names.toSet();
    _prefixes = prefixes.toSet();
    _sets = <String>{};
  }

  SyncConfig.fromSet(
      {Set<String> names = const {}, Set<String> prefixes = const {}}) {
    _names = names;
    _prefixes = prefixes;
  }

  SyncConfig.flagSets(List<String> sets) {
    _sets = sets.toSet();
    _names = <String>{};
    _prefixes = <String>{};
  }
}
