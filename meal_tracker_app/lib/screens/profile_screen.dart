import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _caloricGoalController = TextEditingController(); // Nouveau champ
  String _bmiResult = "";
  String _bmiInterpretation = "";

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;

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
      });
    }
  }

  void _saveAndReturn() {
    final bmi = double.tryParse(_bmiResult) ?? 0; // Convertir l'IMC
    final caloricGoal = int.tryParse(_caloricGoalController.text) ?? 2000; // Convertir l'objectif calorique

    Navigator.of(context).pop({
      'bmi': bmi,
      'caloricGoal': caloricGoal,
    }); // Retourne les données à l'écran précédent
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _caloricGoalController,
              decoration: const InputDecoration(labelText: 'Daily Caloric Goal'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: const Text('Calculate BMI'),
            ),
            const SizedBox(height: 20),
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
            ElevatedButton(
              onPressed: _saveAndReturn,
              child: const Text('Save and Return'),
            ), // Bouton pour retourner les valeurs
          ],
        ),
      ),
    );
  }
}
