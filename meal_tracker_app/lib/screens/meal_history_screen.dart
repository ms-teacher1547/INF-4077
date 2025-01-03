import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import 'add_meal_screen.dart';

// Ecran de l'historique des repas
class MealHistoryScreen extends StatefulWidget {
  final List<Meal> meals; // Liste des repas passés à l'écran
  final Function(Meal) onEditMeal; // Fonction pour éditer un repas
  final Function(String) onDeleteMeal; // Fonction pour supprimer un repas

  const MealHistoryScreen({
    super.key,
    required this.meals, // Initialisation de la liste de repas
    required this.onEditMeal, // Initialisation de la fonction d'édition
    required this.onDeleteMeal, // Initialisation de la fonction de suppression
  });

  @override
  _MealHistoryScreenState createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
  // Fonction pour afficher une boîte de dialogue de confirmation avant de supprimer un repas
  void _confirmDelete(BuildContext context, String mealId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'), // Titre de la boîte de dialogue
        content: const Text('Are you sure you want to delete this meal?'), // Message de confirmation
        actions: [
          // Bouton Annuler
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Ferme la boîte de dialogue si l'utilisateur annule
            },
            child: const Text('Cancel'),
          ),
          // Bouton Supprimer
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Ferme la boîte de dialogue après la suppression
              widget.onDeleteMeal(mealId); // Appelle la fonction pour supprimer le repas
              setState(() {}); // Rafraîchit l'interface pour refléter la suppression
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Fonction pour éditer un repas
  void _editMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddMealScreen(
          onAddMeal: (updatedMeal) {
            widget.onEditMeal(updatedMeal); // Met à jour le repas avec les nouvelles informations
            setState(() {}); // Rafraîchit l'interface pour afficher les changements
          },
          existingMeal: meal, // Passe le repas existant à l'écran d'édition
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal History')), // Titre de l'écran
      body: widget.meals.isEmpty // Si la liste des repas est vide
          ? const Center(child: Text('No meals recorded yet.')) // Affiche un message si aucun repas
          : ListView.builder( // Sinon, affiche la liste des repas
        itemCount: widget.meals.length, // Nombre d'éléments dans la liste
        itemBuilder: (ctx, index) { // Construction de chaque élément de la liste
          final meal = widget.meals[index]; // Récupère le repas actuel
          return Card(
            elevation: 4, // Donne de l'ombre pour un effet d'élévation
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Marge autour des cartes
            child: ListTile(
              title: Text(meal.name), // Affiche le nom du repas
              subtitle: Text(
                '${meal.calories} calories - ${meal.dateTime.toLocal()}', // Affiche les calories et la date
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // Permet de mettre les boutons à droite
                children: [
                  // Bouton pour éditer un repas
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue), // Icône de modification
                    onPressed: () {
                      _editMeal(context, meal); // Ouvre l'écran d'édition pour ce repas
                    },
                  ),
                  // Bouton pour supprimer un repas
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red), // Icône de suppression
                    onPressed: () {
                      _confirmDelete(context, meal.id); // Ouvre la boîte de confirmation avant suppression
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
