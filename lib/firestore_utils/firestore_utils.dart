import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreUtils{
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference _todos = _firebaseFirestore.collection('todos');

  static Future<void> addTodo(){
    return _todos.add({
      'created_time': DateTime.now(),
    }).then((value) => print('added')).catchError((error) => print('failure'));
  }
}