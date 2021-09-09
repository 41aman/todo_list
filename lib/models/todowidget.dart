import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/firestore_utils/firestore_utils.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/screens/addtodo.dart';

class TodoWidget extends StatelessWidget {
  final Todo todo;
  const TodoWidget({required this.todo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Slidable(
        child: buildTodo(context),
        actionPane: SlidableDrawerActionPane(),
        key: Key(todo.id),
        actions: [
          IconSlideAction(
            color: Colors.green,
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) =>
                  TodoDialog(toAdd: false, todo: todo),
              barrierDismissible: true,
            ),
            caption: 'Edit',
            icon: Icons.edit,
          ),
        ],
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            caption: 'Delete',
            onTap: () => FirestoreUtils.removeTodo(todo.id),
            icon: Icons.delete,
          )
        ],
      );

  Widget buildTodo(BuildContext context) => GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) =>
              TodoDialog(toAdd: false, todo: todo),
          barrierDismissible: true,
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Checkbox(
                activeColor: Theme.of(context).primaryColor,
                checkColor: Colors.white,
                value: todo.completed,
                onChanged: (_) {
                  FirestoreUtils.toggleTodo(todo);
                },
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (todo.desc.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        todo.desc,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    )
                ],
              ))
            ],
          ),
        ),
      );
}
