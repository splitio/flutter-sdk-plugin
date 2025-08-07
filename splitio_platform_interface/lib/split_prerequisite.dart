class Prerequisite {
  final String _name;

  final Set<String> _treatments;

  String get name => _name;

  Set<String> get treatments => _treatments;

  Prerequisite(this._name, this._treatments);

  static Prerequisite fromEntry(el) {
    final String name = (el['n'] ?? el['n:'] ?? '').toString();
    final List<dynamic> rawTreatments = (el['t'] as List<dynamic>?) ?? [];
    final Set<String> treatments =
        rawTreatments.map((e) => e.toString()).toSet();

    return Prerequisite(name, treatments);
  }

  @override
  String toString() {
    return '''Prerequisite = {
      name: $name,
      treatments: $treatments
    }''';
  }

  equals(Prerequisite other) {
    return name == other.name && treatments == other.treatments;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Prerequisite &&
        name == other.name &&
        other.treatments.containsAll(treatments);
  }

  @override
  int get hashCode {
    int treatmentsHash = 0;
    for (final t in _treatments) {
      treatmentsHash ^= t.hashCode;
    }
    return name.hashCode ^ treatmentsHash;
  }
}
