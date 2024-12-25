import 'package:flutter/material.dart';
import 'package:meal_tracker_app/models/meal_model.dart';

class MealHistoryScreen extends StatelessWidget {
  final List<Meal> meals;

  MealHistoryScreen({required this.meals});

  @override
  Widget build(BuildContext comtext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal History'),
      ),
      body: meals.isEmpty
        ? const Center(child: Text('No meals recorded yet.'))
        : ListView.builder(
          itemCount: meals.length,
          itemBuilder: (ctx, index) {
            final meal = meals[index];
            return ListTile(
              title: Text(meal.name),
              subtitle: Text(
                '${meal.calories} calories - ${meal.dateTime.toLocal()}'
              ),
            );
          },
      ),
    );
  }
}