import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Rediriger vers une autre page après l'inscription réussie
    } catch (e) {
      // Gérer les erreurs d'inscription
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Adresse e-mail'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('S\'inscrire'),
              onPressed: () => signUp(context),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Rediriger vers une autre page après la connexion réussie
    } catch (e) {
      // Gérer les erreurs de connexion
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Adresse e-mail'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Se connecter'),
              onPressed: () => signIn(context),
            ),
          ],
        ),
      ),
    );
  }
}