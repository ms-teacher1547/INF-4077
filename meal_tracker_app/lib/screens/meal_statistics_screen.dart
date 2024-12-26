import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class MealStatisticsScreen extends StatelessWidget {
  final List<Meal> meals;

  const MealStatisticsScreen({super.key, required this.meals});

  // Calculer les calories totales pour une période donnée
  int _calculateTotalCalories(DateTime startDate, DateTime endDate) {
    return meals
        .where((meal) => meal.dateTime.isAfter(startDate) && meal.dateTime.isBefore(endDate))
        .fold(0, (total, meal) => total + meal.calories);
  }

  @override
  Widget build(BuildContext context) {
    // Dates pour les calculs
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final startOfWeek = startOfDay.subtract(Duration(days: today.weekday - 1)); // Lundi
    final startOfMonth = DateTime(today.year, today.month, 1);
    final startOfYear = DateTime(today.year, 1, 1);

    return Scaffold(
      appBar: AppBar(title: const Text('Meal Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calories Consumed:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('Today: ${_calculateTotalCalories(startOfDay, today.add(const Duration(days: 1)))} cal'),
            Text('This Week: ${_calculateTotalCalories(startOfWeek, today.add(const Duration(days: 1)))} cal'),
            Text('This Month: ${_calculateTotalCalories(startOfMonth, today.add(const Duration(days: 1)))} cal'),
            Text('This Year: ${_calculateTotalCalories(startOfYear, today.add(const Duration(days: 1)))} cal'),
          ],
        ),
      ),
    );
  }
}
