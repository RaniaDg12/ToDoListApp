import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoList {
  String id;
  String title;
  String description;
  DateTime date;
  TimeOfDay time;
  String category;

  ToDoList({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
  });
}

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks_db');


  Color _getTaskColor(String category) {
    switch (category) {
      case 'Work':
        return Colors.deepPurpleAccent; // Example color for the Work category
      case 'Personal':
        return Colors.deepPurple.shade200; // Example color for the Personal category
      case 'Shopping':
        return Colors.deepPurple.shade100; // Example color for the Shopping category
    // Add more cases for other categories
      default:
        return Colors.deepPurple.shade50; // Default color
    }
  }


  void _showAddToDoListForm(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    DateTime _selectedDate = DateTime.now();
    TimeOfDay _selectedTime = TimeOfDay.now();
    String _selectedCategory = 'Work';

    void _selectDate() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null && pickedDate != _selectedDate) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    }

    void _selectTime() async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );

      if (pickedTime != null && pickedTime != _selectedTime) {
        setState(() {
          _selectedTime = pickedTime;
        });
      }
    }

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
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                items: ['Work', 'Personal', 'Shopping'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Category'),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _selectDate,
                      child: Icon(Icons.calendar_today),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: GestureDetector(
                        onTap: _selectDate,
                        child: Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _selectTime,
                      child: Icon(Icons.access_time),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: GestureDetector(
                        onTap: _selectTime,
                        child: Text('Time: ${_selectedTime.hour}:${_selectedTime.minute}'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String title = _titleController.text;
                String description = _descriptionController.text;

                if (title.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  DateTime selectedDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );

                  tasksCollection
                      .add({
                    'title': title,
                    'description': description,
                    'date': selectedDateTime,
                    'category': _selectedCategory,
                  })
                      .then((value) {
                    print('Task added successfully!');
                    Navigator.pop(context);
                  })
                      .catchError((error) {
                    print('Error adding task: $error');
                  });
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }






  void _showEditToDoListForm(BuildContext context, ToDoList todo) {
    final TextEditingController _titleController =
    TextEditingController(text: todo.title);
    final TextEditingController _descriptionController =
    TextEditingController(text: todo.description);
    DateTime _selectedDate = todo.date;
    TimeOfDay _selectedTime = todo.time;

    Future<void> _selectDate() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null && pickedDate != _selectedDate) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    }

    Future<void> _selectTime() async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );

      if (pickedTime != null && pickedTime != _selectedTime) {
        setState(() {
          _selectedTime = pickedTime;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit task'),
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
              GestureDetector(
                onTap: _selectDate,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10),
                    Text(
                      'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10), // Add space between date and description
              GestureDetector(
                onTap: _selectTime,
                child: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 10),
                    Text('Time: ${_selectedTime.hour}:${_selectedTime.minute}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String title = _titleController.text;
                String description = _descriptionController.text;

                if (title.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  DateTime selectedDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );

                  tasksCollection
                      .doc(todo.id)
                      .update({
                    'title': title,
                    'description': description,
                    'date': selectedDateTime,
                  })
                      .then((value) {
                    print('Task modified successfully!');
                    Navigator.pop(context);
                  })
                      .catchError((error) {
                    print('Error modifying task: $error');
                  });
                }
              },
              child: Text('Edit'),
            ),
          ],
        );
      },
    );
  }



  void _deleteToDoList(ToDoList todo) {
    tasksCollection
        .doc(todo.id)
        .delete()
        .then((value) => print('Task deleted successfully!'))
        .catchError((error) =>
        print('Error deleting task: $error'));
  }

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tasksCollection.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                List<ToDoList> filteredTodoList = snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                  Map<String, dynamic>? data =
                  document.data() as Map<String, dynamic>?;

                  if (data == null) {
                    return null;
                  }

                  return ToDoList(
                    id: document.id,
                    title: data['title'] ?? '',
                    description: data['description'] ?? '',
                    date: data['date']?.toDate() ?? DateTime.now(),
                    time: data['date'] != null
                        ? TimeOfDay.fromDateTime(data['date']!.toDate())
                        : TimeOfDay.now(),
                    category: data['category'] ?? '',
                  );
                }).where((element) {
                  return element != null &&
                      (element.title.toLowerCase().contains(_searchQuery) ||
                          element.description.toLowerCase().contains(_searchQuery));
                }).toList().cast<ToDoList>();

                return ListView.builder(
                  itemCount: filteredTodoList.length,
                  itemBuilder: (context, index) {
                    ToDoList todo = filteredTodoList[index];
                    Color taskColor = _getTaskColor(todo.category);
                    return Card(
                      color: taskColor,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(todo.title),
                            SizedBox(height: 5),
                            Text('${todo.description}'),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(width: 5),
                                Text('${todo.date.day}/${todo.date.month}/${todo.date.year}'),
                                SizedBox(width: 20),
                                Icon(Icons.access_time),
                                SizedBox(width: 5),
                                Text('${todo.time.hour}:${todo.time.minute}'),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _showEditToDoListForm(context, todo);
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                _deleteToDoList(todo);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Navigate to home screen
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
                    'userName': 'John Doe', // Replace with actual user name
                    'totalTasks': 10, // Replace with actual total tasks count
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}