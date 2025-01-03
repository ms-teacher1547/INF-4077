import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'email_verification_screen.dart'; // Écran pour gérer la vérification de l'email

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Contrôleurs pour gérer les champs de saisie
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variables pour gérer l'état de l'écran
  bool _isLogin = true; // Détermine si c'est une connexion ou une inscription
  bool _isLoading = false; // Indique si une requête est en cours

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image d'arrière-plan
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fruits-and-vegetables.jpg'),
                fit: BoxFit.cover, // Adapte l'image à tout l'écran
              ),
            ),
          ),
          // Contenu au-dessus de l'image d'arrière-plan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Affiche le logo ou une image au-dessus du formulaire
                Image.asset(
                  'assets/images/certificat-authentification.png',
                  height: 150,
                ),
                const SizedBox(height: 20),
                // Titre dynamique en fonction de l'état (Login ou Sign Up)
                Text(
                  _isLogin ? 'Login' : 'Sign Up',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Champ de saisie pour l'email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                // Champ de saisie pour le mot de passe
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  obscureText: true, // Masque le mot de passe
                ),
                const SizedBox(height: 20),
                // Bouton pour soumettre le formulaire (Connexion ou Inscription)
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _submitAuthForm, // Désactiver le bouton si chargement
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isLogin ? 'Login' : 'Sign Up'),
                ),
                // Bouton pour basculer entre Connexion et Inscription
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    setState(() {
                      _isLogin = !_isLogin; // Bascule l'état
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'Create an account'
                        : 'Already have an account?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour soumettre le formulaire
  void _submitAuthForm() async {
    final email = _emailController.text.trim(); // Récupère et nettoie l'email
    final password = _passwordController.text.trim(); // Récupère et nettoie le mot de passe
    final auth = FirebaseAuth.instance; // Instance Firebase pour l'authentification

    // Affiche le spinner de chargement
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        // Connexion de l'utilisateur
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Vérifie si l'email de l'utilisateur est vérifié
        if (userCredential.user != null && !userCredential.user!.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please verify your email before logging in.'),
            ),
          );
          await auth.signOut(); // Déconnecte l'utilisateur si l'email n'est pas vérifié
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EmailVerificationScreen(),
            ), // Redirige vers l'écran de vérification d'email
          );
        } else {
          // Redirige vers l'écran d'accueil après connexion réussie
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Création d'un nouveau compte
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Envoi du mail de vérification
        await userCredential.user?.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A verification email has been sent. Please check your inbox.'),
          ),
        );
        // Déconnecte l'utilisateur après inscription
        await auth.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EmailVerificationScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication failed'),
        ),
      );
    } finally {
      // Cache le spinner de chargement
      setState(() {
        _isLoading = false;
      });
    }
  }
}
