import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/firestore_utils/firestore_utils.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/screens/addtodo.dart';

class TodoWidget extends StatefulWidget {
  Function setPaginatedViewState;
  Todo? todo;
  TodoWidget(
      {required this.todo, required this.setPaginatedViewState, Key? key})
      : super(key: key);

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.todo == null) return Container();
    return Slidable(
      child: buildTodo(context),
      actionPane: SlidableDrawerActionPane(),
      key: Key(widget.todo!.id),
      actions: [
        IconSlideAction(
          color: Colors.green,
          onTap: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) =>
                  TodoDialog(toAdd: false, todo: widget.todo),
              barrierDismissible: true,
            );
            setState(() {});
          },
          caption: 'Edit',
          icon: Icons.edit,
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          color: Colors.red,
          caption: 'Delete',
          onTap: () async {
            await FirestoreUtils.removeTodo(widget.todo!.id);
            final snackBar = SnackBar(content: Text('To-do deleted'));
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            widget.setPaginatedViewState();
            setState(() {
              widget.todo = null;
            });
          },
          icon: Icons.delete,
        )
      ],
    );
  }

  Widget buildTodo(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) =>
              TodoDialog(toAdd: false, todo: widget.todo),
          barrierDismissible: true,
        );
        setState(() {});
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Checkbox(
              activeColor: Theme.of(context).primaryColor,
              checkColor: Colors.white,
              value: widget.todo!.completed,
              onChanged: (_) async {
                await FirestoreUtils.toggleTodo(widget.todo!);
                final snackBar = SnackBar(
                    content: Text(widget.todo!.completed
                        ? 'To-do completed'
                        : 'To-do marked incomplete'));
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                widget.setPaginatedViewState();
                setState(() {
                  widget.todo = null;
                });
              },
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.todo!.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (widget.todo!.desc.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text(
                      widget.todo!.desc,
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
}
