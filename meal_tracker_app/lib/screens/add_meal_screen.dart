import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class AddMealScreen extends StatefulWidget {
  final Function(Meal) onAddMeal;

  AddMealScreen({required this.onAddMeal});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _nameController = TextEditingController(); // Contrôleur pour le nom du repas
  final _caloriesController = TextEditingController(); // Contrôleur pour les calories

  void _submitMeal() {
    final name = _nameController.text.trim(); // Récupérer et nettoyer le nom
    final caloriesText = _caloriesController.text.trim(); // Récupérer et nettoyer les calories

    if (name.isEmpty || caloriesText.isEmpty) {
      // Vérifie si un champ est vide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly!')),
      );
      return;
    }

    final calories = int.tryParse(caloriesText); // Convertir les calories en entier

    if (calories == null || calories <= 0) {
      // Vérifie si les calories sont valides
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number of calories!')),
      );
      return;
    }

    // Créer un nouvel objet Meal si tout est correct
    final newMeal = Meal(
      id: DateTime.now().toString(),
      name: name,
      calories: calories,
      dateTime: DateTime.now(),
    );

    widget.onAddMeal(newMeal); // Ajoute le repas à la liste principale
    Navigator.of(context).pop(); // Ferme l'écran
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a Meal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Meal Name'),
            ),
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitMeal,
              child: const Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
