class Mentee {
  final String id;
  final String name;
  final String? imageUrl;
  final int totalPoints;

  Mentee({required this.id, required this.name, this.imageUrl, this.totalPoints = 0});
}
