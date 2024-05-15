import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final Map<String, dynamic>? data = (snapshot.data?.data() as Map<String, dynamic>?);
          final String userName = data?['username'] ?? 'User';
          final String userEmail = user.email ?? 'No Email';

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('tasks_db').snapshots(),
            builder: (context, taskSnapshot) {
              if (taskSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (taskSnapshot.hasError) {
                return Text('Error: ${taskSnapshot.error}');
              }

              int totalTasks = taskSnapshot.data?.docs.length ?? 0;

              return Scaffold(
                appBar: AppBar(
                  title: Text('My Profile'),
                  backgroundColor: Colors.purple,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/signin');
                      },
                    ),
                  ],
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile_placeholder.jpg'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Total Tasks: $totalTasks',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.home),
                        onPressed: () {
                          Navigator.pushNamed(context, '/tasks');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          _showAddToDoListForm(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/profile',
                            arguments: {
                              'userName': userName,
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return Container();
    }
  }

  // Function to show add task form
  void _showAddToDoListForm(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String title = _titleController.text;
                String description = _descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  FirebaseFirestore.instance.collection('tasks_db').add({
                    'title': title,
                    'description': description,
                  }).then((value) {
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Error adding task: $error');
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
