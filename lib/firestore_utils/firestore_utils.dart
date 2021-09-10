import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/screens/todolist/todowidget.dart';

class FirestoreUtils {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference _todos = _firebaseFirestore.collection('todos');
  static final Stream<QuerySnapshot> collectionStream = _firebaseFirestore
      .collection('todos')
      .orderBy('created_time')
      .snapshots();

  static Future<void> addTodo(Todo todo, BuildContext context) {
    return _todos
        .add({
          'created_time': FieldValue.serverTimestamp(),
          'title': todo.title,
          'desc': todo.desc,
          'completed': todo.completed,
        })
        .then((value) {})
        .catchError((error) => print(error));
  }

  static Widget buildList(BuildContext context, bool completed) {
    return StreamBuilder<QuerySnapshot>(
        stream: collectionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              color: Colors.white,
              child: Center(
                child: SpinKitRing(
                  lineWidth: 5.0,
                  color: Colors.blueAccent,
                  size: 30,
                ),
              ),
            );
          final List<Todo> todoListAll = [];
          snapshot.data!.docs.forEach((element) async {
            Todo temp = Todo(
              title: element['title'],
              completed: element['completed'],
              desc: element['desc'],
              id: element.id,
            );
            todoListAll.add(temp);
          });
          List<Todo> todosList;
          if (completed)
            todosList =
                todoListAll.where((todo) => todo.completed == false).toList();
          else
            todosList =
                todoListAll.where((todo) => todo.completed == true).toList();
          return todosList.isEmpty
              ? Center(
                  child: Text(
                    completed ? 'No To-dos' : 'No completed To-dos',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final todo = todosList[index];
                    return TodoWidget(todo: todo);
                  },
                  separatorBuilder: (context, index) => Container(
                    height: 5,
                  ),
                  itemCount: todosList.length,
                );
        });
  }

  static Future<void> toggleTodo(Todo todo) {
    bool completed = todo.completed;
    return _todos
        .doc(todo.id)
        .update({'completed': !completed})
        .then((value) => print("update successful"))
        .catchError((error) => print(error));
  }

  static Future<void> removeTodo(String id) {
    return _todos
        .doc(id)
        .delete()
        .then((value) => print('delete successful'))
        .catchError((error) => print(error));
  }

  static Future<void> editTodo(Todo todo) {
    return _todos
        .doc(todo.id)
        .update({
          'title': todo.title,
          'desc': todo.desc,
        })
        .then((value) => print('edit successful'))
        .catchError((error) => print(error));
  }
}
