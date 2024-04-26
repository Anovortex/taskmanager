import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskManagerHomePage(),
    );
  }
}

class TaskManagerHomePage extends StatefulWidget {
  @override
  _TaskManagerHomePageState createState() => _TaskManagerHomePageState();
}

class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  TextEditingController _taskController = TextEditingController();

  void _addTask() {
    String task = _taskController.text.trim();
    if (task.isNotEmpty) {
      // Check if the tasks collection exists
      _firestore.collection('tasks').get().then((snapshot) {
        if (snapshot.docs.isEmpty) {
          // Create a new tasks collection
          _firestore.collection('tasks').doc().set({'task': task});
        } else {
          // Add the new task to the existing tasks collection
          _firestore.collection('tasks').add({'task': task});
        }
      }).then((value) {
        setState(() {
          _taskController.clear();
        });
      }).catchError((error) {
        print('Failed to add task: $error');
      });
    }
  }

  void _editTask(String taskId, String oldTask) async {
    String editedTask = oldTask;
    editedTask = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: TextEditingController(text: oldTask),
            onChanged: (value) => editedTask = value,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(editedTask);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (editedTask != null && editedTask.isNotEmpty && editedTask != oldTask) {
      DocumentReference taskRef = _tasksCollection.doc(taskId);
      taskRef.update({'task': editedTask}).catchError((error) {
        print('Failed to update task: $error');
      });
    }
  }

  void _deleteTask(String taskId) {
    DocumentReference taskRef = _tasksCollection.doc(taskId);
    taskRef.delete().catchError((error) {
      print('Failed to delete task: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: 'Enter a task',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addTask,
            child: Text('Add Task'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _tasksCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    String taskId = document.id;
                    // Access the 'task' field from the document data
                    String task =
                        (document.data() as Map<String, dynamic>?)?['task'] ??
                            '';

                    return ListTile(
                      title: Text(task),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editTask(taskId, task),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteTask(taskId),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
