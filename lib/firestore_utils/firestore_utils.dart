import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

class FirestoreUtils {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference _todos = _firebaseFirestore.collection('todos');
  static final Stream<QuerySnapshot> collectionStream =
      _firebaseFirestore.collection('todos').snapshots();

  static Future<void> addTodo(Todo todo) {
    return _todos
        .add({
          'created_time': todo.createdTime,
          'title': todo.title,
          'desc': todo.desc,
          'completed': todo.completed,
        })
        .then((value) => print('added'))
        .catchError((error) => print('failure'));
  }

  static Widget buildList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: collectionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if(snapshot.connectionState == ConnectionState.waiting)
            return Text('Loading');
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
              Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),
                subtitle: Text(data['desc']),
              );
            }).toList(),
          );
        });
  }
}
