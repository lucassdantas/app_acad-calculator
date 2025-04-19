class BrazilianState {
  final String acronym;
  final String name;
  final List<String> cities;

  BrazilianState({
    required this.acronym,
    required this.name,
    required this.cities,
  });

  factory BrazilianState.fromJson(Map<String, dynamic> json) {
    return BrazilianState(
      acronym: json['sigla'],
      name: json['nome'],
      cities: List<String>.from(json['cidades']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'sigla': acronym, 'nome': name, 'cidades': cities};
  }
}
