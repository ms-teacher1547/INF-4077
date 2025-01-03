import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Pour permettre de sélectionner une image depuis la galerie
import '../models/meal_model.dart';

class AddMealScreen extends StatefulWidget {
  final Function(Meal) onAddMeal; // Fonction pour ajouter ou modifier un repas
  final Meal? existingMeal; // Repas à modifier, null si on ajoute un nouveau repas

  const AddMealScreen({super.key, required this.onAddMeal, this.existingMeal});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _nameController = TextEditingController(); // Contrôleur pour le champ du nom
  final _caloriesController = TextEditingController(); // Contrôleur pour le champ des calories
  String? _imagePath; // Chemin de l'image sélectionnée

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs si un repas existant est passé
    if (widget.existingMeal != null) {
      _nameController.text = widget.existingMeal!.name;
      _caloriesController.text = widget.existingMeal!.calories.toString();
    }
  }

  // Méthode pour sélectionner une image depuis la galerie
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Ouvre la galerie

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path; // Stocke le chemin de l'image
      });
    }
  }

  // Méthode pour valider et soumettre le repas
  void _submitMeal() {
    final name = _nameController.text.trim(); // Nettoyer et récupérer le texte du nom
    final caloriesText = _caloriesController.text.trim(); // Nettoyer et récupérer les calories

    // Vérifier si les champs sont remplis
    if (name.isEmpty || caloriesText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly!')),
      );
      return;
    }

    // Vérifier si les calories sont valides
    final calories = int.tryParse(caloriesText);
    if (calories == null || calories <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number of calories!')),
      );
      return;
    }

    // Créer un objet Meal avec les données saisies
    final newMeal = Meal(
      id: widget.existingMeal?.id ?? DateTime.now().toString(), // Conserver l'ID existant ou en générer un nouveau
      name: name,
      calories: calories,
      dateTime: widget.existingMeal?.dateTime ?? DateTime.now(), // Conserver la date d'origine ou en créer une nouvelle
      imagePath: _imagePath, // Inclure l'image si disponible
    );

    // Appeler la fonction pour ajouter ou mettre à jour le repas
    widget.onAddMeal(newMeal);
    Navigator.of(context).pop(); // Fermer l'écran après la soumission
  }

  // Méthode pour réinitialiser les champs
  void _resetFields() {
    setState(() {
      _nameController.clear(); // Efface le texte du nom
      _caloriesController.clear(); // Efface le texte des calories
      _imagePath = null; // Supprime l'image sélectionnée
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Titre de l'écran qui change selon si c'est un ajout ou une modification
        title: Text(widget.existingMeal == null ? 'Add a Meal' : 'Edit Meal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prévisualisation de l'image sélectionnée
            if (_imagePath != null)
              Image.file(
                File(_imagePath!), // Affiche l'image sélectionnée
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover, // S'assure que l'image occupe tout l'espace disponible
              ),
            const SizedBox(height: 10),

            // Bouton pour choisir une image
            TextButton.icon(
              onPressed: _pickImage, // Appelle la méthode pour choisir une image
              icon: const Icon(Icons.image),
              label: const Text('Add Meal Image'),
            ),
            const SizedBox(height: 10),

            // Champ pour le nom du repas
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Meal Name',
                prefixIcon: const Icon(Icons.fastfood), // Icône pour illustrer le champ
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),

            // Champ pour les calories
            TextField(
              controller: _caloriesController,
              decoration: InputDecoration(
                labelText: 'Calories',
                prefixIcon: const Icon(Icons.local_fire_department), // Icône pour illustrer les calories
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number, // Type clavier numérique
            ),
            const SizedBox(height: 20),

            // Boutons pour soumettre ou réinitialiser
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Bouton pour ajouter ou sauvegarder
                ElevatedButton.icon(
                  onPressed: _submitMeal,
                  icon: const Icon(Icons.save),
                  label: Text(widget.existingMeal == null ? 'Add Meal' : 'Save Changes'),
                ),
                // Bouton pour réinitialiser les champs
                ElevatedButton.icon(
                  onPressed: _resetFields,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
