import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _caloricGoalController = TextEditingController();
  String _bmiResult = "";
  String _bmiInterpretation = "";

  // Méthode pour calculer l'IMC
  void _calculateBMI() {
    final height = double.tryParse(_heightController.text.trim()) ?? 0;
    final weight = double.tryParse(_weightController.text.trim()) ?? 0;

    if (height > 0 && weight > 0) {
      final heightInMeters = height / 100;
      final bmi = weight / (heightInMeters * heightInMeters);
      setState(() {
        _bmiResult = bmi.toStringAsFixed(2);
        if (bmi < 18.5) {
          _bmiInterpretation = "Underweight";
        } else if (bmi < 25) {
          _bmiInterpretation = "Normal weight";
        } else if (bmi < 30) {
          _bmiInterpretation = "Overweight";
        } else {
          _bmiInterpretation = "Obesity";
        }
      });
    } else {
      setState(() {
        _bmiResult = "Invalid input";
        _bmiInterpretation = "";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid height and weight.')),
        );
      });
    }
  }

  // Méthode pour sauvegarder les données et retourner à l'écran précédent
  void _saveAndReturn() {
    final bmi = double.tryParse(_bmiResult) ?? 0;
    final caloricGoal = int.tryParse(_caloricGoalController.text.trim()) ?? 2600;

    if (_bmiResult == "Invalid input") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please calculate a valid BMI before saving.')),
      );
      return;
    }

    Navigator.of(context).pop({
      'bmi': bmi,
      'caloricGoal': caloricGoal,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & BMI Calculator'),
      ),
      body: Stack(
        children: [
          // Arrière-plan avec une image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'), // Chemin vers votre image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image en haut
                  Center(
                    child: Image.asset(
                      'assets/images/BMI-Calculator.jpg', // Chemin vers une image pour le profil
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Champs de saisie
                  TextField(
                    controller: _heightController,
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _caloricGoalController,
                    decoration: InputDecoration(
                      labelText: 'Daily Caloric Goal',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  // Bouton pour calculer l'IMC
                  ElevatedButton.icon(
                    onPressed: _calculateBMI,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate BMI'),
                  ),
                  const SizedBox(height: 20),
                  // Résultat de l'IMC
                  if (_bmiResult.isNotEmpty) ...[
                    Text(
                      'BMI: $_bmiResult',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _bmiInterpretation,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                  const SizedBox(height: 20),
                  // Bouton pour sauvegarder et retourner
                  ElevatedButton.icon(
                    onPressed: _saveAndReturn,
                    icon: const Icon(Icons.save),
                    label: const Text('Save and Return'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
