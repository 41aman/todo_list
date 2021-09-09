import 'package:flutter/material.dart';
import 'package:todo_list/firestore_utils/firestore_utils.dart';

class TodoList extends StatelessWidget {
  final bool completed;
  const TodoList({required this.completed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreUtils.buildList(context, completed);
  }
}

