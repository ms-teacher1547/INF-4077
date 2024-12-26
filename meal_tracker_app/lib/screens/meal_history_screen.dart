import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import 'add_meal_screen.dart';

class MealHistoryScreen extends StatefulWidget {
  final List<Meal> meals;
  final Function(Meal) onEditMeal;
  final Function(String) onDeleteMeal;

  const MealHistoryScreen({
    super.key,
    required this.meals,
    required this.onEditMeal,
    required this.onDeleteMeal,
  });

  @override
  _MealHistoryScreenState createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
  void _confirmDelete(BuildContext context, String mealId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this meal?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Ferme la boîte de dialogue
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Ferme la boîte de dialogue
              widget.onDeleteMeal(mealId); // Supprime le repas
              setState(() {}); // Rafraîchit l’interface
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddMealScreen(
          onAddMeal: (updatedMeal) {
            widget.onEditMeal(updatedMeal); // Met à jour le repas
            setState(() {}); // Rafraîchit l’interface
          },
          existingMeal: meal, // Passe le repas à modifier
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal History')),
      body: widget.meals.isEmpty
          ? const Center(child: Text('No meals recorded yet.'))
          : ListView.builder(
        itemCount: widget.meals.length,
        itemBuilder: (ctx, index) {
          final meal = widget.meals[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(meal.name),
              subtitle: Text(
                  '${meal.calories} calories - ${meal.dateTime.toLocal()}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editMeal(context, meal); // Lance l’édition
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmDelete(context, meal.id); // Lance la suppression
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
