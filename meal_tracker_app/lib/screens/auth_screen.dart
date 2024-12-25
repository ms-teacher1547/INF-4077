import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAuthForm,
              child: Text(_isLogin ? 'Login' : 'Sign Up'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(_isLogin
                  ? 'Create an account'
                  : 'Already have an account?'),
            ),
          ],
        ),
      ),
    );
  }


  void _submitAuthForm() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final auth = FirebaseAuth.instance;

    try {
      if (_isLogin) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      // Auth success: Navigate to next screen or show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication Successful')),
      );
    } on FirebaseAuthException catch (e) {
      // Handle auth errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication failed')),
      );
    }
  }

}
