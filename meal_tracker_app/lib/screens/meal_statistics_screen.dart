import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Pour les graphiques
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

  // Obtenir le repas le plus calorique pour une période donnée
  Meal? _getHighestCalorieMeal(DateTime startDate, DateTime endDate) {
   final filteredMeals = meals
       .where((meal) => meal.dateTime.isAfter(startDate) && meal.dateTime.isBefore(endDate))
       .toList();

   if (filteredMeals.isEmpty) {
     return null; // Aucun repas dans la periode donnee
   }

   return filteredMeals.reduce((a, b) => a.calories > b.calories ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    // Déterminer les périodes
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final startOfWeek = startOfDay.subtract(Duration(days: today.weekday - 1));
    final startOfMonth = DateTime(today.year, today.month, 1);
    final startOfYear = DateTime(today.year, 1, 1);

    // Calculer les calories pour chaque période
    final caloriesToday = _calculateTotalCalories(startOfDay, today);
    final caloriesWeek = _calculateTotalCalories(startOfWeek, today);
    final caloriesMonth = _calculateTotalCalories(startOfMonth, today);
    final caloriesYear = _calculateTotalCalories(startOfYear, today);

    // Obtenir les repas les plus caloriques
    final highestMealToday = _getHighestCalorieMeal(startOfDay, today);
    final highestMealWeek = _getHighestCalorieMeal(startOfWeek, today);

    return Scaffold(
      appBar: AppBar(title: const Text('Meal Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Meal Statistics', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),

            // Graphique des calories
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: caloriesToday.toDouble(), color: Colors.blue)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: caloriesWeek.toDouble(), color: Colors.green)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: caloriesMonth.toDouble(), color: Colors.orange)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: caloriesYear.toDouble(), color: Colors.red)]),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 1:
                            return const Text('Today');
                          case 2:
                            return const Text('Week');
                          case 3:
                            return const Text('Month');
                          case 4:
                            return const Text('Year');
                          default:
                            return const Text('');
                        }
                      }),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Détails des statistiques
            Card(
              child: ListTile(
                leading: const Icon(Icons.local_fire_department, color: Colors.blue),
                title: Text('Today: $caloriesToday cal'),
                subtitle: Text(
                  highestMealToday != null
                      ? 'Highest: ${highestMealToday.name} (${highestMealToday.calories} cal)'
                      : 'No meals today',
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.green),
                title: Text('This Week: $caloriesWeek cal'),
                subtitle: Text(
                  highestMealWeek != null
                      ? 'Highest: ${highestMealWeek.name} (${highestMealWeek.calories} cal)'
                      : 'No meals this week',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
