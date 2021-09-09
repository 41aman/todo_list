import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

class FirestoreUtils{
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference _todos = _firebaseFirestore.collection('todos');

  static Future<void> addTodo(Todo todo){
    return _todos.add({
      'created_time': todo.createdTime,
      'title': todo.title,
      'desc': todo.desc,
      'completed': todo.completed,
    }).then((value) => print('added')).catchError((error) => print('failure'));
  }
}