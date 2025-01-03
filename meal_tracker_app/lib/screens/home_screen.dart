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
  final List<Meal> _meals = []; // Liste des repas enregistrés
  int _caloricGoal = 2600; // Objectif calorique par défaut
  double _bmi = 0; // IMC par défaut

  // Calcul des calories totales consommées aujourd'hui
  int _calculateTodayCalories() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    return _meals
        .where((meal) => meal.dateTime.isAfter(startOfDay))
        .fold(0, (total, meal) => total + meal.calories);
  }

  // Vérifie si l'objectif calorique est dépassé
  void _checkCaloricGoal() {
    final totalCalories = _calculateTodayCalories();
    if (totalCalories > _caloricGoal) {
      // Affiche une alerte si l'objectif est dépassé
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
        title: const Text('Welcome'), // Titre de la page
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Déconnexion de l'utilisateur
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0), // Ajoute des marges autour de la liste
          children: [
            // Bouton pour accéder au calculateur d'IMC et au profil
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
              child: const Text('BMI Calculator'),
            ),
            const SizedBox(height: 20),

            // Bouton pour accéder aux recommandations alimentaires
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
                      _checkCaloricGoal(); // Vérifie l'objectif calorique
                    });
                  }
                });
              },
              child: const Text('Meal Recommendations'),
            ),
            const SizedBox(height: 20),

            // Bouton pour ajouter un nouveau repas
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddMealScreen(onAddMeal: (meal) {
                      setState(() {
                        _meals.add(meal);
                        _checkCaloricGoal(); // Vérifie l'objectif calorique après ajout
                      });
                    }),
                  ),
                );
              },
              child: const Text('Add a Meal'),
            ),
            const SizedBox(height: 20),

            // Bouton pour voir l'historique des repas
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
                            _meals[index] = updatedMeal; // Mise à jour d'un repas
                          }
                        });
                      },
                      onDeleteMeal: (mealId) {
                        setState(() {
                          _meals.removeWhere((meal) => meal.id == mealId); // Suppression d'un repas
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('Meal History'),
            ),
            const SizedBox(height: 20),

            // Bouton pour afficher les statistiques des repas
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MealStatisticsScreen(meals: _meals),
                  ),
                );
              },
              child: const Text('Meal Statistics'),
            ),
            const SizedBox(height: 20),

            // Bouton pour trouver les restaurants les plus proches
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RestaurantMapScreen()),
                );
              },
              child: const Text('Nearest Restaurants'),
            ),
            const SizedBox(height: 20),

            // Bouton pour trouver un diététicien à proximité
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DietitianMapScreen()),
                );
              },
              child: const Text('Nearest Dietitian'),
            ),
            const SizedBox(height: 20),

            // Bouton pour voir l'historique des réservations
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ReservationHistoryScreen()),
                );
              },
              child: const Text('View Reservations'),
            ),
            const SizedBox(height: 20),

            // Bouton pour ouvrir le chatbot
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: const Text('Chat-Bot'),
            ),
          ],
        ),
      ),
    );
  }
}
