import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showSuccessMessage() {
    Fluttertoast.showToast(
      msg: "User added to Firebase successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  // Fonction pour ajouter les coordonnées de l'utilisateur à Firebase
  Future<void> addUserDetails(String username, String email) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'username': username,
      'email': email,
      // Ajoutez d'autres champs d'informations de l'utilisateur si nécessaire
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  // Autres décorations de champ d'entrée...
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  // Autres décorations de champ d'entrée...
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  // Autres décorations de champ d'entrée...
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Ajoutez une logique de validation de mot de passe supplémentaire si nécessaire
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String name = _nameController.text;
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    try {
                      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      // Appeler la fonction pour ajouter les coordonnées de l'utilisateur à Firebase
                      await addUserDetails(name, email);

                      _showSuccessMessage();

                      // Naviguer vers la page d'accueil et remplacer la pile de navigation actuelle
                      Navigator.pushReplacementNamed(context, '/tasks');

                      // Logique supplémentaire après une inscription réussie si nécessaire
                    } catch (e) {
                      // Gérer les erreurs d'inscription ici
                      print('Sign-up error: $e');
                    }
                  }
                },
                child: Text(
                  'Create',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    // Autres styles de texte...
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
