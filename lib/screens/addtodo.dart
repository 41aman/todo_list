import 'package:flutter/material.dart';
import 'package:todo_list/firestore_utils/firestore_utils.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/todo_form/todoform.dart';

class TodoDialog extends StatefulWidget {
  final Todo? todo;
  final bool toAdd;
  const TodoDialog({Key? key, required this.toAdd, required this.todo})
      : super(key: key);

  @override
  _TodoDialogState createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String desc = '';
  @override
  void initState() {
    super.initState();
    title = widget.toAdd ? '' : widget.todo!.title;
    desc = widget.toAdd ? '' : widget.todo!.desc;
  }

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
                title: title,
                desc: desc,
                onChangedTitle: (title) => setState(() => this.title = title),
                onChangedDesc: (desc) => setState(() => this.desc = desc),
                onSavedTodo: widget.toAdd ? addTodo : editTodo,
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

  void editTodo() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    widget.todo!.setTitle(title);
    widget.todo!.setDescription(desc);
    FirestoreUtils.editTodo(widget.todo!);
    Navigator.of(context).pop();
  }
}
