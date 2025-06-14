class Character {
  final int id;
  final String name;
  final String image;
  final String species;
  final String status;

  const Character({
    required this.id,
    required this.name,
    required this.image,
    required this.species,
    required this.status,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      species: json['species'] as String,
      status: json['status'] as String,
    );
  }
}
