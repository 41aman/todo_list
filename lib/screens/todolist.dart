import 'package:flutter/material.dart';
import 'package:todo_list/firestore_utils/firestore_utils.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreUtils.buildList(context);
  }
}

