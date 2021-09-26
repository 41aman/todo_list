import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/screens/todolist/todowidget.dart';

class PaginatedList extends StatefulWidget {
  final bool completed;
  PaginatedList({required this.completed, Key? key}) : super(key: key);
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference _todos =
      PaginatedList.firebaseFirestore.collection('todos');

  @override
  _PaginatedListState createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList>
    with AutomaticKeepAliveClientMixin<PaginatedList> {
  static const int limit = 8;
  final ScrollController _scrollController = ScrollController();

  final List<Todo> todoList = [];
  DocumentSnapshot? lastTodo;
  DocumentSnapshot? lastComplete;

  bool isLoading = false;
  bool hasMore = true;

  getTodos() async {
    print('test');
    if (!hasMore) return;
    if (isLoading) return;
    setState(() => isLoading = true);
    QuerySnapshot querySnapshot;
    if (widget.completed ? (lastComplete == null) : (lastTodo == null)) {
      querySnapshot = await PaginatedList._todos
          .where('completed', isEqualTo: widget.completed)
          .orderBy('created_time', descending: true)
          .limit(limit)
          .get();
    } else {
      querySnapshot = await PaginatedList._todos
          .where('completed', isEqualTo: widget.completed)
          .orderBy('created_time', descending: true)
          .startAfterDocument(widget.completed ? lastComplete! : lastTodo!)
          .limit(limit)
          .get();
    }
    if (querySnapshot.size < limit) hasMore = false;
    if (widget.completed)
      lastComplete = querySnapshot.size != 0
          ? querySnapshot.docs[querySnapshot.size - 1]
          : lastComplete;
    else
      lastTodo = querySnapshot.size != 0
          ? querySnapshot.docs[querySnapshot.size - 1]
          : lastTodo;
    querySnapshot.docs.forEach((element) {
      Todo temp = Todo(
          title: element['title'],
          desc: element['desc'],
          completed: element['completed'],
          id: element.id);
      todoList.add(temp);
    });
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getTodos();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currScroll <= delta) {
        getTodos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: todoList.length == 0
              ? Center(
                  child: Text('No to-dos'),
                )
              : ListView.separated(
                  controller: _scrollController,
                  itemCount: todoList.length,
                  separatorBuilder: (context, index) => Container(
                    height: 5,
                  ),
                  itemBuilder: (context, index) {
                    Todo todo = todoList[index];
                    return TodoWidget(todo: todo);
                  },
                ),
        ),
        isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(5),
                color: Colors.yellowAccent,
                child: Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
