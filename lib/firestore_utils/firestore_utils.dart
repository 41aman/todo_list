import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todowidget.dart';

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

  static Widget buildList(BuildContext context, bool completed) {
    return StreamBuilder<QuerySnapshot>(
        stream: collectionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting)
            return Text('Loading');
          final List<Todo> todoListAll = [];
          snapshot.data!.docs.forEach((element) {
            Todo temp = Todo(
              createdTime:
                  DateTime.parse(element['created_time'].toDate().toString()),
              title: element['title'],
              completed: element['completed'],
              desc: element['desc'],
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
                    'No To-dos',
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
}
