import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/screens/todolist/todowidget.dart';

class FirestoreUtils {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference _todos = _firebaseFirestore.collection('todos');
  static final Stream<QuerySnapshot> collectionStreamTodo = _firebaseFirestore
      .collection('todos')
      .where('completed', isEqualTo: false)
      .orderBy('created_time', descending: true)
      .snapshots();
  static final Stream<QuerySnapshot> collectionStreamCompleted = _todos
      .where('completed', isEqualTo: true)
      .orderBy('created_time', descending: true)
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
        stream: completed ? collectionStreamCompleted : collectionStreamTodo,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.red,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              color: Colors.white,
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
              )),
            );
          final List<Todo> todoList = [];
          snapshot.data!.docs.forEach((element) {
            Todo temp = Todo(
              title: element['title'],
              completed: element['completed'],
              desc: element['desc'],
              id: element.id,
            );
            todoList.add(temp);
          });
          return todoList.isEmpty
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
                    final todo = todoList[index];
                    return TodoWidget(todo: todo);
                  },
                  separatorBuilder: (context, index) => Container(
                    height: 5,
                  ),
                  itemCount: todoList.length,
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
