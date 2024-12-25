import 'package:flutter/material.dart';
import 'package:meal_tracker_app/models/meal_model.dart';

class MealRecommendationsScreen extends StatelessWidget {
  final double bmi; // IMC calculé

  const MealRecommendationsScreen({super.key, required this.bmi});

  // Méthode pour déterminer les recommandations en fonction de l'IMC
  List<Map<String, String>> _getRecommendations() {
    if (bmi < 18.5) {
      return [
        {'name': 'Avocado Toast', 'image': 'assets/images/avocado_toast.jpg'},
        {'name': 'Peanut Butter Smoothie', 'image': 'assets/images/smoothie.jpg'},
        {'name': 'Whole Grain Pasta with Chicken', 'image': 'assets/images/pasta.jpg'},
      ];
    } else if (bmi < 25) {
      return [
        {'name': 'Grilled Salmon with Veggies', 'image': 'assets/images/salmon.jpg'},
        {'name': 'Quinoa Salad with Chickpeas', 'image': 'assets/images/quinoa_salad.jpg'},
        {'name': 'Oatmeal with Fruits', 'image': 'assets/images/oatmeal.jpg'},
      ];
    } else if (bmi < 30) {
      return [
        {'name': 'Steamed Broccoli with Grilled Chicken', 'image': 'assets/images/broccoli.jpg'},
        {'name': 'Vegetable Soup', 'image': 'assets/images/soup.jpg'},
        {'name': 'Brown Rice with Lentils', 'image': 'assets/images/rice_lentils.jpg'},
      ];
    } else {
      return [
        {'name': 'Green Salad with Tofu', 'image': 'assets/images/salad_tofu.jpg'},
        {'name': 'Zucchini Noodles with Tomato Sauce', 'image': 'assets/images/zucchini.jpg'},
        {'name': 'Baked Fish with Spinach', 'image': 'assets/images/fish_spinach.jpg'},
      ];
    }
  }


  @override
  Widget build(BuildContext context) {
    final recommendations = _getRecommendations();

    return Scaffold(
      appBar: AppBar(title: const Text('Meal Recommendations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Based on your BMI of ${bmi.toStringAsFixed(
                  1)}, here are some meal recommendations:',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final meal = recommendations[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.asset(
                        meal['image']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(meal['name']!),
                      trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            final newMeal = Meal(
                                id: DateTime.now().toString(),
                                name: meal['name']!,
                                calories: 300, // Exemple par defaut
                                dateTime: DateTime.now(),
                            );
                            Navigator.of(context).pop(newMeal); // Retourne le repas a l'ecran principal
                          },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
