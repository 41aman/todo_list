import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/firestore_utils/paginated_view.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/screens/todowidget.dart';

class FirestoreUtils {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference _todos = _firebaseFirestore.collection('todos');
  static final Stream<QuerySnapshot> collectionStreamTodo = _todos
      .where('completed', isEqualTo: false)
      .orderBy('created_time', descending: true)
      .snapshots();
  static final Stream<QuerySnapshot> collectionStreamCompleted = _todos
      .where('completed', isEqualTo: true)
      .orderBy('created_time', descending: true)
      .snapshots();

  static Future<void> addTodo(Todo todo) {
    return _todos.add({
      'created_time': FieldValue.serverTimestamp(),
      'title': todo.title,
      'desc': todo.desc,
      'completed': todo.completed,
    }).then((value) async {
      todo.documentSnapshot = await value.get();
      todo.id = value.id;
      PaginatedList.addTodo(todo);
    }).catchError((error) => print(error));
  }

  static Future<void> toggleTodo(Todo todo) async {
    bool completed = todo.completed;
    await _todos.doc(todo.id).update({'completed': !completed}).then((value) {
      print("update successful");
      PaginatedList.toggleTodo(todo.id);
    }).catchError((error) => print(error));
  }

  static Future<void> removeTodo(String id) async {
    await _todos.doc(id).delete().then((value) {
      print('delete successful');
      PaginatedList.removeTodo(id);
    }).catchError((error) => print(error));
  }

  static Future<void> editTodo(Todo todo) async {
    await _todos.doc(todo.id).update({
      'title': todo.title,
      'desc': todo.desc,
    }).then((value) {
      print('edit successful');
      PaginatedList.editTodo(todo);
    }).catchError((error) => print(error));
  }
}
