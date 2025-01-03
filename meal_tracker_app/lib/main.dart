import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart'; // Nouvel écran principal
import 'utils/custom_page_route.dart'; // Fichier pour gérer les transitions personnalisées

void main() async {
  // Initialisation de Firebase avant de lancer l'application Flutter.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Supprime le bandeau de débogage.
      theme: ThemeData(
        // Définition du thème clair
        primarySwatch: Colors.teal, // Couleur principale de l'application
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
          bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      darkTheme: ThemeData(
        // Définition du thème sombre
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      themeMode: ThemeMode.system, // Alterne entre clair/sombre selon les préférences système.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Écoute les changements d'état de l'utilisateur.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche un indicateur de chargement pendant la vérification de l'état.
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            // Si l'utilisateur est connecté, redirige vers l'écran principal.
            return HomeScreen();
          }
          // Sinon, reste sur l'écran d'authentification.
          return AuthScreen();
        },
      ),
      // Utilisation des transitions personnalisées pour naviguer entre les écrans.
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return CustomPageRoute(builder: (_) => HomeScreen());
          case '/auth':
            return CustomPageRoute(builder: (_) => AuthScreen());
          default:
            return MaterialPageRoute(builder: (_) => AuthScreen());
        }
      },
    );
  }
}
