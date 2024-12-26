import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class AddMealScreen extends StatefulWidget {
  final Function(Meal) onAddMeal;
  final Meal? existingMeal; // Repas à modifier, null si on ajoute un nouveau repas

  const AddMealScreen({super.key, required this.onAddMeal, this.existingMeal});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _nameController = TextEditingController(); // Contrôleur pour le nom du repas
  final _caloriesController = TextEditingController(); // Contrôleur pour les calories

  @override
  void initState() {
    super.initState();
    // Si un repas existant est passé, pré-remplir les champs
    if (widget.existingMeal != null) {
      _nameController.text = widget.existingMeal!.name;
      _caloriesController.text = widget.existingMeal!.calories.toString();
    }
  }

  void _submitMeal() {
    final name = _nameController.text.trim(); // Nettoyer le texte saisi
    final caloriesText = _caloriesController.text.trim();

    if (name.isEmpty || caloriesText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly!')),
      );
      return;
    }

    final calories = int.tryParse(caloriesText);
    if (calories == null || calories <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number of calories!')),
      );
      return;
    }

    // Créer ou modifier un repas
    final newMeal = Meal(
      id: widget.existingMeal?.id ?? DateTime.now().toString(), // Conserve l'ID existant si modification
      name: name,
      calories: calories,
      dateTime: widget.existingMeal?.dateTime ?? DateTime.now(), // Conserve la date d'origine si modification
    );

    widget.onAddMeal(newMeal); // Ajoute ou met à jour le repas dans la liste
    Navigator.of(context).pop(); // Ferme l'écran
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingMeal == null ? 'Add a Meal' : 'Edit Meal'), // Change le titre selon le contexte
      ),
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
              child: Text(widget.existingMeal == null ? 'Add Meal' : 'Save Changes'), // Change le texte selon le contexte
            ),
          ],
        ),
      ),
    );
  }
}
