import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/screens/userdetails.dart';
import 'package:taskmanager/utils/color_utils.dart';

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

  void _addTask() async {
    String task = _taskController.text.trim();
    if (task.isNotEmpty) {
      try {
        await _tasksCollection.add({'task': task, 'timestamp': DateTime.now()});
        _taskController.clear();
      } catch (error) {
        print('Failed to add task: $error');
      }
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
      try {
        await _tasksCollection.doc(taskId).update({'task': editedTask});
      } catch (error) {
        print('Failed to update task: $error');
      }
    }
  }

  void _deleteTask(String taskId) {
    try {
      _tasksCollection.doc(taskId).delete();
    } catch (error) {
      print('Failed to delete task: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserDetailsForm()),
              );
            },
          ),
        ],
        backgroundColor: hexStringToColor("627254"),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("627254"),
              hexStringToColor("76885B"),
              hexStringToColor("DDDDDD"),
              hexStringToColor("EEEEEE"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    hintText: 'Enter a task',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Add Task'),
                ),
                SizedBox(height: 16.0),
                StreamBuilder(
                  stream: _tasksCollection
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot>? tasks = snapshot.data?.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: tasks?.length ?? 0,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = tasks![index];
                          String taskId = document.id;
                          String task = (document.data()
                                  as Map<String, dynamic>?)?['task'] ??
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
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
