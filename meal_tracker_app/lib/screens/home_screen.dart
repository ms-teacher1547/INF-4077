import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_tracker_app/screens/meal_recommendations_screen.dart';
import 'package:meal_tracker_app/screens/reservation_history_screen.dart';
import 'package:meal_tracker_app/screens/restaurant_map_screen.dart';
import '../models/meal_model.dart';
import 'chat_screen.dart';
import 'nearest_dietitian_screen.dart';
import 'profile_screen.dart';
import 'add_meal_screen.dart';
import 'meal_history_screen.dart';
import 'meal_statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Meal> _meals = [];
  int _caloricGoal = 2600; // Valeur par défaut
  double _bmi = 0; // IMC par défaut

  // Calcul des calories totales consommées aujourd'hui
  int _calculateTodayCalories() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    return _meals
        .where((meal) => meal.dateTime.isAfter(startOfDay))
        .fold(0, (total, meal) => total + meal.calories);
  }

  void _checkCaloricGoal() {
    final totalCalories = _calculateTodayCalories();
    if (totalCalories > _caloricGoal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You have exceeded your daily caloric goal of $_caloricGoal calories!',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                ).then((value) {
                  if (value != null && value is Map<String, dynamic>) {
                    setState(() {
                      _caloricGoal = value['caloricGoal'];
                      _bmi = value['bmi'];
                    });
                  }
                });
              },
              child: const Text('Go to Profile & BMI Calculator'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MealRecommendationsScreen(bmi: _bmi),
                  ),
                ).then((newMeal) {
                  if (newMeal != null && newMeal is Meal) {
                    setState(() {
                      _meals.add(newMeal);
                      _checkCaloricGoal();
                    });
                  }
                });
              },
              child: const Text('View Meal Recommendations'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddMealScreen(onAddMeal: (meal) {
                      setState(() {
                        _meals.add(meal);
                        _checkCaloricGoal();
                      });
                    }),
                  ),
                );
              },
              child: const Text('Add a Meal'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MealHistoryScreen(
                      meals: _meals,
                      onEditMeal: (updatedMeal) {
                        setState(() {
                          final index = _meals.indexWhere((meal) => meal.id == updatedMeal.id);
                          if (index != -1) {
                            _meals[index] = updatedMeal;
                          }
                        });
                      },
                      onDeleteMeal: (mealId) {
                        setState(() {
                          _meals.removeWhere((meal) => meal.id == mealId);
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('View Meal History'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MealStatisticsScreen(meals: _meals),
                  ),
                );
              },
              child: const Text('View Meal Statistics'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RestaurantMapScreen()),
                );
              },
              child: const Text('Find Nearest Restaurants'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ReservationHistoryScreen()),
                );
              },
              child: const Text('View Reservations'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DietitianMapScreen()),
                );
              },
              child: const Text('Find Nearest Dietitian'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: const Text('Open Chat-Bot'),
            ),
          ],
        ),
      ),
    );
  }
}
