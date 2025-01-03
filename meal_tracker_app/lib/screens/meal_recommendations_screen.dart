import 'package:flutter/material.dart';
import 'package:meal_tracker_app/models/meal_model.dart';

class MealRecommendationsScreen extends StatelessWidget {
  final double bmi; // IMC calculé

  const MealRecommendationsScreen({super.key, required this.bmi});

  // Méthode pour déterminer les recommandations en fonction de l'IMC
  List<Map<String, String>> _getRecommendations() {
    if (bmi < 18.5) {
      // Recommandations pour les personnes en insuffisance pondérale
      return [
        {'name': 'Ndolé with Plantains', 'image': 'assets/images/ndole.jpg'},
        {'name': 'Egusi Soup with Pounded Yam', 'image': 'assets/images/egusi.jpg'},
        {'name': 'Peanut Butter Stew', 'image': 'assets/images/peanut_stew.jpg'},
        {'name': 'Fufu and Groundnut Soup', 'image': 'assets/images/fufu.jpg'},
        {'name': 'Jollof Rice with Chicken', 'image': 'assets/images/jollof.jpg'},
        {'name': 'Ewa Agoyin (Mashed Beans)', 'image': 'assets/images/ewa_agoyin.jpg'},
        {'name': 'Suya with Roasted Corn', 'image': 'assets/images/suya.jpg'},
        {'name': 'Akara (Bean Fritters)', 'image': 'assets/images/akara.jpg'},
        {'name': 'Banana Akara', 'image': 'assets/images/banana_akara.jpg'},
        {'name': 'Moi Moi with Egg', 'image': 'assets/images/moi_moi.jpg'},
      ];
    } else if (bmi < 25) {
      // Recommandations pour les personnes avec un poids normal
      return [
        {'name': 'Grilled Tilapia with Kachumbari', 'image': 'assets/images/tilapia.jpg'},
        {'name': 'Ugali with Sukuma Wiki', 'image': 'assets/images/ugali.jpg'},
        {'name': 'Waakye with Shito Sauce', 'image': 'assets/images/waakye.jpg'},
        {'name': 'Gari Foto', 'image': 'assets/images/gari_foto.jpg'},
        {'name': 'Efo Riro (Spinach Stew)', 'image': 'assets/images/efo_riro.jpg'},
        {'name': 'Boiled Yam with Garden Egg Sauce', 'image': 'assets/images/yam.jpg'},
        {'name': 'Couscous with Vegetable Sauce', 'image': 'assets/images/couscous.jpg'},
        {'name': 'Tilapia Stew with Sweet Potatoes', 'image': 'assets/images/tilapia_stew.jpg'},
        {'name': 'Bambara Nut Porridge', 'image': 'assets/images/bambara_porridge.jpg'},
        {'name': 'Fonio Salad', 'image': 'assets/images/fonio.jpg'},
      ];
    } else if (bmi < 30) {
      // Recommandations pour les personnes en surpoids
      return [
        {'name': 'Grilled Goat Meat (Choma)', 'image': 'assets/images/goat_meat.jpg'},
        {'name': 'Okra Soup with Light Fufu', 'image': 'assets/images/okra_soup.jpg'},
        {'name': 'Rice and Beans with Vegetables', 'image': 'assets/images/rice_beans.jpg'},
        {'name': 'Green Banana Stew', 'image': 'assets/images/green_banana.jpg'},
        {'name': 'Ewedu Soup with Eba', 'image': 'assets/images/ewedu.jpg'},
        {'name': 'Vegetable Stew with Cassava', 'image': 'assets/images/cassava.jpg'},
        {'name': 'Koki Beans (Steamed Beans)', 'image': 'assets/images/koki.jpg'},
        {'name': 'Pepper Soup with Fish', 'image': 'assets/images/pepper_soup.jpg'},
        {'name': 'Boiled Plantains with Tomato Sauce', 'image': 'assets/images/plantain.jpg'},
        {'name': 'Zobo Drink with Light Snacks', 'image': 'assets/images/zobo.jpg'},
      ];
    } else {
      // Recommandations pour les personnes obèses
      return [
        {'name': 'Vegetable Salad with Avocado', 'image': 'assets/images/salad.jpg'},
        {'name': 'Grilled Catfish with Steamed Veggies', 'image': 'assets/images/catfish.jpg'},
        {'name': 'Fonio Porridge', 'image': 'assets/images/fonio_porridge.jpg'},
        {'name': 'Roasted Sweet Potatoes', 'image': 'assets/images/sweet_potatoes.jpg'},
        {'name': 'Steamed Okra with Pepper Sauce', 'image': 'assets/images/okra.jpg'},
        {'name': 'Acha Salad', 'image': 'assets/images/acha.jpg'},
        {'name': 'Cabbage Stir-Fry', 'image': 'assets/images/cabbage.jpg'},
        {'name': 'Boiled Yam with Spinach Sauce', 'image': 'assets/images/spinach.jpg'},
        {'name': 'Lentil Stew with Carrots', 'image': 'assets/images/lentils.jpg'},
        {'name': 'Zucchini Stew with Tofu', 'image': 'assets/images/zucchini_tofu.jpg'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = _getRecommendations(); // Obtenez les recommandations basées sur l'IMC

    return Scaffold(
      appBar: AppBar(title: const Text('Meal Recommendations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre affichant l'IMC de l'utilisateur
            Text(
              'Based on your BMI of ${bmi.toStringAsFixed(1)}, here are some meal recommendations:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Liste des repas sous forme de cartes
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
                          // Retourne le repas sélectionné à l'écran principal
                          final newMeal = Meal(
                            id: DateTime.now().toString(),
                            name: meal['name']!,
                            calories: 300, // Exemple de calories
                            dateTime: DateTime.now(),
                          );
                          Navigator.of(context).pop(newMeal);
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
