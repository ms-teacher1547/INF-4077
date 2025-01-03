class Meal {
  final String id; // Identifiant unique
  final String name;
  final int calories;
  final DateTime dateTime;
  final String? imagePath; //

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.dateTime,
    this.imagePath
  });
}