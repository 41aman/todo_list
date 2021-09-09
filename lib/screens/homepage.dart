import 'package:flutter/material.dart';
import 'package:todo_list/screens/addtodo.dart';
import 'package:todo_list/screens/todolist.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final tabs = [
    TodoList(
      completed: true,
    ),
    TodoList(completed: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_sharp),
            label: 'To-do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_sharp),
            label: 'Completed',
          )
        ],
      ),
      body: tabs[selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade400,
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => TodoDialog(
            toAdd: true,
            todo: null,
          ),
          barrierDismissible: true,
        ),
      ),
    );
  }
}
