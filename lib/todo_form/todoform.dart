import 'package:flutter/material.dart';

class TodoFormWidget extends StatelessWidget {
  final String title;
  final String desc;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDesc;
  final VoidCallback onSavedTodo;
  const TodoFormWidget({
    Key? key,
    this.title = '',
    this.desc = '',
    required this.onChangedTitle,
    required this.onChangedDesc,
    required this.onSavedTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              maxLines: 1,
              initialValue: title,
              onChanged: onChangedTitle,
              validator: (title) {
                if (title!.isEmpty) return 'The title cannot be empty';
                return null;
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Title',
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            TextFormField(
              maxLines: 4,
              initialValue: desc,
              onChanged: onChangedDesc,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Description',
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                ),
                onPressed: onSavedTodo,
                child: Text('Save'),
              ),
            )
          ],
        ),
      );
}
