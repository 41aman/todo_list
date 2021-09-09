import 'package:flutter/material.dart';
import 'package:todo_list/firestore_utils/firestore_utils.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/todo_form/todoform.dart';

class TodoDialog extends StatefulWidget {
  final bool toAdd;
  const TodoDialog({Key? key, required this.toAdd}) : super(key: key);

  @override
  _TodoDialogState createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String desc = '';
  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.toAdd ? 'Add To-do' : 'Edit To-do',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TodoFormWidget(
                onChangedTitle: (title) => setState(() => this.title = title),
                onChangedDesc: (desc) => setState(() => this.desc = desc),
                onSavedTodo: addTodo,
              ),
            ],
          ),
        ),
      );

  void addTodo() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      print(isValid);
      return;
    }
    final todo = Todo(createdTime: DateTime.now(), title: title, desc: desc);
    FirestoreUtils.addTodo(todo);
    Navigator.of(context).pop();
  }
}
